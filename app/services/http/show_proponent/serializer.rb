# frozen_string_literal: true

class Http::ShowProponent::Serializer < ActiveModel::Serializer
  attributes :id,
             :name,
             :taxpayer_number,
             :birthdate,
             :amount,
             :discount_amount

  has_many :addresses
  has_many :contacts
end

class AddressSerializer < ActiveModel::Serializer
  attributes :id, :address, :number, :district, :city, :state, :zip
end

class ContactSerializer < ActiveModel::Serializer
  attributes :id, :number
end
