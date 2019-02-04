Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  namespace :api, defaults: { format: 'json' } do
    resources :games, only: %w[create show new_roll] do
      post 'new_roll', on: :member
    end
  end
end
