# frozen_string_literal: true

FactoryBot.define do
  factory :media_tracking do
    media_type { 'image' }
    resource_type { 'user' }
    resource_id { FFaker::Number.number(digits: 7) }
    access_url { FFaker::Internet.http_url }
  end
end
