Snowfinch::Application.routes.draw do

  devise_for :users

  #match "/collector" => Snowfinch::Collector

  resources :sites do
    member do
      get :counters
      get :chart
    end

    resources :sensors
  end

  resources :users

  root :to => "sites#index"

end
