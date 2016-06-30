class TeamsController < ApplicationController

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

  private

  def team_params
    params.require(:team).permit(:name)
  end
  
end
