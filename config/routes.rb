Rails.application.routes.draw do  
  get "welcome/index"  
  root to: "books#index"  
  
  devise_for :users
  resources :books
end  
