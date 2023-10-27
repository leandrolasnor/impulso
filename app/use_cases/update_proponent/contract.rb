# frozen_string_literal: true

class UpdateProponent::Contract < ApplicationContract
  params do
    required(:id).filled(:integer)
    optional(:name).filled(:string)
    optional(:birthdate).filled(:date)
    optional(:contacts_attributes).array(:hash) do
      optional(:id).maybe(:integer)
      optional(:number).filled(:string)
      optional(:_destroy).maybe(:bool)
    end
    optional(:addresses_attributes).array(:hash) do
      optional(:id).maybe(:integer)
      optional(:address).filled(:string)
      optional(:number).maybe(:string)
      optional(:district).maybe(:string)
      optional(:city).maybe(:string)
      optional(:state).maybe(:string)
      optional(:zip).maybe(:string)
      optional(:_destroy).maybe(:bool)
    end
  end

  rule(:birthdate) do
    if value.present?
      age = ((Time.zone.now - value.to_time) / 1.year.seconds).floor
      key.failure(:age_must_be_between_18_80) unless (18..80).cover?(age)
    end
  end
end
