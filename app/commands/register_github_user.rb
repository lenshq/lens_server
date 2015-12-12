class RegisterGithubUser
  def initialize(auth_hash)
    @auth_hash = auth_hash
  end

  def call
    user = User.find_or_create_by!(uid: @auth_hash[:uid], role: 'User')
    update user, credentials: @auth_hash[:credentials], info: @auth_hash[:info]
    user
  end

  def self.call(*args)
    new(*args).call
  end

  private

  def update(user, credentials:, info:)
    user.update_attributes!(
      name: info[:name],
      email: info[:email],
      nickname: info[:nickname],
      image: info[:image],
      token: credentials[:token]
    )
  end
end
