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
    @application = current_user.applications.create(permitted_params)
    redirect_to applications_path
  end

  def query
    @application = Application.find(params[:id])
  end

  def update
    @application = current_user.applications.find(params[:id])
    @application.update(permitted_params)
    redirect_to applications_path
  end

  def destroy
    @application = current_user.applications.find(params[:id])
    @application.destroy
    redirect_to applications_path
  end

  private

  def permitted_params
    params[:application].require(:application).permit(:title, :description, :domain)
  end
end
