# frozen_string_literal: true

class CreateProponent::Steps::Create
  include Dry::Monads[:result]
  include Dry::Events::Publisher[:proponent_create]
  include Dry.Types()
  extend  Dry::Initializer

  register_event self.to_s.tableize

  option :model, type: Interface(:create), default: -> { CreateProponent::Model::Proponent }, reader: :private

  def call(params)
    record = model.create do
      _1.name = params[:name]
      _1.taxpayer_number = params[:taxpayer_number]
      _1.birthdate = params[:birthdate]
      _1.addresses << params[:addresses]
      _1.contacts << params[:contacts]
    end
    publish(self.to_s.tableize, record: record)
    created
  end
end
