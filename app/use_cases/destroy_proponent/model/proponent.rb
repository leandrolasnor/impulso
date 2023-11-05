# frozen_string_literal: true

class DestroyProponent::Model::Proponent < ApplicationRecord
  has_many :addresses, dependent: :destroy
  has_many :contacts, dependent: :destroy
end
