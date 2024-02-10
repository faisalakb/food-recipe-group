require 'rails_helper'

RSpec.describe InventoryFood, type: :model do
  let(:user) { User.new(name: 'pepe', email: 'email1@email.com', password: 'abcdef') }
  let(:inventory) { Inventory.create(user:) }
  let(:food) do
    Food.create(
      name: 'Rice',
      measurement_unit: 'kg',
      price_dollars: 5.99
    )
  end

  subject do
    InventoryFood.new(
      quantity: 4,
      inventory:,
      food:
    )
  end

  before { subject.save }

  it 'should have an inventory' do
    expect(subject.inventory).to eq(inventory)
  end

  it 'should have a food' do
    expect(subject.food).to eq(food)
  end

  it 'should have a valid quantity' do
    subject.quantity = nil
    expect(subject).not_to be_valid
  end
end
