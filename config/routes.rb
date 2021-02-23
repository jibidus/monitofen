Rails.application.routes.draw do
  root 'home#index'
  resources :metrics, only: [:index] do
    resources :measures, only: [:index]
  end
end
