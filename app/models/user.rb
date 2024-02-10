class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  validates :name, presence: true

  has_many :foods, foreign_key: 'user_id'
  has_many :recipes, dependent: :destroy
  has_many :inventories, foreign_key: 'users_id'

  # Add an admin attribute
  attribute :admin, :boolean, default: false

  def missing_foods
    recipes_with_foods = recipes.includes(:foods)
    food_ids_from_recipes = recipes_with_foods.flat_map { |recipe| recipe.foods.pluck(:id) }
    foods.where.not(id: food_ids_from_recipes)
  end
end
