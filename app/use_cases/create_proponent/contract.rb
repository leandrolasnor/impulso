# frozen_string_literal: true

class CreateProponent::Contract < ApplicationContract
  params do
    required(:name).filled(:string)
    required(:taxpayer_number).filled(:integer)
    required(:birthdate).filled(:date)
    required(:contacts).array(:hash) do
      required(:number).filled(:integer)
    end
    required(:addresses).array(:hash) do
      optional(:address).filled(:string)
      optional(:number).filled(:string)
      optional(:district).filled(:string)
      optional(:city).filled(:string)
      optional(:state).filled(:string)
      required(:zip).filled(:string)
    end
  end

  rule(:taxpayer_number) do
    key.failure(:taxpayer_number_invalid) unless CPF.valid?(value, strict: true)
  end

  rule(:birthdate) do
    age = ((Time.zone.now - value.to_time) / 1.year.seconds).floor
    key.failure(:age_must_be_between_18_80) unless (18..80).cover?(age)
  end
end
