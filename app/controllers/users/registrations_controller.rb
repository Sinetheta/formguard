class Users::RegistrationsController < Devise::RegistrationsController

  def new
    super do
      @token = params[:invite_token]
    end
  end

  def create
    super do |user|
      if @token = params[:user][:invite_token]
        team = Invite.find_by!(token: @token).team
        team.members << user
        flash[:notice] = "You have been added to team: #{team.name}"
      end
    end
  end
  
  def update
    super
  end

  private

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, :invite_token)
  end

  def account_update_params
    params.require(:user).permit(:email, :password, :password_confirmation, :current_password, :invite_token)
  end
end
