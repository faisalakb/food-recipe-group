# spec/views/inventories/index.html.erb_spec.rb

require 'rails_helper'

RSpec.describe 'inventories/index', type: :view do
  let(:inventory1) { FactoryBot.create(:inventory, name: 'Inventory 1', description: 'Description 1') }
  let(:inventory2) { FactoryBot.create(:inventory, name: 'Inventory 2', description: 'Description 2') }

  before do
    assign(:inventories, [inventory1, inventory2])
    render
  end

  it 'displays the heading "Inventories"' do
    expect(rendered).to have_selector('h1', text: 'Inventories')
  end

  it 'displays the "Create New Inventory" link' do
    expect(rendered).to have_link('Create New Inventory', href: new_inventory_path)
  end

  it 'displays the "Back To Home" link' do
    expect(rendered).to have_link('Back To Home', href: '/')
  end

  it 'displays inventories table with inventory names, descriptions, and remove item links' do
    expect(rendered).to have_selector('table.table')
    expect(rendered).to have_selector('thead th', text: 'Inventory')
    expect(rendered).to have_selector('thead th', text: 'Description')
    expect(rendered).to have_selector('thead th', text: 'Actions')

    expect(rendered).to have_selector('tbody tr', count: 2)

    expect(rendered).to have_link('Inventory 1', href: inventory_inventory_foods_path(inventory1))
    expect(rendered).to have_content('Description 1')
    expect(rendered).to have_link('Remove item', href: inventory_path(inventory1))

    expect(rendered).to have_link('Inventory 2', href: inventory_inventory_foods_path(inventory2))
    expect(rendered).to have_content('Description 2')
    expect(rendered).to have_link('Remove item', href: inventory_path(inventory2))
  end
end
