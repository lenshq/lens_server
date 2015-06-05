class Web::ApplicationsController <Web::ApplicationController
  def index
    @own_applications = current_user.applications
    @participate_applications = current_user.participate_applications
  end

  def new
    @application = current_user.build_application
  end

  def edit
    @application = current_user.applications.find(params[:id])
  end

  def create
    @application = current_user.applications.create(params[:application])
    redirect_to applications_path
  end

  def update
    @application = current_user.applications.find(params[:id])
    @application.update(params[:application])
    redirect_to applications_path
  end

  def destroy
    @application = current_user.applications.find(params[:id])
    @application.destroy
    redirect_to applications_path
  end
end
