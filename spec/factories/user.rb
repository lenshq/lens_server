FactoryGirl.define do
  factory :user do
  end

  factory :admin do
    role 'admin'
  end
end
