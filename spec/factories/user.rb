FactoryGirl.define do
  factory :user do
    name { Faker::Name.name }
    sequence(:email) { |n| n.to_s << Faker::Internet.email }
    password 'password123'
    password_confirmation 'password123'
  end
end
