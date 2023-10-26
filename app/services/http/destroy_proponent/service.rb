# frozen_string_literal: true

class Http::DestroyProponent::Service < Http::Service
  option :serializer,
         type: Interface(:serializer_for),
         default: -> { Http::DestroyProponent::Serializer },
         reader: :private

  option :transaction, type: Interface(:call), default: -> { DestroyProponent::Transaction }, reader: :private

  Contract = Http::DestroyProponent::Contract

  def call
    transaction.call(params) do
      _1.failure :find do |f|
        [:not_found, f.message]
      end

      _1.failure :destroy do |f|
        [:unprocessable_entity, f.message]
      end

      _1.failure do |f|
        Rails.logger.error(f)
        [:internal_server_error]
      end

      _1.success do |_destroyed|
        [:internal_server_error]
      end
    end
  end
end
