class MembershipsController < ApplicationController
  load_and_authorize_resource

  def destroy
    if @membership.user_id == current_user.id
      flash[:error] = "Can't kill yourself!"
    else
      @membership.destroy
      flash[:notice] = "Member removed from team"
    end
    redirect_to team_path(Team.find(params[:team_id]))
  end
end
