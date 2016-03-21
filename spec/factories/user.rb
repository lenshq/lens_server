FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user_email_#{n}@example.com" }
    password '123456'
    password_confirmation '123456'
    trait :admin do
      role 'admin'
    end

    factory :admin, traits: [:admin]
  end
end
