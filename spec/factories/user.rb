FactoryGirl.define do
  factory :user do
    role 'user'
  end

  factory :admin do
    role 'admin'
  end
end
