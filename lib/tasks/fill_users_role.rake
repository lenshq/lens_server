namespace :users do
  desc 'Fill users role'
  task fill_role: :environment do
    User.where(role: nil).find_each do |user|
      user.update(role: 'user')
    end
  end
end
