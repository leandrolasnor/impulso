# frozen_string_literal: true

class DiscountAmount::Monad
  include Dry::Monads[:try]
  include Dry.Types()
  extend  Dry::Initializer

  option :calculator, type: Instance(Proc), default: -> { proc { INSS[_1] } }, reader: :private

  def call(amount)
    Try { calculator.(amount) }
  end
end
