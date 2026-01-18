# frozen_string_literal: true

require 'spec_helper'

RSpec.describe EzCondition::Term::Equal do
  describe '#initialize' do
    let(:left_operand) { EzCondition::Term::Integer.new(value: 1) }
    let(:right_operand) { EzCondition::Term::Integer.new(value: 2) }

    it 'Equalオブジェクトを生成できる' do
      equal = described_class.new(left: left_operand, right: right_operand)
      expect(equal).to be_a(described_class)
    end

    context 'BinaryOperatorの制約を継承する' do
      it '左オペランドがnilの場合、ArgumentErrorを発生させる' do
        expect do
          described_class.new(left: nil, right: right_operand)
        end.to raise_error(ArgumentError, /left operand must be present/)
      end

      it '右オペランドがnilの場合、ArgumentErrorを発生させる' do
        expect do
          described_class.new(left: left_operand, right: nil)
        end.to raise_error(ArgumentError, /right operand must be present/)
      end
    end
  end

  describe '#evaluate' do
    context '両オペランドが等しい場合' do
      it 'trueを返す' do
        left = EzCondition::Term::Integer.new(value: 42)
        right = EzCondition::Term::Integer.new(value: 42)
        equal = described_class.new(left:, right:)
        expect(equal.evaluate({})).to be true
      end
    end

    context '両オペランドが異なる場合' do
      it 'falseを返す' do
        left = EzCondition::Term::Integer.new(value: 1)
        right = EzCondition::Term::Integer.new(value: 2)
        equal = described_class.new(left:, right:)
        expect(equal.evaluate({})).to be false
      end
    end

    context '文字列の比較' do
      it '等しい文字列の場合、trueを返す' do
        left = EzCondition::Term::String.new(value: 'hello')
        right = EzCondition::Term::String.new(value: 'hello')
        equal = described_class.new(left:, right:)
        expect(equal.evaluate({})).to be true
      end

      it '異なる文字列の場合、falseを返す' do
        left = EzCondition::Term::String.new(value: 'hello')
        right = EzCondition::Term::String.new(value: 'world')
        equal = described_class.new(left:, right:)
        expect(equal.evaluate({})).to be false
      end
    end

    context '変数を含む比較' do
      it 'contextから変数を解決して比較する' do
        left = EzCondition::Term::Var.new(name: 'x')
        right = EzCondition::Term::Integer.new(value: 10)
        equal = described_class.new(left:, right:)

        context = { 'x' => 10 }
        expect(equal.evaluate(context)).to be true
      end
    end
  end
end
