# frozen_string_literal: true

class ShowProponent::Model::Proponent < ApplicationRecord
  has_many :addresses
  has_many :contacts
end
