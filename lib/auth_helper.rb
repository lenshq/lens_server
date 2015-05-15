module AuthHelper
  def sign_in(user)
    session[:user_id] = user.id
  end

  def sign_out
    session[:user_id] = nil
  end

  def signed_in?
    !current_user.guest?
  end

  def authenticate_user!
    unless signed_in?
      redirect_to new_user_session_path
    end
  end

  def authenticate_admin!
    unless current_user.admin?
      redirect_to new_user_session_path
    end
  end

  def current_user
    @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]
    @current_user ||= User::Guest.new
  end
end
