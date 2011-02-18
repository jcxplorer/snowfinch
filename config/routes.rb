Snowfinch::Application.routes.draw do

  devise_for :users

  resources :sites
  resources :users

  root :to => "sites#index"

end
