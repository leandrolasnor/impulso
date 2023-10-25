# frozen_string_literal: true

class UpdateProponent::Container
  extend Dry::Container::Mixin

  register 'steps.validate', -> { UpdateProponent::Steps::Validate.new }
  register 'steps.update', -> { UpdateProponent::Steps::Update.new }
end
