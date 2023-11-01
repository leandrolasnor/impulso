# frozen_string_literal: true

class UpdateAmountProponent::Steps::Update
  include Dry::Events::Publisher[:proponent_amount_update]
  include Dry.Types()
  extend  Dry::Initializer

  register_event 'proponent.amount.updated'

  option :calculator, type: Instance(Proc), default: -> { proc { INSS[_1] } }, reader: :private

  def call(record:, **params)
    ApplicationRecord.transaction do
      record.with_lock do
        discount_amount, fee = calculator.(params[:amount])
        record.update!(
          amount: params[:amount],
          discount_amount: discount_amount,
          fee: fee
        )
      end
      publish('proponent.amount.updated', record: record)
      record
    end
  end
end
