class User < ActiveRecord::Base
  has_one :github, :dependent => :destroy, :autosave => true

  def guest?
    false
  end

  def providers
    [self.github].compact
  end

  def email
    providers.first.email
  end

  def nickname
    providers.first.nickname
  end
end
