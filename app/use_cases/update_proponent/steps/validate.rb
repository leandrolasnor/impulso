# frozen_string_literal: true

class UpdateProponent::Steps::Validate
  include Dry.Types()
  extend  Dry::Initializer

  option :contract, type: Interface(:call), default: -> { UpdateProponent::Contract.new }, reader: :private

  def call(params)
    contract.call(params).to_monad
  end
end
