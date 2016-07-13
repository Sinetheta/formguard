class TeamsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def index
    @teams = current_user.teams
  end

  def create
    @team = Team.create(team_params)
    if @team.save
      @team.members << current_user
      current_user.add_role :owner, @team
      current_user.add_role :admin, @team
      flash[:notice] = "Team created!"
      redirect_to authenticated_root_path
    else
      head 500
    end
  end

  def show
    @memberships = @team.memberships.includes(:member)
    @form_actions = @team.form_actions
    @form_action = FormAction.new
  end

  def destroy
    if @team.destroy
      flash[:notice] = "Team destroyed"
    else
      flash[:error] = "Something went wrong, the team lives on"
    end
    redirect_to authenticated_root_path
  end

  def grant_ownership
    new_owner = User.find(params[:user_id])
    current_user.revoke :owner, @team
    new_owner.grant :owner, @team
    new_owner.grant :admin, @team
    redirect_to team_path(@team)
  end

  def make_admin
    admin_user = User.find(params[:user_id])
    admin_user.grant :admin, @team
    redirect_to team_path(@team)
  end

  def remove_admin
    admin_user = User.find(params[:user_id])
    admin_user.revoke :admin, @team
    redirect_to team_path(@team)
  end

  private

  def team_params
    params.require(:team).permit(:name)
  end

  def authenticate_user!
    unless current_user
      redirect_to new_user_session_path, error: "You need to be signed in"
    end
  end
end
