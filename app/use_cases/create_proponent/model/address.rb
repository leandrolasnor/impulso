# frozen_string_literal: true

class CreateProponent::Model::Address < ApplicationRecord
  belongs_to :proponent
end
