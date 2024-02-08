class FoodsController < ApplicationController
  before_action :authenticate_user!

  def index
    @is_active = true
    if params[:id] == 'missing_foods'
      missing_foods
      render :missing_foods
    else
      @foods = Food.all
    end
  end

  def show
    if params[:id] == 'missing_foods'
      missing_foods
      render :missing_foods
    else
      @food = Food.find(params[:id])
    end
  end

  def new
    @food = Food.new
    @food.recipe_foods.build
  end

  def create
    @food = current_user.foods.new(food_params)

    # Associate food with recipe if recipe_id is present
    if params[:food][:recipe_id].present?
      recipe = Recipe.find(params[:food][:recipe_id])
      @food.recipes << recipe
    end
    
    if @food.save
      redirect_to foods_path, notice: 'Food was successfully created.'
    else
      render :new
    end
  end

  def update
    @food = Food.find(params[:id])
    if @food.update(food_params)
      redirect_to foods_path, notice: 'Food was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @food = Food.find(params[:id])
    # Delete associated records in the RecipeFood join table
    @food.recipe_foods.destroy_all
    # Now delete the food record
    @food.destroy
    redirect_to foods_path, notice: 'Food was successfully deleted.'
  end
  

  private

  def food_params
    params.require(:food).permit(:name, :measurement_unit, :price, recipe_foods_attributes: [:quantity])
  end
end
