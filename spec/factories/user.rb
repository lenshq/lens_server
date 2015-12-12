FactoryGirl.define do
  factory :user do
    role 'User'
  end

  factory :admin do
    role 'Admin'
  end
end
