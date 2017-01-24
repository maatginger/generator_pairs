Rails.application.routes.draw do
  root 'users#index'

  resources :users do
    get :generate_pairs, on: :collection
  end
end
