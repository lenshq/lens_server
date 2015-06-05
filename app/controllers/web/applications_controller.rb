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

  def create
    @application = current_user.applications.create(permitted_params)
    redirect_to applications_path
  end

  def query
    @application = Application.find(params[:id])
    data = @application.run_query(params)

    render json: data
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

  def make_fake_data_for_query_response
    [
      {range: [0, 100], count: 3500},
      {range: [100, 200], count: 3000},
      {range: [200, 500], count: 2500},
      {range: [500, 750], count: 3000},
      {range: [750, 1000], count: 200}
    ]
  end


  def permitted_params
    params[:application].permit(:title, :description, :domain)
  end
end
