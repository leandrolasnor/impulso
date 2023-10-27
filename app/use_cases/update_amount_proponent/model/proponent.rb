# frozen_string_literal: true

class UpdateAmountProponent::Model::Proponent < ApplicationRecord
  has_many :addresses
  has_many :contacts
end
