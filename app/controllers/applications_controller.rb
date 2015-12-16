class ApplicationsController < SignedApplicationController
  before_action :find_and_authorize, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized

  def index
    @applications = policy_scope(Application)
    authorize @applications
  end

  def show
  end

  def new
    @application = Application.new
    authorize @applications
  end

  def create
    @application = Application.new application_params
    authorize @applications
    if @application.save
      current_user.applications << @application
      redirect_to application_path @application
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @application.update_attributes application_params
      redirect_to application_path @application
    else
      render :edit
    end
  end

  def destroy
    @application.destroy
    redirect_to applications_path
  end

  private

  def application_params
    params.require(:application).permit(:title, :description, :domain)
  end

  def find_and_authorize
    @application = policy_scope(Application).find(params[:id])
    authorize @application
  end
end
