Rails.application.routes.draw do
  resources :form_actions, path: 'forms', only: [:show] do
    resources :form_submissions, path: 's', only: [:create]
  end
end
