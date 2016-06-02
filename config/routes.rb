Well::Application.routes.draw do
  root to: "welcome#index"

  get "logout" => "sessions#destroy", as: "logout"
  get "login" => "sessions#new", as: "login"
  get "signup" => "signup#index"
  get 'demo' => "users#demo", as: "demo"
  get 'users/request_password_reset' => 'users#request_password_reset', as: "request_password_reset"
  post 'users/send_password_reset' => 'users#send_password_reset', as: "send_password_reset"
  get 'reset/(:password_reset_token)' => 'users#reset_password', as: "reset_password"
  put 'users/(:id)/update_password' => 'users#update_password', as: "update_password"

  get "/auth/:provider/callback" => "sessions#create_with_omniauth"

  get "introduction/start"
  get "introduction/trying_it"
  get "introduction/finish"
  get "quote_creation", controller: "jsonp"
  get "tag_creation", controller: "jsonp"
  resources :users, except: [:index, :update]
  resources :sessions, only: [:new, :create, :destroy]
  resources :boards, only: [:show] do
    resources :quotes, only: [:destroy, :show] do
      resources :tags, only: [:destroy, :create]
    end
  end
end
