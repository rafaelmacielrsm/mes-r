Rails.application.routes.draw do
  resources :batches
  resources :categories, except: :show do
    collection do
      get :query
    end
  end
  resources :products
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
