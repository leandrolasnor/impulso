# frozen_string_literal: true

class UpdateProponent::Steps::Update
  include Dry::Events::Publisher[:proponent_update]
  include Dry.Types()
  extend  Dry::Initializer

  register_event 'proponent.updated'

  def call(record:, **params)
    ApplicationRecord.transaction do
      record.with_lock do
        record.update!(params)
      end
      publish('proponent.updated', record: record)
      record
    end
  end
end
