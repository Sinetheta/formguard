class FormActionsController < ApplicationController
  load_and_authorize_resource 

  def index
    if current_user
      @form_action = FormAction.new
      @form_actions = current_user.form_actions
    else
      redirect_to new_user_session_path 
    end
  end

  def show
    @form_action = FormActionPresenter.new FormAction.find(params[:id])
  end

  def create
    @form_action = current_user.form_actions.new(form_action_params)
    @form_action.user_id = current_user.id if current_user

    if @form_action.save
      redirect_to @form_action
    else
      flash[:danger] = "Oops! Something went wrong"
      render "index"
    end
  end

  private

  def form_action_params
    p = params.require(:form_action).permit(:name, :should_notify, {:emails => []})
    p[:emails] = params[:emails].select{ |address| Devise.email_regexp.match(address) }
      .map{ |address| address.downcase }.uniq
    p
  end
end
