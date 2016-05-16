Rails.application.routes.draw do
  devise_for :users

  resources :form_actions, path: 'forms', only: [:index, :show, :create] do
    resources :form_submissions, path: 's', only: [:create]
  end

  authenticated :user do
    root 'form_actions#index', as: :authenticated_root
  end

  root 'high_voltage/pages#show', id: 'home'
end
