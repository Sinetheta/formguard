Rails.application.routes.draw do
  devise_for :users

  resources :form_actions, path: 'forms', only: [:show] do
    resources :form_submissions, path: 's', only: [:create]
  end

  root 'high_voltage/pages#show', id: 'home'
end
