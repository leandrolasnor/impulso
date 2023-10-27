# frozen_string_literal: true

class Http::DestroyProponent::Service < Http::Service
  option :serializer,
         type: Interface(:serializer_for),
         default: -> { Http::DestroyProponent::Serializer },
         reader: :private

  option :transaction, type: Interface(:call), default: -> { DestroyProponent::Transaction.new }, reader: :private

  Contract = Http::DestroyProponent::Contract.new

  def call
    transaction.call(params) do
      _1.failure :find do
        [:not_found, { error: I18n.t(:not_found) }]
      end

      _1.failure :destroy do |f|
        [:unprocessable_entity, f.message]
      end

      _1.failure do |f|
        Rails.logger.error(f)
        [:internal_server_error]
      end

      _1.success do |destroyed|
        [:ok, destroyed, serializer]
      end
    end
  end
end
