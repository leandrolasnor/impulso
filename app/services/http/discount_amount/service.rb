# frozen_string_literal: true

class Http::DiscountAmount::Service < Http::Service
  option :serializer,
         type: Interface(:serializer_for),
         default: -> { Http::DiscountAmount::Serializer },
         reader: :private

  option :monad,
         type: Interface(:call),
         default: -> { DiscountAmount::Monad.new },
         reader: :private

  def call
    res = monad.(params[:id])
    return [:ok, res.value!, serializer] if res.success?

    Rails.logger.error(res.exception)
    [:not_found]
  end
end
