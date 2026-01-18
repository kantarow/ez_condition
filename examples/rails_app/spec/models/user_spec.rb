# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      user = User.new(
        name: 'Test User',
        email: 'test@example.com',
        role: 'member',
        department: 'engineering',
        age: 25,
        active: true
      )
      expect(user).to be_valid
    end

    it 'is invalid without a name' do
      user = User.new(name: nil)
      expect(user).not_to be_valid
    end

    it 'is invalid with an invalid role' do
      user = User.new(role: 'invalid')
      expect(user).not_to be_valid
    end
  end

  describe '#to_context' do
    it 'converts user attributes to context hash' do
      user = User.new(
        role: 'manager',
        department: 'engineering',
        age: 30,
        active: true
      )

      context = user.to_context

      expect(context).to eq({
                              'role' => 'manager',
                              'department' => 'engineering',
                              'age' => 30,
                              'active' => true
                            })
    end
  end

  describe '#can?' do
    let(:user) { User.create!(name: 'Test', email: 'test@example.com', role: 'admin', department: 'engineering', age: 30) }
    let(:resource) { Resource.create!(name: 'Test Resource', resource_type: 'document') }

    it 'returns true when a matching rule grants access' do
      AccessRule.create!(
        resource: resource,
        name: 'Admin Only',
        action: 'read',
        condition: {
          'type' => 'equal',
          'left' => { 'type' => 'var', 'name' => 'role' },
          'right' => { 'type' => 'string', 'value' => 'admin' }
        }
      )

      expect(user.can?('read', resource)).to be true
    end

    it 'returns false when no rules match' do
      expect(user.can?('write', resource)).to be false
    end
  end
end
