class Applications::TeamController < Applications::ApplicationController
  def index
    @application = application
    @collaborators = application.collaborators
    @avaliable_collaborators = User.where.not(id: application.collaborators.pluck(:id))
  end

  def create
    @collaborator = User.find_by(email: params[:collaborator][:email])
    application.application_users.create(user_id: @collaborator.id)

    redirect_to application_team_index_path(application)
  end

  def destroy
    if application.collaborators.count > 1
      application.application_users.where(user_id: params[:id]).destroy_all
    end

    redirect_to application_team_index_path(application)
  end
end
