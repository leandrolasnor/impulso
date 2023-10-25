# frozen_string_literal: true

class CreateProponent::Model::Proponent < ApplicationRecord
  include Enums::Proponent::Status
end
