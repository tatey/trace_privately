Rails.application.routes.draw do
  get "/api/infected", to: "infected_keys#index"
  post "/api/submit", to: "infected_keys#create"
end
