class User::Guest
  def guest?
    true
  end

  def admin?
    false
  end

  def applications
    []
  end
end
