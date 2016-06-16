class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    if current_user
      redirect_to authenticated_root_path, alert: exception.message
    else
      redirect_to root_path, alert: exception.message 
    end 
  end
  def current_ability
    @current_ability ||= Ability.new(current_user)
  end

end
