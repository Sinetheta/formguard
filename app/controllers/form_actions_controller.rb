class FormActionsController < ApplicationController
  load_and_authorize_resource
  before_action :authenticate_user!

  def index
    @form_actions = current_user.form_actions
    @form_action = FormAction.new
  end

  def show
    @form_action = FormActionPresenter.new FormAction.find(params[:id])

    # bucket the dates by day
    dates = @form_action.form_submissions.order(:created_at).pluck(:created_at).map { |sub| sub.to_date.to_s }
    @graph_data = dates.uniq.map { |d| {date: d, count: dates.count(d) } }.to_json
    @submissions = FormSubmission
      .where(form_action_id: @form_action.id)
      .paginate(page: params[:page], per_page: params[:per_page] ||= 25)
  end

  def create
    authorize! :create, FormAction
    @form_action = current_user.form_actions.new(form_action_params)
    @form_action.user_id = current_user.id if current_user

    if @form_action.save
      redirect_to @form_action
    else
      flash[:danger] = "Oops! Something went wrong"
      render "index"
    end
  end

  def update
    if @form_action.update_attributes(form_action_params)
      redirect_to @form_action
    else
      flash[:danger] = "Oops! Something went wrong"
      render "edit"
    end

  end

  def destroy
    @form_action.destroy
    redirect_to form_actions_path
  end

  private

  def form_action_params
    p = params.require(:form_action).permit(:name, :should_notify, {:emails => []}, :team_id)
    p[:emails] = params[:emails].select{ |address| Devise.email_regexp.match(address) }
      .map{ |address| address.downcase }.uniq
    p
  end

  def authenticate_user!
    unless current_user
      redirect_to new_user_session_path, error: "You need to be signed in"
    end
  end
end
