Latter::Application.routes.draw do
  devise_for :players, controllers: { omniauth_callbacks: "players/omniauth_callbacks" }

  devise_scope :player do
    delete 'sign_out', to: 'devise/sessions#destroy', as: :destroy_player_session
  end

  resources :games, except: [:edit, :update] do
    post :complete, on: :member
    resource :score, controller: 'scores', only: [:new, :create]
  end

  resources :statistics, only: [:index]
  resources :players do
  end

  get "/player" => "players#current", constraints: { format: :json }

  resources :badges, only: [:index, :show]

  root to: 'players#index'
  get "/pages/*slug" => "pages#show", as: 'page'

end
