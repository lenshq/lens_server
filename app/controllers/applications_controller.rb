class ApplicationsController < ApplicationController
  def index
    @applications = current_user.applications
  end

  def show
    @application = current_user.applications.find params[:id]
  end

  def new
    @application = Application.new
  end

  def create
    @application = Application.new application_params
    if @application.save
      current_user.applications << @application
      redirect_to application_path @application
    else
      render :new
    end
  end

  def edit
    @application = current_user.applications.find params[:id]
  end

  def update
    @application = current_user.applications.find params[:id]
    if @application.update_attributes application_params
      redirect_to application_path @application
    else
      render :edit
    end
  end

  def destroy
    @application = current_user.applications.find params[:id]
    @application.destroy
    redirect_to applications_path
  end

  private

  def application_params
    params.require(:application).permit(:title, :description, :domain)
  end
end
