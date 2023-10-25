# frozen_string_literal: true

class DestroyProponent::Container
  extend Dry::Container::Mixin

  register 'steps.find', -> { DestroyProponent::Steps::Find.new }
  register 'steps.destroy', -> { DestroyProponent::Steps::Destroy.new }
end
