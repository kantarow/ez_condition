# frozen_string_literal: true

require 'spec_helper'

RSpec.describe EzCondition::Term::BinaryOperator do
  describe '#initialize' do
    let(:left_operand) { EzCondition::Term::Boolean.new(value: 'true') }
    let(:right_operand) { EzCondition::Term::Boolean.new(value: 'false') }

    context '正常なケース' do
      it '左右のオペランドを設定できる' do
        operator = described_class.new(left: left_operand, right: right_operand)
        expect(operator.left).to eq(left_operand)
        expect(operator.right).to eq(right_operand)
      end
    end

    context '左オペランドがnilの場合' do
      it 'ArgumentErrorを発生させる' do
        expect do
          described_class.new(left: nil, right: right_operand)
        end.to raise_error(ArgumentError, /left operand must be present/)
      end
    end

    context '右オペランドがnilの場合' do
      it 'ArgumentErrorを発生させる' do
        expect do
          described_class.new(left: left_operand, right: nil)
        end.to raise_error(ArgumentError, /right operand must be present/)
      end
    end

    context '両方のオペランドがnilの場合' do
      it 'ArgumentErrorを発生させる' do
        expect do
          described_class.new(left: nil, right: nil)
        end.to raise_error(ArgumentError, /left operand must be present/)
      end
    end
  end

  describe '#evaluate' do
    let(:left_operand) { EzCondition::Term::Boolean.new(value: 'true') }
    let(:right_operand) { EzCondition::Term::Boolean.new(value: 'false') }

    it 'NotImplementedErrorを発生させる' do
      operator = described_class.new(left: left_operand, right: right_operand)
      expect do
        operator.evaluate({})
      end.to raise_error(NotImplementedError, /Subclasses must implement the evaluate method/)
    end
  end
end
