# frozen_string_literal: true

class DestroyProponent::Model::Address < ApplicationRecord
  belongs_to :proponent
end
