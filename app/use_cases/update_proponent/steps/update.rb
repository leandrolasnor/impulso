# frozen_string_literal: true

class UpdateProponent::Steps::Update
  include Dry::Monads[:result]
  include Dry::Events::Publisher[:hero_edited]
  include Dry.Types()
  extend  Dry::Initializer

  register_event self.to_s.tableize

  option :model, type: Interface(:update), default: -> { UpdateProponent::Model::Proponent }, reader: :private

  def call(params)
    ApplicationRecord.transaction do
      updated = model.find(params[:id]).lock!
      updated.update!(params.to_h)
      publish(self.to_s.tableize, record: updated)
      updated
    end
  end
end
