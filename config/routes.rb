Rails.application.routes.draw do
  resources :batches
  resources :categories, except: :show
  resources :products
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
