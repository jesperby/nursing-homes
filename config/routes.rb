NursingHomes::Application.routes.draw do

  root :to => "nursing_homes#index"
  get    "/nursing_homes/compare" => "nursing_homes#compare", :as => :compare_nursing_homes
  get    "/nursing_homes/map" => "nursing_homes#map"
  resources :nursing_homes

  get "login", :to => "sessions#new", :as => "login"
  get "logout", :to => "sessions#destroy", :as => "logout"
  post "/sessions(.:format)", :to => "sessions#create", :as => "sessions"

  resources :users, :except => [:show, :update, :edit]
  put "/users/toggle_admin/:id" => "users#toggle_admin", :as => :toggle_admin_user
  get "/users/apply" => "users#apply", :as => :apply_user
  get "/users/search" => "users#search", :as => :search_user

  # Requests to api actions serving json[p]
  scope "api" do
    scope "1.0" do
      get "/nursing_homes(:format)" => "nursing_homes#api_index", :defaults => { :format => 'json' }, :as => :api_nursing_homes
      get "/nursing_homes/:id(:format)" => "nursing_homes#api_show", :defaults => { :format => 'json' }, :as => :api_nursing_home
    end
  end

#  mount Ckeditor::Engine => "/ckeditor"

  # Catch everything else. "a" is the path in Rails 3's routing
  match '*a', :to => 'nursing_homes#not_found', :format => false
end
