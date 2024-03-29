Rails.application.routes.draw do
  resources :links

  get "up" => "rails/health#show", as: :rails_health_check
  get "/shortener", to: "shortener#create"

  get "/track/:hash", to: "clicks#track"
  root "links#index"
end
