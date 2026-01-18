# frozen_string_literal: true

require 'spec_helper'

RSpec.describe EzCondition::Term::And do
  describe '#initialize' do
    let(:left_operand) { EzCondition::Term::Boolean.new(value: 'true') }
    let(:right_operand) { EzCondition::Term::Boolean.new(value: 'false') }

    it 'Andオブジェクトを生成できる' do
      and_op = described_class.new(left: left_operand, right: right_operand)
      expect(and_op).to be_a(described_class)
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
    context 'true && trueの場合' do
      it 'trueを返す' do
        left = EzCondition::Term::Boolean.new(value: 'true')
        right = EzCondition::Term::Boolean.new(value: 'true')
        and_op = described_class.new(left:, right:)
        expect(and_op.evaluate({})).to be true
      end
    end

    context 'true && falseの場合' do
      it 'falseを返す' do
        left = EzCondition::Term::Boolean.new(value: 'true')
        right = EzCondition::Term::Boolean.new(value: 'false')
        and_op = described_class.new(left:, right:)
        expect(and_op.evaluate({})).to be false
      end
    end

    context 'false && trueの場合' do
      it 'falseを返す' do
        left = EzCondition::Term::Boolean.new(value: 'false')
        right = EzCondition::Term::Boolean.new(value: 'true')
        and_op = described_class.new(left:, right:)
        expect(and_op.evaluate({})).to be false
      end
    end

    context 'false && falseの場合' do
      it 'falseを返す' do
        left = EzCondition::Term::Boolean.new(value: 'false')
        right = EzCondition::Term::Boolean.new(value: 'false')
        and_op = described_class.new(left:, right:)
        expect(and_op.evaluate({})).to be false
      end
    end

    context '変数を含むAnd演算の場合' do
      it 'contextから変数を解決してAnd演算を行う' do
        left = EzCondition::Term::Var.new(name: 'a')
        right = EzCondition::Term::Var.new(name: 'b')
        and_op = described_class.new(left:, right:)

        context = { 'a' => true, 'b' => true }
        expect(and_op.evaluate(context)).to be true
      end
    end

    context 'ネストしたAnd演算の場合' do
      it '正しく評価する' do
        # (true && true) && false
        inner_left = EzCondition::Term::Boolean.new(value: 'true')
        inner_right = EzCondition::Term::Boolean.new(value: 'true')
        inner_and = described_class.new(left: inner_left, right: inner_right)

        outer_right = EzCondition::Term::Boolean.new(value: 'false')
        outer_and = described_class.new(left: inner_and, right: outer_right)

        expect(outer_and.evaluate({})).to be false
      end
    end
  end
end
