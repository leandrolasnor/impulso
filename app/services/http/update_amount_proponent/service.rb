# frozen_string_literal: true

class Http::UpdateAmountProponent::Service < Http::Service
  option :job, type: Interface(:perform_async), default: -> { Http::UpdateAmountProponent::Job }, reader: :private
  option :enqueuer, type: Instance(Proc), default: -> { proc { job.perform_async(_1.to_h) } }, reader: :private

  Contract = Http::UpdateAmountProponent::Contract.new

  def call
    enqueuer.(params)
    :ok
  end
end
