# frozen_string_literal: true

class DestroyProponent::Model::Proponent < ApplicationRecord
  include Enums::Proponent::Status
end
