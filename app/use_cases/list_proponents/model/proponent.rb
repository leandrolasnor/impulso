# frozen_string_literal: true

class ListProponents::Model::Proponent < ApplicationRecord
  include Enums::Proponent::Status
end
