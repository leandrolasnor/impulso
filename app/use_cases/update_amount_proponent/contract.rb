# frozen_string_literal: true

class UpdateAmountProponent::Contract < ApplicationContract
  params do
    required(:id).filled(:integer)
    required(:amount).filled(:float)
  end
end
