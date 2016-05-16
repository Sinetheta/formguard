class FormActionPresenter < BasePresenter
  def example_tag
    form_uri = URI::HTTP.build({host: ENV['APPLICATION_HOST'], path: action_path})
    # heroku sets a PORT automatically, it's an internal port that we don't want
    # so here we just assume that outside of dev the app is always on 80 or 443
    # both of which can be safely omitted
    if Rails.env.development?
      form_uri.port = ENV['PORT']
    end
    "<form accept-charset=\"UTF-8\" action=\"#{form_uri}\" method=\"POST\">"
  end

  private

  def action_path
    Rails.application.routes.url_helpers.form_action_form_submissions_path(@object)
  end
end
