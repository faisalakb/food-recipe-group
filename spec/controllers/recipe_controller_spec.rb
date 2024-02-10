require 'rails_helper'

RSpec.describe RecipesController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:recipe) { FactoryBot.create(:recipe, user:) }

  describe 'GET #index' do
    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end

    it 'assigns all recipes to @recipes' do
      get :index
      expect(assigns(:recipes)).to eq(Recipe.all)
    end
  end

  describe 'GET #show' do
    it 'renders the show template' do
      get :show, params: { id: recipe.id }
      expect(response).to render_template(:show)
    end

    it 'assigns the requested recipe to @recipe' do
      get :show, params: { id: recipe.id }
      expect(assigns(:recipe)).to eq(recipe)
    end
  end
end
