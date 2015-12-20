class ApplicationsController < SignedApplicationController
  after_action :verify_authorized

  def index
    @applications = policy_scope(Application)
    authorize @applications
  end

  def show
    @application = find_and_authorize_application
  end

  def new
    @application = Application.new
    authorize @application
  end

  def create
    @application = Application.new application_params
    authorize @application
    if @application.save
      current_user.applications << @application
      redirect_to application_path @application
    else
      render :new
    end
  end

  def edit
    @application = find_and_authorize_application
  end

  def update
    @application = find_and_authorize_application
    if @application.update_attributes application_params
      redirect_to application_path @application
    else
      render :edit
    end
  end

  def destroy
    @application = find_and_authorize_application
    @application.destroy
    redirect_to applications_path
  end

  private

  def application_params
    params.require(:application).permit(:title, :description, :domain)
  end

  def find_and_authorize_application
    @application = policy_scope(Application).find(params[:id])
    authorize @application
    @application
  end
end
