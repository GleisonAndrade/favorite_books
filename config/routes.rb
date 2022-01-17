Rails.application.routes.draw do  
  get "welcome/index"  
  root to: "welcome#index"
  
  devise_for :users

  resources :books do
    patch :favorite, on: :member
  end
end  
