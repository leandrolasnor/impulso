# frozen_string_literal: true

class CreateProponent::Steps::Create
  include Dry::Monads[:result]
  include Dry::Events::Publisher[:proponent_create]
  include Dry.Types()
  extend  Dry::Initializer

  register_event 'proponent.created'

  option :model, type: Interface(:create), default: -> { CreateProponent::Model::Proponent }, reader: :private
  option :calculator, type: Instance(Proc), default: -> { proc { INSS[_1] } }, reader: :private

  def call(params)
    record = model.create do
      _1.name = params[:name]
      _1.taxpayer_number = params[:taxpayer_number]
      _1.birthdate = params[:birthdate]
      _1.amount = params[:amount]
      _1.discount_amount = calculator.(_1.amount)
      _1.addresses_attributes = params[:addresses_attributes].presence || []
      _1.contacts_attributes = params[:contacts_attributes].presence || []
    end
    publish('proponent.created', record: record)
    record
  end
end
