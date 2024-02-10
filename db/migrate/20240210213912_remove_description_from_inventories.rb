class RemoveDescriptionFromInventories < ActiveRecord::Migration[7.1]
  def change
    remove_column :inventories, :description, :string
  end
end
