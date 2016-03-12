class UserPolicy < BasePolicy
  def update?
    record == user
  end

  def destroy?
    record == user
  end
end
