module UserPopulator
  def self.via_github(user, data)
    user.build_github do |gh|
      gh.uid = data[:uid]
      gh.nickname = data[:info][:nickname]
      gh.email = data[:info][:email]
    end
  end
end
