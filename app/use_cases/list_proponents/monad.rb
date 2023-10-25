# frozen_string_literal: true

class ListProponents::Monad
  include Dry::Monads[:result, :try]
  include Dry.Types()
  extend  Dry::Initializer

  option :model, type: Interface(:page), default: -> { ListProponents::Model::Proponent }, reader: :private

  def call(page: 1, per_page: 5)
    Try { model.page(page).per(per_page).order(id: :desc) }
  end
end
