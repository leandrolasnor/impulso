# frozen_string_literal: true

class UpdateAmountProponent::Container
  extend Dry::Container::Mixin

  register 'steps.find', -> { UpdateAmountProponent::Steps::Find.new }
  register 'steps.update', -> { UpdateAmountProponent::Steps::Update.new }
end
