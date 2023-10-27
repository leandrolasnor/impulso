# frozen_string_literal: true

FactoryBot.define do
  factory :address do
    address { Faker::Address.full_address }
    number { Faker::Address.building_number }
    district { Faker::Address.community }
    city { Faker::Address.city }
    state { Faker::Address.state }
    zip { Faker::Address.zip }

    trait :create_proponent do
      initialize_with { CreateProponent::Model::Address.new(attributes) }
    end
  end
end
