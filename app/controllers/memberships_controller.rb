class MembershipsController < ApplicationController
  load_and_authorize_resource

  def destroy
    if @membership.team.owner == current_user
      flash[:error] = "Transfer ownership before removing yourself."
    else
      @membership.destroy
      flash[:notice] = "Member removed from team"
    end
    redirect_to team_path(@membership.team)
  end
end
