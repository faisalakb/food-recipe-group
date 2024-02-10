inventory_food_controller.rb : class InventoryFoodsController < ApplicationController
  before_action :set_inventory

  def index
    @inventory_foods = @inventory.inventory_foods
  end

  def new
    @inventory_food = @inventory.inventory_foods.build
  end

  private

  def set_inventory
    @inventory = Inventory.find(params[:inventory_id])
  end
end
