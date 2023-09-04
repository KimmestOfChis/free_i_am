# frozen_string_literal: true

PASSWORD = "SuperSecret_123"
FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { PASSWORD }
    password_confirmation { PASSWORD }
  end
end
