# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Todo, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      todo = build(:todo)
      expect(todo).to be_valid
    end

    it 'is invalid without a title' do
      todo = build(:todo, title: nil)
      expect(todo).not_to be_valid
      expect(todo.errors[:title]).to include("can't be blank")
    end

    it 'is invalid without a description' do
      todo = build(:todo, description: nil)
      expect(todo).not_to be_valid
      expect(todo.errors[:description]).to include("can't be blank")
    end
  end

  describe 'associations' do
    it 'belongs to user' do
      association = described_class.reflect_on_association(:user)
      expect(association.macro).to eq(:belongs_to)
    end
  end
end





