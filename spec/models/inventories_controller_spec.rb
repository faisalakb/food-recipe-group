require 'rails_helper'

RSpec.describe InventoriesController, type: :controller do
  describe 'POST #create' do
    let(:user) { create(:user) }
  
    context 'with valid parameters' do
      it 'creates a new inventory' do
        inventory_params = { name: 'New Inventory', description: 'Sample Description', users_id: user.id }
  
        expect {
          post :create, params: { inventory: inventory_params }
        }.to change(Inventory, :count).by(1)
      end
  
      it 'assigns the current user as the owner of the inventory' do
        inventory_params = { name: 'New Inventory', description: 'Sample Description', users_id: user.id }
  
        post :create, params: { inventory: inventory_params }
  
        expect(assigns(:inventory).user).to eq(user)
      end
  
      it 'redirects to the inventories index page' do
        inventory_params = { name: 'New Inventory', description: 'Sample Description', users_id: user.id }
  
        post :create, params: { inventory: inventory_params }
  
        expect(response).to redirect_to(inventories_path(user))
      end
  
      it 'sets a success notice' do
        inventory_params = { name: 'New Inventory', description: 'Sample Description', users_id: user.id }
  
        post :create, params: { inventory: inventory_params }
  
        expect(flash[:notice]).to eq('Inventory was successfully created.')
      end
    end
  
    context 'with invalid parameters' do
      it 'does not create a new inventory' do
        inventory_params = { name: '', description: 'Sample Description', users_id: user.id }
  
        expect {
          post :create, params: { inventory: inventory_params }
        }.not_to change(Inventory, :count)
      end
  
      it 'renders the new template' do
        inventory_params = { name: '', description: 'Sample Description', users_id: user.id }
  
        post :create, params: { inventory: inventory_params }
  
        expect(response).to render_template(:new)
      end
    end
  end
end
