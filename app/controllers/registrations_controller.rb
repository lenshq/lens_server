class RegistrationsController < ApplicationController
  before_action :restrict_registration, only: [:new, :create]

  def new
    @registration = Registration.new
  end

  def create
    @registration = Registration.new(registration_params)
    if user = @registration.register
      sign_in user
      flash[:success] = t('flash.signed_up')
      redirect_to applications_path
    else
      render 'new'
    end
  end

  private

  def registration_params
    params.require(:registration).permit(:email, :password, :password_confirmation)
  end

  def restrict_registration
    redirect_to applications_path, notice: t('flash.restrict_registration') if signed_in?
  end
end
