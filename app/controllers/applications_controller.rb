class ApplicationsController < SignedApplicationController
  def index
    @applications =
      current_user.admin? ? Application.all : current_user.applications
  end

  def show
    @application = select_source_and_find(params[:id])
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
    @application = select_source_and_find(params[:id])
  end

  def update
    @application = select_source_and_find(params[:id])
    if @application.update_attributes application_params
      redirect_to application_path @application
    else
      render :edit
    end
  end

  def destroy
    @application = select_source_and_find(params[:id])
    @application.destroy
    redirect_to applications_path
  end

  private

  def application_params
    params.require(:application).permit(:title, :description, :domain)
  end

  def select_source_and_find(application_id)
    source =
      current_user.admin? ? Application : current_user.applications
    source.find(application_id)
  end
end
