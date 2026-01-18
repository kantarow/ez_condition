# frozen_string_literal: true

require 'spec_helper'

RSpec.describe EzCondition::Term::Or do
  describe '#initialize' do
    let(:left_operand) { EzCondition::Term::Boolean.new(value: 'true') }
    let(:right_operand) { EzCondition::Term::Boolean.new(value: 'false') }

    it 'Orオブジェクトを生成できる' do
      or_op = described_class.new(left: left_operand, right: right_operand)
      expect(or_op).to be_a(described_class)
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
    context 'true || trueの場合' do
      it 'trueを返す' do
        left = EzCondition::Term::Boolean.new(value: 'true')
        right = EzCondition::Term::Boolean.new(value: 'true')
        or_op = described_class.new(left:, right:)
        expect(or_op.evaluate({})).to be true
      end
    end

    context 'true || falseの場合' do
      it 'trueを返す' do
        left = EzCondition::Term::Boolean.new(value: 'true')
        right = EzCondition::Term::Boolean.new(value: 'false')
        or_op = described_class.new(left:, right:)
        expect(or_op.evaluate({})).to be true
      end
    end

    context 'false || trueの場合' do
      it 'trueを返す' do
        left = EzCondition::Term::Boolean.new(value: 'false')
        right = EzCondition::Term::Boolean.new(value: 'true')
        or_op = described_class.new(left:, right:)
        expect(or_op.evaluate({})).to be true
      end
    end

    context 'false || falseの場合' do
      it 'falseを返す' do
        left = EzCondition::Term::Boolean.new(value: 'false')
        right = EzCondition::Term::Boolean.new(value: 'false')
        or_op = described_class.new(left:, right:)
        expect(or_op.evaluate({})).to be false
      end
    end

    context '変数を含むOr演算の場合' do
      it 'contextから変数を解決してOr演算を行う' do
        left = EzCondition::Term::Var.new(name: 'a')
        right = EzCondition::Term::Var.new(name: 'b')
        or_op = described_class.new(left:, right:)

        context = { 'a' => false, 'b' => true }
        expect(or_op.evaluate(context)).to be true
      end
    end

    context 'ネストしたOr演算の場合' do
      it '正しく評価する' do
        # (false || true) || false
        inner_left = EzCondition::Term::Boolean.new(value: 'false')
        inner_right = EzCondition::Term::Boolean.new(value: 'true')
        inner_or = described_class.new(left: inner_left, right: inner_right)

        outer_right = EzCondition::Term::Boolean.new(value: 'false')
        outer_or = described_class.new(left: inner_or, right: outer_right)

        expect(outer_or.evaluate({})).to be true
      end
    end
  end
end
