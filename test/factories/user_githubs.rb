# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_github, :class => 'User::Github' do
    user nil
    uid "MyString"
  end
end
