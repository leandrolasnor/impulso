# frozen_string_literal: true

class CreateProponent::Transaction
  include Dry::Transaction(container: CreateProponent::Container)

  step :validate, with: 'steps.validate'
  try :create, with: 'steps.create', catch: StandardError
end
