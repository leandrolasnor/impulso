# frozen_string_literal: true

class UpdateAmountProponent::Steps::Find
  include Dry.Types()
  extend  Dry::Initializer

  option :model, type: Interface(:find), default: -> { UpdateAmountProponent::Model::Proponent }, reader: :private

  def call(params)
    params.to_h.merge(record: model.find(params[:id]))
  end
end
