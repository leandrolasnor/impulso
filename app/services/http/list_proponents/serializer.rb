# frozen_string_literal: true

class Http::ListProponents::Serializer < ActiveModel::Serializer
  attributes :id,
             :name,
             :taxpayer_number,
             :birthdate,
             :amount,
             :discount_amount

  def amount
    object.amount.to_s
  end

  def discount_amount
    object.discount_amount.to_s
  end
end
