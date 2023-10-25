# frozen_string_literal: true

class DestroyProponent::Steps::Destroy
  include Dry::Monads[:result]

  def call(proponent)
    proponent.destroy!
  end
end
