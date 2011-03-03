Snowfinch::Application.routes.draw do

  devise_for :users

  match "/collector" => Snowfinch::Collector

  resources :sites
  resources :users

  root :to => "sites#index"

end
