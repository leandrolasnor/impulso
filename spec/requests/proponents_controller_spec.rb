# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe ProponentsController do
  path '/v1/proponents/list' do
    get('list proponent') do
      tags 'Proponents'
      parameter name: :page, in: :query, type: :integer, description: 'pagination'
      parameter name: :per_page, in: :query, type: :integer, description: 'pagination'
      response(200, 'successful') do
        let(:proponents) { create_list(:proponent, 5) }
        let(:page) { 2 }
        let(:per_page) { 2 }

        let(:expected_body) do
          {
            id: be_a(Integer),
            name: be_a(String),
            taxpayer_number: be_a(String),
            birthdate: be_a(String),
            amount: be_a(String),
            discount_amount: be_a(String)
          }
        end

        before do |example|
          proponents
          submit_request(example.metadata)
        end

        it 'returns a valid 200 response' do |_example|
          expect(response).to have_http_status(:ok)
          expect(parsed_body.first).to match(expected_body)
          expect(parsed_body.count).to eq(per_page)
        end
      end
    end
  end

  path '/v1/discount_amount/{amount}' do
    parameter name: 'amount', in: :path, type: :string, description: 'amount'
    get('discount_amount proponent') do
      tags 'Proponent'
      response(200, 'successful') do
        let(:amount) { 2780.77 }
        let(:expected_body) { 255.23 }

        run_test! do |response|
          expect(response).to have_http_status(:ok)
          expect(parsed_body).to eq(expected_body)
        end
      end
    end
  end

  path '/v1/proponents' do
    post('create proponent') do
      tags 'Proponent'
      consumes "application/json"
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string, required: true },
          taxpayer_number: { type: :integer },
          birthdate: { type: :number, required: true },
          amount: { type: :number, required: true },
          contacts_attributes: {
            type: :array,
            items: {
              type: :object,
              properties: {
                number: { type: :string }
              }
            },
            required: [:number]
          },
          addresses_attributes: {
            type: :array,
            items: {
              type: :object,
              properties: {
                address: { type: :string },
                number: { type: :string },
                district: { type: :string },
                city: { type: :string },
                state: { type: :string },
                zip: { type: :string }
              }
            },
            required: [:address, :number, :district, :city, :state, :zip]
          }
        },
        required: [:name, :taxpayer_number, :birthdate, :amount]
      }
      response(201, 'successful') do
        let(:name) { 'Proponent Name' }
        let(:taxpayer_number) { CPF.generate }
        let(:birthdate) { '1992-02-28' }
        let(:amount) { 1988.20 }
        let(:discount_amount) { INSS[amount] }
        let(:contact) { build(:contact).attributes }
        let(:address) { build(:address).attributes }

        let(:params) do
          {
            name: name,
            taxpayer_number: taxpayer_number,
            birthdate: birthdate,
            amount: amount,
            contacts_attributes: [contact],
            addresses_attributes: [address]
          }
        end

        let(:expected_body) do
          {
            id: be_a(Integer),
            name: name,
            taxpayer_number: taxpayer_number,
            birthdate: birthdate,
            amount: amount.to_s,
            discount_amount: discount_amount.to_s,
            contacts: [
              {
                id: be_a(Integer),
                number: contact['number'][1..]
              }
            ],
            addresses: [
              {
                id: be_a(Integer),
                address: address['address'],
                city: address['city'],
                district: address['district'],
                number: address['number'],
                state: address['state'],
                zip: address['zip']
              }
            ]
          }
        end

        run_test! do |response|
          expect(response).to have_http_status(:created)
          expect(parsed_body).to match(expected_body)
        end
      end
    end
  end

  path '/v1/proponents/{id}/update_amount' do
    patch('update proponent amount') do
      tags 'Proponents'
      consumes "application/json"
      parameter name: :id, in: :path, type: :string, description: 'id'
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: { amount: { type: :number } },
        required: [:amount]
      }
      response(200, 'successful') do
        let(:proponent) { create(:proponent, amount: old_amount) }
        let(:id) { proponent.id }
        let(:old_amount) { 1320.40 }
        let(:amount) { 2788.30 }
        let(:params) { { amount: amount } }

        let(:expected_body) do
          {
            id: be_a(Integer),
            name: proponent.name,
            taxpayer_number: proponent.taxpayer_number,
            birthdate: proponent.birthdate.to_date.to_s,
            amount: amount.to_s,
            discount_amount: INSS[amount].to_s
          }
        end

        run_test! do |response|
          expect(response).to have_http_status(:ok)
          expect(parsed_body).to match(expected_body)
          expect { proponent.reload }.to change(proponent, :amount).from(old_amount).to(amount)
        end
      end
    end
  end

  path '/v1/proponents/{id}' do
    get('show proponent') do
      tags 'Proponents'
      parameter name: :id, in: :path, type: :string, description: 'id'
      response(404, 'not found') do
        let(:id) { 0 }
        let(:expected_body) { { error: I18n.t(:not_found) } }

        run_test! do |response|
          expect(response).to have_http_status(:not_found)
          expect(parsed_body).to eq(expected_body)
        end
      end

      response(200, 'successful') do
        let(:proponent) { create(:proponent) }
        let(:id) { proponent.id }

        let(:expected_body) do
          {
            id: id,
            name: proponent.name,
            taxpayer_number: proponent.taxpayer_number,
            birthdate: proponent.birthdate.to_date.to_s,
            amount: proponent.amount.to_s,
            discount_amount: proponent.discount_amount.to_s,
            contacts: [],
            addresses: []
          }
        end

        run_test! do |response|
          expect(response).to have_http_status(:ok)
          expect(parsed_body).to eq(expected_body)
        end
      end
    end

    put('update proponent') do
      tags 'Proponents'
      consumes "application/json"
      parameter name: :id, in: :path, type: :string, description: 'id'
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string, required: true },
          birthdate: { type: :number, required: true },
          contacts_attributes: {
            type: :array,
            items: {
              type: :object,
              properties: {
                number: { type: :string }
              }
            },
            required: [:number]
          },
          addresses_attributes: {
            type: :array,
            items: {
              type: :object,
              properties: {
                address: { type: :string },
                number: { type: :string },
                district: { type: :string },
                city: { type: :string },
                state: { type: :string },
                zip: { type: :string }
              }
            },
            required: [:address, :number, :district, :city, :state, :zip]
          }
        },
        required: [:name, :taxpayer_number, :birthdate, :amount]
      }
      response(404, 'not found') do
        let(:id) { 0 }
        let(:expected_body) { { error: I18n.t(:not_found) } }
        let(:params) { nil }

        run_test! do |response|
          expect(response).to have_http_status(:not_found)
          expect(parsed_body).to eq(expected_body)
        end
      end

      response(200, 'successful') do
        let(:proponent) { create(:proponent) }
        let(:id) { proponent.id }
        let(:name) { 'Proponent Name' }
        let(:birthdate) { '1992-02-28' }
        let(:contact) { build(:contact).attributes }
        let(:address) { build(:address).attributes }

        let(:params) do
          {
            name: name,
            birthdate: birthdate.to_date.to_s,
            contacts_attributes: [contact],
            addresses_attributes: [address]
          }
        end

        let(:expected_body) do
          {
            id: be_a(Integer),
            name: name,
            taxpayer_number: proponent.taxpayer_number,
            birthdate: birthdate,
            amount: proponent.amount.to_s,
            discount_amount: proponent.discount_amount.to_s,
            contacts: [
              {
                id: be_a(Integer),
                number: contact['number']
              }
            ],
            addresses: [
              {
                id: be_a(Integer),
                address: address['address'],
                city: address['city'],
                district: address['district'],
                number: address['number'],
                state: address['state'],
                zip: address['zip']
              }
            ]
          }
        end

        run_test! do |response|
          expect(response).to have_http_status(:ok)
          expect(parsed_body).to match(expected_body)
        end
      end
    end

    delete('delete proponent') do
      tags 'Proponents'
      parameter name: :id, in: :path, type: :string, description: 'id'
      response(200, 'successful') do
        let(:proponent) { create(:proponent) }
        let(:id) { proponent.id }

        let(:expected_body) do
          {
            id: id,
            name: proponent.name,
            taxpayer_number: proponent.taxpayer_number,
            birthdate: proponent.birthdate.to_date.to_s,
            amount: proponent.amount.to_s,
            discount_amount: proponent.discount_amount.to_s,
            contacts: [],
            addresses: []
          }
        end

        run_test! do |response|
          expect(response).to have_http_status(:ok)
          expect(parsed_body).to eq(expected_body)
        end
      end
    end
  end
end
