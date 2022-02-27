Rails.application.routes.draw do
  root 'home#index'
  resources :metrics, only: [:index] do
    resources :measurements, only: [:index]
  end
end
