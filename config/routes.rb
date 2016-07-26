Rails.application.routes.draw do
  get 'static_pages/home'

  devise_for :users, controllers: { registrations: 'users/registrations' }

  resources :form_actions, path: 'forms' do
    resources :form_submissions, path: 's', only: [:create, :new]
    resources :web_hooks
  end

  resources :form_submissions, path: 'submissions', only: [:update]
  resources :memberships, only: :destroy, as: 'delete_team_membership'

  resources :teams do
    member do
      post 'grant_ownership'
      post 'make_admin'
      post 'remove_admin'
    end
  end

  resources :invites

  authenticated :user do
    root 'form_actions#index', as: :authenticated_root
  end

  root 'high_voltage/pages#show', id: 'home'

  get 'submissions/:id/download' => "form_submissions#download_attachment"
  get 'forms/:id/filtered_submissions' => "form_actions#render_filtered_partial"

end
