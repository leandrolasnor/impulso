# frozen_string_literal: true

class Http::ShowProponent::Service < Http::Service
  option :serializer,
         type: Interface(:serializer_for),
         default: -> { Http::ShowProponent::Serializer },
         reader: :private

  option :monad,
         type: Interface(:call),
         default: -> { ShowProponent::Monad.new },
         reader: :private

  def call
    res = monad.call(params[:id])

    return [:ok, res.value!, serializer] if res.success?

    [:not_found, { error: I18n.t(:not_found) }]
  end
end
