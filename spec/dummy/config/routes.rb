Rails.application.routes.draw do

  mount Tandem::Engine => "/"

  resources :widgets

  devise_for :users

  mount Tandem::Engine => "/tandem"

  match '/custom_route' => 'pages#index', :as => 'custom'

  root :to => 'tandem/pages#home'
end
