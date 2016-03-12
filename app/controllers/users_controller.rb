class UsersController < SignedApplicationController
  before_action :sign_check, only: [:new, :create]
  before_action :authenticate!, only: [:edit, :update, :destroy]

  def new
    @user = User.new
    authorize @user
  end

  def create
    @user = User.new(user_params)
    authorize @user
    if @user.save
      sign_in @user
      redirect_to applications_url
    else
      render 'new'
    end
  end

  def edit
    user
  end

  def update
    user
    if @user.update(user_params)
      flash[:success] = "Profile updated"
      redirect_to edit_user_path(@user)
    else
      render 'edit'
    end
  end

  def destroy
    user
    @user.destroy
    flash[:success] = "User deleted"
    redirect_to root_url
  end

  private

  def sign_check
    redirect_to root_path, notice: 'You are already signed in' if current_user
  end

  def user
    @user = User.find(params[:id])
    authorize @user
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
