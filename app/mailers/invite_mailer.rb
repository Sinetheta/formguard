class InviteMailer < ApplicationMailer

  def existing_user_invite(invite)
    @invite = invite
    mail(to: @invite.email, subject: "Formguard Team Invite")
  end

  def new_user_invite(invite)
    @invite = invite
    @url = new_user_registration_url(invite_token: @invite.token, email: @invite.email) 
    mail(to: @invite.email, subject: 'Join us at Formguard')
  end
end
