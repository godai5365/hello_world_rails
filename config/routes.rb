Rails.application.routes.draw do
  resources :articles
  get 'users/index'
  get 'homes/index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
