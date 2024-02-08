class Food < ApplicationRecord
  belongs_to :user

  has_many :inventory_foods, dependent: :destroy
  validates :user_id, presence: true

  has_many :inventories, through: :inventory_foods
  has_many :recipe_foods
  has_many :recipes, through: :recipe_foods

  accepts_nested_attributes_for :recipe_foods
end
