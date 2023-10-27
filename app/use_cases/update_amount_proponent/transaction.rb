# frozen_string_literal: true

class UpdateAmountProponent::Transaction
  include Dry::Transaction(container: UpdateAmountProponent::Container)

  step :validate, with: 'steps.validate'
  try :find, with: 'steps.find', catch: ActiveRecord::RecordNotFound
  try :update, with: 'steps.update', catch: StandardError
end
