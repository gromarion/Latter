Latter::Application.routes.draw do
  post "oauth/callback" => "oauths#callback"
  get "oauth/callback" => "oauths#callback" # for use with Github
  get "oauth/:provider" => "oauths#oauth", :as => :auth_at_provider
  delete "oauth/:provider" => "oauths#destroy", :as => :delete_oauth

  resources :games, :except => [:edit, :update] do
    post :complete, :on => :member
    resource :score, :controller => 'scores', :only => [:new, :create]
  end

  resources :statistics, :only => [:index]
  resources :players do
    resource :authentication_token, :only => [:show, :destroy]
  end

  get "/player" => "players#current", :constraints => {:format => :json}

  resources :badges, :only => [:index, :show]

  root :to => 'players#index'
  get "/pages/*slug" => "pages#show", :as => 'page'

end
