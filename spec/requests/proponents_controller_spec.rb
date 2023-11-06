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

        context 'on success' do
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
  end

  path '/v1/discount_amount/{amount}' do
    parameter name: 'amount', in: :path, type: :string, description: 'amount'
    get('discount_amount proponent') do
      tags 'Discount Amount'
      response(200, 'successful') do
        let(:amount) { 2780.77 }
        let(:expected_body) { 255.22 }

        run_test! do |response|
          expect(response).to have_http_status(:ok)
          expect(parsed_body).to eq(expected_body)
        end
      end
    end
  end

  path '/v1/proponents/report' do
    get('report') do
      tags 'Proponents'
      response(200, 'successful') do
        let(:expected_body) do
          {
            '0.075' => be_a(Integer),
            '0.09' => be_a(Integer),
            '0.12' => be_a(Integer),
            '0.14' => be_a(Integer)
          }
        end

        let(:proponents) do
          create_list(:proponent, 2, fee: "0.075")
          create_list(:proponent, 3, fee: "0.09")
          create_list(:proponent, 4, fee: "0.12")
          create_list(:proponent, 5, fee: "0.14")
        end

        context 'on success' do
          before do |example|
            proponents
            submit_request(example.metadata)
          end

          it 'returns a valid 200 response' do |_example|
            expect(response).to have_http_status(:ok)
            expect(parsed_body.stringify_keys).to match(expected_body)
          end
        end
      end
    end
  end

  path '/v1/proponents' do
    post('create proponent') do
      tags 'Proponents'
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

      response(422, 'invalid params') do
        let(:params) do
          {
            proponent: {
              name: '',
              taxpayer_number: '',
              birthdate: '',
              amount: '',
              contacts_attributes: [{ number: '' }]
            }
          }
        end

        let(:expected_body) do
          {
            amount: ["must be filled"],
            birthdate: ["must be filled"],
            name: ["must be filled"],
            taxpayer_number: ["must be filled"],
            contacts_attributes: { '0' => { number: ['must be filled'] } }.symbolize_keys
          }
        end

        run_test! do |response|
          expect(response).to have_http_status(:unprocessable_entity)
          expect(parsed_body).to eq(expected_body)
        end
      end

      response(201, 'successful') do
        let(:name) { 'Proponent Name' }
        let(:taxpayer_number) { CPF.generate }
        let(:birthdate) { '1992-02-28' }
        let(:amount) { 1988.20 }
        let(:discount_amount) { INSS[amount].first }
        let(:contact) { build(:contact).attributes }
        let(:address) { build(:address).attributes }

        let(:params) do
          {
            proponent: {
              name: name,
              taxpayer_number: taxpayer_number,
              birthdate: birthdate,
              amount: amount,
              contacts_attributes: [contact],
              addresses_attributes: [address]
            }
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
        let(:id) { 0 }
        let(:amount) { 2788.30 }
        let(:params) { { id: "0", amount: amount } }

        context 'on success' do
          before do |example|
            allow(Http::UpdateAmountProponent::Job).to receive(:perform_async).with(params.stringify_keys)
            submit_request(example.metadata)
          end

          it 'returns a valid 200 response' do |_example|
            expect(response).to have_http_status(:ok)
            expect(parsed_body).to be_nil
            expect(Http::UpdateAmountProponent::Job).to have_received(:perform_async).with(params.stringify_keys)
          end
        end
      end

      response(422, 'successful') do
        let(:id) { 0 }
        let(:amount) { -1234 }
        let(:params) { { id: "0", amount: amount } }

        let(:expected_body) do
          {
            amount: ["must be greater than 0"]
          }
        end

        context 'on failure' do
          before do |example|
            allow(Http::UpdateAmountProponent::Job).to receive(:perform_async).with(params.stringify_keys)
            submit_request(example.metadata)
          end

          it 'returns a valid 200 response' do |_example|
            expect(response).to have_http_status(:unprocessable_entity)
            expect(parsed_body).to eq(expected_body)
            expect(Http::UpdateAmountProponent::Job).not_to have_received(:perform_async).with(params.stringify_keys)
          end
        end
      end

      response(422, 'successful') do
        let(:id) { 0 }
        let(:amount) { 100000000 }
        let(:params) { { id: "0", amount: amount } }

        let(:expected_body) do
          {
            amount: ["must be less than 100000000"]
          }
        end

        context 'on failure' do
          before do |example|
            allow(Http::UpdateAmountProponent::Job).to receive(:perform_async).with(params.stringify_keys)
            submit_request(example.metadata)
          end

          it 'returns a valid 200 response' do |_example|
            expect(response).to have_http_status(:unprocessable_entity)
            expect(parsed_body).to eq(expected_body)
            expect(Http::UpdateAmountProponent::Job).not_to have_received(:perform_async).with(params.stringify_keys)
          end
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
        let(:id) { proponent.id }
        let(:proponent) do
          p = create(:proponent)
          contact.proponent_id = p.id
          address.proponent_id = p.id
          contact.save
          address.save
          p
        end
        let(:contact) { build(:contact) }
        let(:address) { build(:address) }

        let(:expected_body) do
          {
            id: id,
            name: proponent.name,
            taxpayer_number: proponent.taxpayer_number,
            birthdate: proponent.birthdate.to_date.to_s,
            amount: proponent.amount.to_s,
            discount_amount: proponent.discount_amount.to_s,
            contacts: [
              {
                id: be_a(Integer),
                number: contact.number
              }
            ],
            addresses: [
              {
                id: be_a(Integer),
                address: address.address,
                number: address.number,
                district: address.district,
                city: address.city,
                state: address.state,
                zip: address.zip
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

      response(422, 'invalid params') do
        let(:proponent) { create(:proponent) }
        let(:id) { proponent.id }
        let(:birthdate) { '2010-02-28' }

        let(:params) do
          {
            name: '',
            birthdate: birthdate.to_date.to_s,
            contacts_attributes: [{ number: nil }],
            addresses_attributes: [{ address: '' }]
          }
        end

        let(:expected_body) do
          {
            addresses_attributes: {
              '0': {
                address: ["must be filled"]
              }
            },
            contacts_attributes: {
              '0': {
                number: ["must be filled"]
              }
            },
            birthdate: ["Age must be between 18 and 80 years old"],
            name: ["must be filled"]
          }
        end

        run_test! do |response|
          expect(response).to have_http_status(:unprocessable_entity)
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
      response(404, 'successful') do
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
  end
end
