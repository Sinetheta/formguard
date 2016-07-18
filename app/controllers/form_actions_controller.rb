require "filtered_form_submission"
class FormActionsController < ApplicationController
  load_and_authorize_resource
  before_action :authenticate_user!

  def index
    @form_actions = current_user.form_actions
    @form_action = FormAction.new
  end

  def show
    @form_action = FormActionPresenter.new @form_action
    @form_owner = @form_action.team_id ? @form_action.team.name : @form_action.user.email

    @graph_data = generate_graph_data

    @filtered_submissions = FilteredFormSubmission
      .new(filtered_params @form_action)
    if @filtered_submissions.valid?
      page = params[:page] || 1
      per_page = params[:per_page] || 25
      @submissions = @filtered_submissions
        .submissions
        .paginate(page: page, per_page: per_page)
    else
      @submissions = nil
      flash[:bad_dates] = "'Until' date must come after 'From' date"
    end
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

  def filtered_params form_action
    start_date =
      if params[:start_date] && !params[:start_date].empty?
        params[:start_date]
      else
        nil
      end

    end_date =
      if params[:end_date] && !params[:end_date].empty?
        params[:end_date]
      else
        nil
      end

    {start_date: start_date, end_date: end_date, form_action: form_action}
  end

  def generate_graph_data
    dates = @form_action.form_submissions
      .order(:created_at)
      .pluck(:created_at)
      .map { |sub| sub.to_date.to_s }

    graph_data = dates
      .uniq
      .map { |d| {date: d, count: dates.count(d)} }
      .to_json

    graph_data
  end

  def authenticate_user!
    unless current_user
      redirect_to new_user_session_path, error: "You need to be signed in"
    end
  end
end
