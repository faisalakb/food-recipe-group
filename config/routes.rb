Rails.application.routes.draw do
  devise_for :users

  resources :recipes, only: [:index, :show, :new, :create, :destroy] do
    post 'associate_inventory', on: :member
  end

  resources :recipe_foods, only: [:index, :create]

  resources :inventories do
    resources :inventory_foods, only: [:index, :new, :create, :show, :update, :destroy]
  end  

  resources :foods, except: [:index] do
    collection do
      get 'missing_foods'
    end
  end

  get '/missing_foods', to: 'foods#missing_foods'
  get '/public_recipes', to: 'recipes#public_list', as: 'public_recipes'
  get 'foods/shopping_list', to: 'foods#shopping_list'
  # Defines the root path route ("/")
  root to: 'foods#index'

  get "up" => "rails/health#show", as: :rails_health_check
end
