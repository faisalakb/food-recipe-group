class AddInventoryIdToRecipes < ActiveRecord::Migration[7.1]
  def change
    add_column :recipes, :inventory_id, :integer
  end
end
