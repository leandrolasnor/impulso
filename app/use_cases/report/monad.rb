# frozen_string_literal: true

class Report::Monad
  include Dry::Monads[:try]
  include Dry.Types()
  extend  Dry::Initializer

  option :model, type: Interface(:group), default: -> { Report::Model::Proponent }, reader: :private

  def call
    Try { model.group(:fee).count }
  end
end
