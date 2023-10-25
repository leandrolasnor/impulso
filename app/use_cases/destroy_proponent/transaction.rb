# frozen_string_literal: true

class DestroyProponent::Transaction
  include Dry::Transaction(container: DestroyProponent::Container)

  try :find, with: 'steps.find', catch: ActiveRecord::RecordNotFound
  try :destroy, with: 'steps.destroy', catch: ActiveRecord::RecordNotDestroyed
end
