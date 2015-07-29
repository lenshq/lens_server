FactoryGirl.define do
  factory :application do
    sequence(:title) { |n| "title #{n}" }
    sequence(:description) { |n| "description #{n}" }
  end
end
