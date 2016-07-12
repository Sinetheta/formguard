Rails.application.routes.draw do
  get 'static_pages/home'

  devise_for :users

  resources :form_actions, path: 'forms', only: [:index, :show, :create] do
    resources :form_submissions, path: 's', only: [:create, :new]
    resources :web_hooks
  end

  resources :memberships, only: :destroy, as: 'delete_team_membership'

  resources :teams do
    member do
      post 'grant_ownership'
      post 'make_admin'
      post 'remove_admin'
    end
  end

  authenticated :user do
    root 'form_actions#index', as: :authenticated_root
  end

  root 'high_voltage/pages#show', id: 'home'

end
