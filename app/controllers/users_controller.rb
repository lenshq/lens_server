class UsersController < ApplicationController
  def show
    @user = user
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      redirect_to applications_url
    else
      render 'new'
    end
  end

  def edit
    @user = user
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    user.destroy
    flash[:success] = "User deleted"
    redirect_to root_url
  end

  private

  def user
    User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
