require "form_submission_search"
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
    @submissions = execute_search
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

  def render_filtered_partial
    @submissions = execute_search
    render partial: 'form_actions/filtered_submissions'
  end

  def embed
    @form_action = FormActionPresenter.new @form_action
    @embeddable_form = @form_action.embeddable_form(@form_action.example_tag)
  end

  private

  def form_action_params
    p = params.require(:form_action).permit(:name, :should_notify, {:emails => []}, :team_id, :auto_response)
    p[:emails] = params[:emails].select{ |address| Devise.email_regexp.match(address) }
      .map{ |address| address.downcase }.uniq
    p
  end

  def execute_search
    page = params[:page] || 1
    per_page = params[:per_page] || 25

    begin
      filtered_submissions = FormSubmissionSearch
        .new(params.slice(:q).merge(form_action: @form_action))
    rescue FormSubmissionSearch::InvalidSearchError
      flash.now[:error] = "'Until' date must come after 'From' date"
    end

    submissions = filtered_submissions&.search&.paginate(page: page, per_page: per_page) || nil
    submissions
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
