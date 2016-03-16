class UserPolicy < BasePolicy
  def update?
    record.model == user
  end

  def destroy?
    record == user
  end
end
