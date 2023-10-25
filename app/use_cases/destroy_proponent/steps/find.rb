# frozen_string_literal: true

class DestroyProponent::Steps::Find
  include Dry::Monads[:result]
  include Dry.Types()
  extend  Dry::Initializer

  option :model, type: Interface(:find), default: -> { DestroyProponent::Model::Proponent }, reader: :private

  def call(params)
    model.find(params[:id])
  end
end
