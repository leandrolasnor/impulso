# frozen_string_literal: true

class Http::DiscountAmount::Contract < ApplicationContract
  params do
    required(:amount).filled(:float)
  end
end
