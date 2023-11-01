# frozen_string_literal: true

require 'rails_helper'
RSpec.describe Http::UpdateAmountProponent::Job do
  let(:old_amount) { 1122.22 }
  let(:amount) { 1234.21 }
  let(:proponent) { create(:proponent, amount: old_amount) }
  let(:params) { { id: proponent.id, amount: amount } }
  let(:perform) { described_class.new.perform(params) }

  context 'on success' do
    it 'must be able to update amounts proponent' do
      expect do
        perform
      end.to change { proponent.reload.amount }.from(old_amount).to(amount)
    end
  end

  context 'on failure' do
    context 'on record not found' do
      let(:params) { { id: 0, amount: amount } }

      before do
        allow(Rails.logger).to receive(:error)
        perform
      end

      it 'must be able to logger error message' do
        expect(Rails.logger).to have_received(:error)
      end
    end

    context 'on record not updated' do
      let(:params) { { id: proponent.id, amount: amount } }
      let(:exception) { StandardError.new('Error') }

      before do
        allow(UpdateAmountProponent::Model::Proponent).to receive(:find).with(proponent.id).and_return(proponent)
        allow(proponent).to receive(:update!).and_raise(exception)
        allow(Rails.logger).to receive(:error).with(exception)
        perform
      end

      it 'must be able to logger error message' do
        expect(Rails.logger).to have_received(:error).with(exception)
      end
    end
  end
end
