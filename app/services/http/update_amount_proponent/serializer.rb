# frozen_string_literal: true

class Http::UpdateAmountProponent::Serializer < ActiveModel::Serializer
  attributes :id,
             :name,
             :taxpayer_number,
             :birthdate,
             :amount,
             :discount_amount
end
