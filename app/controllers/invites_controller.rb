class InvitesController < ApplicationController

  def create
    emails = params[:emails]
    emails.pop if emails.last == ""
    team = Team.find params[:invite][:team_id]
    emails.each do |email|
      invite = Invite.create(invite_params)
      authorize! :create, invite
      invite.email = email
      invite.sender = current_user
      invite.add_recipient_to_invite_if_user_exists
      if invite.save
        invite.add_recipient_to_team
        flash[:notice] = "Invite sent"
      else
        flash[:error] = invite.errors.full_messages.to_sentence
      end
    end
    redirect_to team_path(team)
  end

  def invite_params
    params.require(:invite).permit(:email, :team_id, :sender_id, :recipient_id, :token)
  end
end
