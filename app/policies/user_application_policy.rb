class UserApplicationPolicy < BasePolicy
  def show?
    scope.where(id: record.id).exists? && admin_or_belongs_to_user
  end

  def update?
    admin_or_belongs_to_user
  end

  def destroy?
    admin_or_belongs_to_user
  end

  private

  def admin_or_belongs_to_user
    user.admin? || user.applications.include?(record)
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user.admin?
        scope.all
      else
        user.applications
      end
    end
  end
end
