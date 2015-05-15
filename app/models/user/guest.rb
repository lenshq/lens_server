class User::Guest
  def guest?
    true
  end

  def admin?
    false
  end
end
