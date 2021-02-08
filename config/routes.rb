Rails.application.routes.draw do
  resources :measures, only: [:index]
  resources :metrics, only: [:index]
end
