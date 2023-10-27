# frozen_string_literal: true

class UpdateProponent::Contract < ApplicationContract
  params do
    required(:id).filled(:integer)
    optional(:name).filled(:string)
    optional(:birthdate).filled(:date)
    optional(:contacts_attributes).array(:hash) do
      optional(:id).maybe(:integer)
      optional(:number).filled(:string)
      optional(:_destroy).filled(:bool)
    end
    optional(:addresses_attributes).array(:hash) do
      optional(:id).maybe(:integer)
      optional(:address).filled(:string)
      optional(:number).filled(:string)
      optional(:district).filled(:string)
      optional(:city).filled(:string)
      optional(:state).filled(:string)
      optional(:zip).filled(:string)
      optional(:_destroy).filled(:bool)
    end
  end

  rule(:birthdate) do
    if value.present?
      age = ((Time.zone.now - value.to_time) / 1.year.seconds).floor
      key.failure(:age_must_be_between_18_80) unless (18..80).cover?(age)
    end
  end
end
