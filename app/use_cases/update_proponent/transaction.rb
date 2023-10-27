# frozen_string_literal: true

class UpdateProponent::Transaction
  include Dry::Transaction(container: UpdateProponent::Container)

  step :validate, with: 'steps.validate'
  try :find, with: 'steps.find', catch: ActiveRecord::RecordNotFound
  try :update, with: 'steps.update', catch: StandardError
end
