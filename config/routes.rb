Rails.application.routes.draw do
  devise_for :users

  # Define resources for recipes
  resources :recipes, only: [:index, :show, :new, :create, :destroy] do
    # Define a custom action for associating inventory with a recipe
    post 'associate_inventory', on: :member
    # Define resources for recipe foods
    resources :recipe_foods, only: [:index, :create]
  end

  # Define resources for foods
  resources :foods, except: [:index] do
    collection do
      # Define a custom action for displaying missing foods
      get 'missing_foods'
    end
  end

  # Define resources for inventories and nested resources for inventory foods
  resources :inventories do
    resources :inventory_foods, only: [:index, :new, :create, :show, :update, :destroy]
  end

  # Define routes for health check
  get "up" => "rails/health#show", as: :rails_health_check

  # Define the root path route
  root to: 'foods#index'

  # Define additional routes
  get '/generalshoppinglist', to: 'generalshoppinglist#index'
  get '/public_recipes', to: 'recipes#public_list', as: 'public_recipes'
  get '/GeneralShoppingList', to: 'general_shopping_list#index', as: 'general_shopping_list'
end
