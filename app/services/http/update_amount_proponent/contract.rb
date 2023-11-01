# frozen_string_literal: true

class Http::UpdateAmountProponent::Contract < ApplicationContract
  params do
    required(:id).filled(:integer)
    required(:amount).filled(:float).value(gt?: 0, lt?: 100000000)
  end
end
