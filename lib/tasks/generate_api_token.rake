namespace :users do
  desc 'Generate API token for users'
  task generate_api_token: :environment do
    User.where(api_token: nil).find_each do |user|
      user.generate_api_token
      user.save
    end
  end
end
