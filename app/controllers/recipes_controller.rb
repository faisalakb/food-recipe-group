class RecipesController < ApplicationController
  before_action :authenticate_user!, only: %i[new create]

  def index
    @recipes = Recipe.includes(recipe_foods: [:food])
    calculate_totals(@recipes)
  end

  def new
    @recipe = Recipe.new
  end

  def create
    @recipe = current_user.recipes.build(recipe_params)

    if @recipe.save
      redirect_to recipes_path, notice: 'Recipe was successfully created.'
    else
      render :new
    end
  end

  def destroy
    @recipe = Recipe.find(params[:id])
    @recipe.recipe_foods.destroy_all # Manually delete associated recipe_foods
    authorize! :destroy, @recipe
    @recipe.destroy
    redirect_to recipes_path, notice: 'Recipe was successfully deleted.'
  end

  def show
    @recipe = Recipe.includes(foods: :inventories).find(params[:id])
    @foods = @recipe.foods
    @inventories = Inventory.all # This line might cause N+1 query issue
  end
  

  def associate_inventory
    @recipe = Recipe.find(params[:id])
    inventory_id = params[:inventory_id]

    if inventory_id.present?
      inventory = Inventory.find(inventory_id)
      @recipe.update(inventory:)
      redirect_to inventory_path(inventory), notice: 'Inventory generated successfully!'
    else
      redirect_to @recipe, alert: 'Please select an inventory.'
    end
  end

  def public_list
    @public_recipes = Recipe.where(public: true).includes(recipe_foods: [:food])
    calculate_totals(@public_recipes)
  end

  private

  def recipe_params
    params.require(:recipe).permit(:name, :preparation_time, :cooking_time, :public, :description)
  end

  def calculate_totals(recipes)
    @total_food_items = calculate_total_food_items(recipes)
    @total_price = calculate_total_price(recipes)
  end

  def calculate_total_food_items(recipes)
    return 0 unless recipes

    recipes.sum { |recipe| sum_food_quantity(recipe) }
  end

  def sum_food_quantity(recipe)
    recipe.foods.sum(&:quantity)
  end

  def calculate_total_price(recipes)
    return 0 unless recipes

    recipes.sum { |recipe| sum_food_price(recipe) }
  end

  def sum_food_price(recipe)
    recipe.foods.sum { |rf| rf.quantity * rf.price }
  end
end
