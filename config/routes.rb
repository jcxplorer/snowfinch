Snowfinch::Application.routes.draw do

  devise_for :users

  unless Snowfinch.configuration[:mount_collector] == false
    match "/collector" => Snowfinch::Collector
  end

  resources :sites do
    member do
      get :counters
      get :chart
    end

    resources :sensors do
      member do
        get :chart
      end
    end

    resources :pages do
      collection do
        post :find
      end
      member do
        get :counters
        get :chart
      end
    end
  end

  resources :users
  resource :account

  root :to => "sites#index"

end
