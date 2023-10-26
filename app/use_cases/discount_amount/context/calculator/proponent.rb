# frozen_string_literal: true

class DiscountAmount::Context::Calculator::Proponent
  include Dry.Types()
  extend Dry::Initializer

  param :proponent, type: Instance(DiscountAmount::Model::Proponent), reader: :private

  option :calculator_discount, type: Instance(Proc), default: -> { proc { INSS[_1] } }

  def discount_amount!
    proponent.discount_amount = calculate_discount
    calculate_discount
  end

  private

  def calculate_discount
    @calculate_discount ||= calculator_discount.(proponent.amount)
  end
end
