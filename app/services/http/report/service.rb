# frozen_string_literal: true

class Http::Report::Service < Http::Service
  option :monad,
         type: Interface(:call),
         default: -> { Report::Monad.new },
         reader: :private

  def call
    res = monad.call

    return [:ok, res.value!] if res.success?

    Rails.logger.error(res.exception)
    [:internal_server_error]
  end
end
