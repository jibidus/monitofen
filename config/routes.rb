Rails.application.routes.draw do
  root 'home#index'
  resources :measures, only: [:index]
  resources :metrics, only: [:index]
end
