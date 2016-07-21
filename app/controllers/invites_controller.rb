class InvitesController < ApplicationController
  load_and_authorize_resource

  def create
    @invite.sender = current_user
    @invite.add_recipient_to_invite_if_user_exists
    if @invite.save
      @invite.add_recipient_to_team
      flash[:notice] = "Invite sent"
    else
      flash[:error] = "Something went wrong"
    end
    redirect_to team_path(@invite.team)
  end

  def invite_params
    params.require(:invite).permit(:email, :team_id, :sender_id, :recipient_id, :token)
  end
end
