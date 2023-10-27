# frozen_string_literal: true

class UpdateProponent::Steps::Find
  include Dry.Types()
  extend  Dry::Initializer

  option :model, type: Interface(:find), default: -> { UpdateProponent::Model::Proponent }, reader: :private

  def call(params)
    params.to_h.merge(record: model.find(params[:id]))
  end
end
