class Web::ApplicationsController <Web::ApplicationController
  def index
    @own_applications = current_user.applications
    @participate_applications = current_user.participate_applications
  end

  def new
    @application = current_user.applications.build
  end

  def edit
    @application = current_user.applications.find(params[:id])
  end

  def show
    @application = current_user.participate_applications.find(params[:id])
  end

  def create
    @application = current_user.applications.new(permitted_params)
    if @application.save
      redirect_to applications_path
    else
      render :new
    end
  end

  def update
    @application = current_user.applications.find(params[:id])
    if @application.update(permitted_params)
      redirect_to applications_path
    else
      render :edit
    end
  end

  def destroy
    @application = current_user.applications.find(params[:id])
    @application.destroy
    redirect_to applications_path
  end

  private

  def permitted_params
    params[:application].permit(:title, :description, :domain, colleague_ids: [])
  end
end
