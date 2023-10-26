# frozen_string_literal: true

class DiscountAmount::Model::Proponent < ApplicationRecord
  delegate :discount_amount!, to: :calculator

  private

  def calculator
    @calculator ||= DiscountAmount::Context::Calculator::Proponent.new(self)
  end
end
