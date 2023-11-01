# frozen_string_literal: true

FactoryBot.define do
  factory :proponent do
    name { Faker::Name.unique.name }
    taxpayer_number { CPF.generate }
    birthdate { 30.years.ago.to_date }
    amount { Faker::Number.decimal(l_digits: 4, r_digits: 2) }
    discount_amount { INSS[amount] }
    fee { ['0.075', '0.09', '0.12', '0.14'].sample }

    trait :create_proponent do
      initialize_with { CreateProponent::Model::Proponent.new(attributes) }
    end
  end
end
