# frozen_string_literal: true

class Http::DiscountAmount::Service < Http::Service
  option :monad, type: Interface(:call), default: -> { DiscountAmount::Monad.new }, reader: :private

  Contract = Http::DiscountAmount::Contract.new

  def call
    res = monad.(params[:amount])
    return [:ok, res.value!] if res.success?

    Rails.logger.error(res.exception)
    [:unprocessable_entity]
  end
end
