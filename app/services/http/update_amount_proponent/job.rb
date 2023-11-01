# frozen_string_literal: true

class Http::UpdateAmountProponent::Job
  include Sidekiq::Worker
  include Dry.Types()
  extend Dry::Initializer

  sidekiq_options retry: 1

  option :transaction, type: Interface(:call), default: -> { UpdateAmountProponent::Transaction.new }, reader: :private

  def perform(params)
    params.symbolize_keys!
    transaction.call(params) do
      _1.failure :find do |f|
        Rails.logger.error(f.exception)
      end

      _1.failure do |f|
        Rails.logger.error(f)
      end

      _1.success {}
    end
  end
end
