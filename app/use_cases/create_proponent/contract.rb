# frozen_string_literal: true

class CreateProponent::Contract < ApplicationContract
  params do
    required(:name).filled(:string)
    required(:taxpayer_number).filled(:string)
    required(:birthdate).filled(:date)
    required(:amount).filled(:float)
    optional(:contacts_attributes).array(:hash) do
      required(:number).filled(:integer)
    end
    optional(:addresses_attributes).array(:hash) do
      required(:address).filled(:string)
      required(:number).filled(:string)
      required(:district).filled(:string)
      required(:city).filled(:string)
      required(:state).filled(:string)
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
