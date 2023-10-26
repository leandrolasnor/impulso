# frozen_string_literal: true

class Http::DestroyProponent::Contract < ApplicationContract
  params do
    required(:id).filled(:integer)
  end
end
