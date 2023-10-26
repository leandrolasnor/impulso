# frozen_string_literal: true

class Http::ListProponents::Contract < ApplicationContract
  params do
    required(:page).filled(:integer)
    optional(:per_page).filled(:integer)
  end
end
