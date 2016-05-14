Rails.application.routes.draw do
  resources :form_actions, path: 'forms', only: [:show]
end
