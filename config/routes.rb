Rails.application.routes.draw do
  get "/api/infected", to: "infected_keys#index"
  post "/api/submit", to: "infected_keys#create"

  namespace :admin do
    resources :submissions, only: [:index, :show, :update]
  end

  root to: "admin/submissions#index"
end
