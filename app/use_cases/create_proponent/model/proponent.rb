# frozen_string_literal: true

class CreateProponent::Model::Proponent < ApplicationRecord
  has_many :contacts, dependent: :destroy
  has_many :addresses, dependent: :destroy

  accepts_nested_attributes_for :contacts, allow_destroy: true
  accepts_nested_attributes_for :addresses, allow_destroy: true
end
