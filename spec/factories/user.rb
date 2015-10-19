FactoryGirl.define do
  factory :user do
    token { SecureRandom.hex }
  end
end
