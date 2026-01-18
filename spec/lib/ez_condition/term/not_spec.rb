# frozen_string_literal: true

require 'spec_helper'

RSpec.describe EzCondition::Term::Not do
  describe '#initialize' do
    let(:operand) { EzCondition::Term::Boolean.new(value: 'true') }

    it 'Notオブジェクトを生成できる' do
      not_op = described_class.new(operand:)
      expect(not_op).to be_a(described_class)
    end
  end

  describe '#evaluate' do
    context 'オペランドがtrueの場合' do
      it 'falseを返す' do
        operand = EzCondition::Term::Boolean.new(value: 'true')
        not_op = described_class.new(operand:)
        expect(not_op.evaluate({})).to be false
      end
    end

    context 'オペランドがfalseの場合' do
      it 'trueを返す' do
        operand = EzCondition::Term::Boolean.new(value: 'false')
        not_op = described_class.new(operand:)
        expect(not_op.evaluate({})).to be true
      end
    end

    context 'ネストしたNot演算の場合' do
      it '二重否定でtrueを返す' do
        inner_operand = EzCondition::Term::Boolean.new(value: 'true')
        inner_not = described_class.new(operand: inner_operand)
        outer_not = described_class.new(operand: inner_not)
        expect(outer_not.evaluate({})).to be true
      end
    end

    context '複雑な式のNot演算の場合' do
      it 'And式の否定を正しく評価する' do
        left = EzCondition::Term::Boolean.new(value: 'true')
        right = EzCondition::Term::Boolean.new(value: 'false')
        and_op = EzCondition::Term::And.new(left:, right:)
        not_op = described_class.new(operand: and_op)
        # true && false = false, !false = true
        expect(not_op.evaluate({})).to be true
      end
    end

    context '変数を含むNot演算の場合' do
      it 'contextから変数を解決して否定する' do
        var = EzCondition::Term::Var.new(name: 'flag')
        not_op = described_class.new(operand: var)

        context = { 'flag' => true }
        expect(not_op.evaluate(context)).to be false
      end
    end
  end
end
