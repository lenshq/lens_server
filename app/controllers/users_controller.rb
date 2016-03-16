class UsersController < SignedApplicationController
  before_action :sign_check, only: [:new, :create]
  before_action :authenticate!, only: [:edit, :update, :destroy]

  def new
    create_user
  end

  def create
    create_user
    if @user.validate(user_params) && @user.save
      sign_in @user
      redirect_to applications_url
    else
      render 'new'
    end
  end

  def edit
    set_user
  end

  def update
    set_user
    if @user.validate(user_params) && @user.save
      flash[:success] = 'Profile updated'
      redirect_to edit_user_path(@user)
    else
      render 'edit'
    end
  end

  def destroy
    authorize current_user
    current_user.destroy
    flash[:success] = 'User deleted'
    redirect_to root_url
  end

  private

  def sign_check
    redirect_to root_path, notice: 'You are already signed in' if current_user
  end

  def set_user
    @user = UserForm.new(current_user)
    authorize @user
  end

  def create_user
    @user = UserForm.new(User.new)
    authorize @user
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
