FactoryGirl.define do
  factory :user do
    trait :admin do
      role 'admin'
    end

    factory :admin, traits: [:admin]
  end
end
