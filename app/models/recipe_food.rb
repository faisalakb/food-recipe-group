class RecipeFood < ApplicationRecord
  belongs_to :recipe
  belongs_to :food

  def change
    remove_foreign_key :recipe_foods, :foods
    add_foreign_key :recipe_foods, :foods, on_delete: :cascade
  end
  
end
