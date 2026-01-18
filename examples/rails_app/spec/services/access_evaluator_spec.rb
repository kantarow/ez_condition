# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AccessEvaluator do
  let(:user) do
    User.new(
      role: 'manager',
      department: 'engineering',
      age: 30,
      active: true
    )
  end

  describe '#evaluate' do
    context 'with a simple condition' do
      let(:access_rule) do
        AccessRule.new(
          condition: {
            'type' => 'equal',
            'left' => { 'type' => 'var', 'name' => 'role' },
            'right' => { 'type' => 'string', 'value' => 'manager' }
          }
        )
      end

      it 'returns true when condition is met' do
        evaluator = described_class.new(access_rule, user)
        expect(evaluator.evaluate).to be true
      end
    end

    context 'with a compound AND condition' do
      let(:access_rule) do
        AccessRule.new(
          condition: {
            'type' => 'and',
            'left' => {
              'type' => 'equal',
              'left' => { 'type' => 'var', 'name' => 'department' },
              'right' => { 'type' => 'string', 'value' => 'engineering' }
            },
            'right' => {
              'type' => 'equal',
              'left' => { 'type' => 'var', 'name' => 'role' },
              'right' => { 'type' => 'string', 'value' => 'manager' }
            }
          }
        )
      end

      it 'returns true when both conditions are met' do
        evaluator = described_class.new(access_rule, user)
        expect(evaluator.evaluate).to be true
      end
    end

    context 'with a compound OR condition' do
      let(:access_rule) do
        AccessRule.new(
          condition: {
            'type' => 'or',
            'left' => {
              'type' => 'equal',
              'left' => { 'type' => 'var', 'name' => 'role' },
              'right' => { 'type' => 'string', 'value' => 'admin' }
            },
            'right' => {
              'type' => 'equal',
              'left' => { 'type' => 'var', 'name' => 'department' },
              'right' => { 'type' => 'string', 'value' => 'engineering' }
            }
          }
        )
      end

      it 'returns true when at least one condition is met' do
        evaluator = described_class.new(access_rule, user)
        expect(evaluator.evaluate).to be true
      end
    end

    context 'with invalid condition' do
      let(:access_rule) { AccessRule.new(condition: nil) }

      it 'returns false' do
        evaluator = described_class.new(access_rule, user)
        expect(evaluator.evaluate).to be false
      end
    end
  end
end
