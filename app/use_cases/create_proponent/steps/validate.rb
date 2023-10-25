# frozen_string_literal: true

class CreateHero::Steps::Validate
  include Dry::Monads[:result]
  include Dry.Types()
  extend  Dry::Initializer

  option :contract, type: Interface(:call), default: -> { CreateProponent::Contract.new }, reader: :private

  def call(params)
    contract.call(params).to_monad
  end
end
