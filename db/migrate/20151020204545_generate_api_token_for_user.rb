class GenerateApiTokenForUser < ActiveRecord::Migration
  def up
    User.find_each do |user|
      user.generate_api_token
      user.save
    end
  end

  def down
    User.update_all api_token: nil
  end
end
