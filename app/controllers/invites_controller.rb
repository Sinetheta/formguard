class InvitesController < ApplicationController

  def create
    invite = Invite.new(invite_params)
    invite.sender_id = current_user.id
    invite.add_recipient_to_invite_if_user_exists
    if invite.save
      invite.add_recipient_to_team
      flash[:notice] = "Invite sent"
    else
      flash[:error] = "Something went wrong"
    end
    redirect_to team_path(invite.team)
  end

  def invite_params
    params.require(:invite).permit(:email, :team_id, :sender_id, :recipient_id, :token)
  end
end
