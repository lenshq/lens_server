FactoryGirl.define do
  factory :application do
    sequence(:domain) { |n| "localhost#{n}" }
    sequence(:title) { |n| "title #{n}" }
    sequence(:description) { |n| "description #{n}" }
  end
end
