# frozen_string_literal: true

class Http::CreateProponent::Serializer < ActiveModel::Serializer
  attributes :id,
             :name,
             :taxpayer_number,
             :birthdate

  has_many :addresses
  has_many :contacts
end