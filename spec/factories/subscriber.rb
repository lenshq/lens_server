FactoryGirl.define do
  factory :subscriber do
    email { generate :email }
    name { generate :name }
  end
end
