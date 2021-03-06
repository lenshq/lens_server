class UsersController < SignedApplicationController
  before_action :sign_check, only: [:new, :create]
  before_action :authenticate!, only: [:edit, :update, :destroy]

  def new
    @user = NewUserForm.new(User.new)
    authorize @user
  end

  def create
    @user = NewUserForm.new(User.new)
    authorize @user
    if @user.validate(user_params(:new_user)) && @user.save
      sign_in @user
      flash[:success] = t('users.flash.create')
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
    if @user.validate(user_params(:update_user)) && @user.save
      flash[:success] = t('users.flash.update')
      redirect_to edit_user_path(@user)
    else
      render 'edit'
    end
  end

  def destroy
    authorize current_user
    current_user.destroy
    flash[:success] = t('users.flash.destroy')
    redirect_to root_url
  end

  private

  def sign_check
    redirect_to root_path, notice: t('users.flash.already_signed_in') if current_user
  end

  def set_user
    @user = UpdateUserForm.new(current_user)
    authorize @user
  end

  def user_params(value = nil)
    params.require(value || :user).permit(:email, :password, :password_confirmation)
  end
end
