Rails.application.routes.draw do
  namespace :api, defaults: { format: 'json' } do
    resources :games, only: %w[create show new_roll] do
      post 'new_roll', on: :member
    end
  end
end
