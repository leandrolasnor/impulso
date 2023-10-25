# frozen_string_literal: true

class CreateProponent::Container
  extend Dry::Container::Mixin

  register 'steps.validate', -> { CreateProponent::Steps::Validate.new }
  register 'steps.create', -> { CreateProponent::Steps::Create.new }
end
