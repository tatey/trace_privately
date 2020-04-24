Rails.application.routes.draw do
  namespace :api do
    get "infected", to: "infected_keys#index"
    post "submit", to: "infected_keys#create"
  end

  namespace :admin do
    resources :submissions, only: [:index, :show, :update]
  end

  root to: "admin/submissions#index"
end
