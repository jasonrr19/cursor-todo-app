# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    display_name { Faker::Name.name }
    theme_preference { 'system' }
  end
end
