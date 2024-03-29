class InventoriesController < ApplicationController
  before_action :set_inventory, only: %i[edit update destroy]
  before_action :validate_user, only: %i[edit update destroy]

  def index
    @inventories = Inventory.includes(:inventory_foods).all
  end

  def show
    @inventory = Inventory.includes(:inventory_foods).find(params[:id])
  end

  def new
    @inventory = Inventory.new
  end

  def create
    @inventory = Inventory.new(inventory_params)
    @inventory.user = current_user
    if @inventory.save
      redirect_to inventories_path, notice: 'Inventory was successfully created.'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @inventory.update(inventory_params)
      redirect_to @inventory, notice: 'Inventory was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @inventory.destroy
    redirect_to inventories_url, notice: 'Inventory was successfully destroyed.'
  end

  private

  def validate_user
    return if @inventory && (current_user == @inventory.user || current_user.admin?)

    flash[:alert] = 'You do not have permission to edit this item.'
    redirect_back fallback_location: root_path
  end

  def set_inventory
    @inventory = Inventory.find(params[:id])
  end

  def inventory_params
    params.require(:inventory).permit(:name, :description, :user_id)
  end
end
