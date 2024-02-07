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
  end

  def create
    @food = current_user.foods.new(food_params)
    if params[:recipe_id].present? # Check if recipe_id is present in the params
      @food.recipes << Recipe.find(params[:recipe_id]) # Associate the food with the specified recipe
    end
    if @food.save
      redirect_to foods_path, notice: 'Food was successfully created.'
    else
      render :new
    end
  end

  def update
    @food = Food.find(params[:id])
    @food.attributes = food_params
    if params[:recipe_id].present? # Check if recipe_id is present in the params
      @food.recipes << Recipe.find(params[:recipe_id]) # Associate the food with the specified recipe
    end
    if @food.save
      redirect_to foods_path, notice: 'Food was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @food = Food.find(params[:id])

    # Delete associated recipe_foods records
    @food.recipe_foods.destroy_all

    # Now, you can safely delete the food
    @food.destroy
    redirect_to foods_path, notice: 'Food was successfully deleted.'
  end

  private

  def food_params
    params.require(:food).permit(:name, :measurement_unit, :price, :quantity)
  end
end
