class RegisterGithubUser
  def initialize(auth_hash)
    @auth_hash = auth_hash
  end

  def call
    user = User.find_by(uid: @auth_hash[:uid])
    user.role = :user unless user.persisted?
    update user, credentials: @auth_hash[:credentials], info: @auth_hash[:info]
    user
  end

  def self.call(*args)
    new(*args).call
  end

  private

  def update(user, credentials:, info:)
    user.assign_attributes(
      email: info[:email],
      name: info[:name],
      nickname: info[:nickname],
      image: info[:image],
      token: credentials[:token]
    )
    user.assign_attributes(password: SecureRandom.hex(10)) unless user.persisted?
    user.save
  end
end
