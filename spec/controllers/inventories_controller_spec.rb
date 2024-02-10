require 'rails_helper'
require 'faker'

RSpec.describe InventoriesController, type: :controller do
  let(:user) { create(:user) }
  let(:admin_user) { create(:user, admin: true) }
  let(:inventory) { create(:inventory, user:) }

  before do
    allow(controller).to receive(:authenticate_user!).and_return(true)
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'GET #index' do
    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end

    it 'assigns all inventories to @inventories' do
      inventory # Create an inventory before the test
      get :index
      expect(assigns(:inventories)).to eq([inventory])
    end
  end

  describe 'GET #show' do
    it 'renders the show template' do
      get :show, params: { id: inventory.id }
      expect(response).to render_template(:show)
    end

    it 'assigns the requested inventory to @inventory' do
      get :show, params: { id: inventory.id }
      expect(assigns(:inventory)).to eq(inventory)
    end
  end

  describe 'GET #new' do
    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
    end

    it 'assigns a new inventory to @inventory' do
      get :new
      expect(assigns(:inventory)).to be_a_new(Inventory)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new inventory' do
        expect do
          post :create, params: { inventory: FactoryBot.attributes_for(:inventory), user_id: user.id }
        end.to change(Inventory, :count).by(1)
      end

      it 'redirects to inventories_path' do
        post :create, params: { inventory: FactoryBot.attributes_for(:inventory), user_id: user.id }
        expect(response).to redirect_to(inventories_path)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the inventory' do
      inventory # Create an inventory before the test
      expect do
        delete :destroy, params: { id: inventory.id }
      end.to change(Inventory, :count).by(-1)
    end

    it 'redirects to inventories_path' do
      delete :destroy, params: { id: inventory.id }
      expect(response).to redirect_to(inventories_path)
    end
  end

  describe 'User permissions' do
    let(:other_user) { create(:user) }
    let(:other_inventory) { create(:inventory, user: other_user) }

    it "does not allow non-admin users to edit other user's inventory" do
      get :edit, params: { id: other_inventory.id }
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq('You do not have permission to edit this item.')
    end
  end
end
