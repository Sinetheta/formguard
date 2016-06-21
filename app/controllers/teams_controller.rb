class TeamsController < ApplicationController

  def index
    @teams = current_user.teams
  end

  def create
    @team = Team.create(team_params)
    if @team.save
      @team.members << current_user
      flash[:notice] = "Team created!"
      redirect_to authenticated_root_path
    else
      head 500
    end
  end

  def show
    team = Team.find(params[:id])
    @members = team.members
  end

  private

  def team_params
    params.require(:team).permit(:name)
  end
  
end
