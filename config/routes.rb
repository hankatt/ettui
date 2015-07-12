Well::Application.routes.draw do

  get "logout" => "sessions#destroy", :as => "logout"
  get "login" => "sessions#new", :as => "login"
  get "signup(/:signup_type)" => "users#new", :as => "signup"
  get "users/introduction" => "users#introduction", :as => "introduction"
  get "users/bookmarklet" => "bookmarklet#show", :as => "bookmarklet"
  get 'add/quote' => "quotes#add_quote"
  get 'add/tag_remotely' => "tags#add_tag_remote"
  get 'add/tag_locally' => "quotes#add_tag_local"
  get 'add/tag_input' => "quotes#append_tag_input"
  delete 'tag/:tag_id/:id/remove' => "quotes#remove_tag", :as => "remove_tag"
  get 'users/omniauth/update' => "users#update_all_user_omniauth_data", :as => "omniauth_update"
  get 'quotes/readability/update' => 'quotes#update_readability_data'
  get 'users/done' => "users#done", :as => "continue"
  get '/demo' => "users#demo", :as => "demo"
  get '/boards/demo' => "boards#demo", :as => "boards_demo"

  get "/auth/:provider/callback" => "sessions#create_with_omniauth"

  resources :users, except: :index
  resources :sessions, only: [:new, :create, :destroy]
  resources :boards, except: :update do
    resources :quotes, only: [:destroy, :show] do
      get :filter, on: :collection
      resources :tags, only: [:destroy, :create]
    end
  end
  root :to => "welcome#index"
end
