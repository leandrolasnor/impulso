# frozen_string_literal: true

class ShowProponent::Monad
  include Dry::Monads[:result, :try]
  include Dry.Types()
  extend  Dry::Initializer

  option :model, type: Interface(:find), default: -> { ShowProponent::Model::Proponent }, reader: :private

  def call(id)
    Try(ActiveRecord::RecordNotFound) { model.find(id) }
  end
end
