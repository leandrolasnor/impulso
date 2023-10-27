# frozen_string_literal: true

class UpdateProponent::Model::Proponent < ApplicationRecord
  has_many :contacts
  has_many :addresses

  accepts_nested_attributes_for :contacts, allow_destroy: true
  accepts_nested_attributes_for :addresses, allow_destroy: true
end
