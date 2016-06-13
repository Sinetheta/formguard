Rails.application.routes.draw do
  devise_for :users

  authenticate :user do
    resources :form_actions, path: 'forms' do
      resources :form_submissions, path: 's', only: [:create]
    end
  end

  authenticated :user do
    root 'form_actions#index', as: :authenticated_root
  end

  root 'high_voltage/pages#show', id: 'home'
end
