Rails.application.routes.draw do
  get 'static_pages/home'

  devise_for :users

  resources :form_actions, path: 'forms' do
    resources :form_submissions, path: 's', only: [:create, :new]
    resources :web_hooks
  end

  resources :teams

  authenticated :user do
    root 'form_actions#index', as: :authenticated_root
  end

  root 'high_voltage/pages#show', id: 'home'

end
