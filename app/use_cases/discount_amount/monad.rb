# frozen_string_literal: true

class DiscountAmount::Monad
  include Dry::Monads[:result, :try]
  include Dry.Types()
  extend  Dry::Initializer

  option :model, type: Interface(:find), default: -> { DiscountAmount::Model::Proponent }, reader: :private

  def call(id)
    Try(ActiveRecord::RecordNotFound) { model.find(id) }.fmap { _1.discount_amount! && _1 }
  end
end
