class FormActionPresenter < BasePresenter
  def example_tag
    "<form accept-charset=\"UTF-8\" action=\"#{build_form_uri}\" method=\"POST\">"
  end

  def build_form_uri
    URI::HTTP.build({host: ENV['APPLICATION_HOST'], path: action_path})
  end

  private
  def action_path
    Rails.application.routes.url_helpers.form_action_form_submissions_path(@object)
  end
end
