# frozen_string_literal: true

class UpdateProponent::Contract < ApplicationContract
  params do
    optional(:name).filled(:string)
    optional(:taxpayer_number).filled(:integer)
    optional(:birthdate).filled(:date)
    optional(:contacts).array(:hash) do
      optional(:number).filled(:integer)
    end
    optional(:addresses).array(:hash) do
      optional(:_id).filled(:integer)
      optional(:address).filled(:string)
      optional(:number).filled(:string)
      optional(:district).filled(:string)
      optional(:city).filled(:string)
      optional(:state).filled(:string)
      optional(:zip).filled(:string)
    end
  end

  rule(:taxpayer_number) do
    return unless key?(:taxpayer_number)

    key.failure(:taxpayer_number_invalid) unless CPF.valid?(value, strict: true)
  end

  rule(:birthdate) do
    return unless key?(:birthdate)

    age = ((Time.zone.now - value.to_time) / 1.year.seconds).floor
    key.failure(:age_must_be_between_18_80) unless (18..80).cover?(age)
  end
end
