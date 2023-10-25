# frozen_string_literal: true

module Enums::Proponent::Status
  extend ActiveSupport::Concern

  included do
    enum :status, [:disabled, :enabled]
  end
end
