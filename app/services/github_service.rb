class GithubService < NetworkService

  def register(data)
    auth = User::Github.find_by_uid(data[:uid].to_s)
    if auth
      self.update_information(auth, data[:info])
      user = auth.user
      return user
    end

    user = User.new
    UserPopulator.via_github(user, data)
    user.save!
    user
  end

  protected

  def update_information(github_user, information)
    github_user.nickname = information[:nickname]
    github_user.email = information[:email]
    github_user.save!
  end
end
