# frozen_string_literal: true

require 'spec_helper'

RSpec.describe EzCondition::Term::Statement do
  describe '#initialize' do
    context 'linesが配列の場合' do
      it 'Statementオブジェクトを生成できる' do
        lines = [EzCondition::Term::Boolean.new(value: 'true')]
        statement = described_class.new(lines:)
        expect(statement).to be_a(described_class)
      end
    end

    context 'linesが空配列の場合' do
      it 'Statementオブジェクトを生成できる' do
        statement = described_class.new(lines: [])
        expect(statement).to be_a(described_class)
      end
    end

    context 'linesが配列でない場合' do
      it 'ArgumentErrorを発生させる' do
        expect do
          described_class.new(lines: 'not an array')
        end.to raise_error(ArgumentError, /lines must be an array/)
      end
    end

    context 'linesがnilの場合' do
      it 'ArgumentErrorを発生させる' do
        expect do
          described_class.new(lines: nil)
        end.to raise_error(ArgumentError, /lines must be an array/)
      end
    end
  end

  describe '#evaluate' do
    context '単一の行の場合' do
      it 'その行の評価結果を返す' do
        line = EzCondition::Term::Boolean.new(value: 'true')
        statement = described_class.new(lines: [line])
        expect(statement.evaluate({})).to be true
      end
    end

    context '複数の行の場合' do
      it '最後の行の評価結果を返す' do
        line1 = EzCondition::Term::Boolean.new(value: 'false')
        line2 = EzCondition::Term::Boolean.new(value: 'true')
        line3 = EzCondition::Term::Integer.new(value: 42)
        statement = described_class.new(lines: [line1, line2, line3])
        expect(statement.evaluate({})).to eq(42)
      end
    end

    context '空の行の場合' do
      it 'nilを返す' do
        statement = described_class.new(lines: [])
        expect(statement.evaluate({})).to be_nil
      end
    end

    context '複雑な式を含む場合' do
      it '各行を順番に評価し、最後の結果を返す' do
        # line1: true && false (false)
        line1_left = EzCondition::Term::Boolean.new(value: 'true')
        line1_right = EzCondition::Term::Boolean.new(value: 'false')
        line1 = EzCondition::Term::And.new(left: line1_left, right: line1_right)

        # line2: 1 == 1 (true)
        line2_left = EzCondition::Term::Integer.new(value: 1)
        line2_right = EzCondition::Term::Integer.new(value: 1)
        line2 = EzCondition::Term::Equal.new(left: line2_left, right: line2_right)

        statement = described_class.new(lines: [line1, line2])
        expect(statement.evaluate({})).to be true
      end
    end

    context '変数を含む場合' do
      it 'contextから変数を解決して各行を評価する' do
        line1 = EzCondition::Term::Var.new(name: 'x')
        line2 = EzCondition::Term::Var.new(name: 'y')
        statement = described_class.new(lines: [line1, line2])

        context = { 'x' => 10, 'y' => 20 }
        expect(statement.evaluate(context)).to eq(20)
      end
    end

    context '中間の行が例外を発生させる場合' do
      it '例外が伝播される' do
        line1 = EzCondition::Term::Boolean.new(value: 'true')
        line2 = EzCondition::Term::Var.new(name: 'undefined')
        line3 = EzCondition::Term::Boolean.new(value: 'false')
        statement = described_class.new(lines: [line1, line2, line3])

        expect do
          statement.evaluate({})
        end.to raise_error(RuntimeError, /Undefined variable/)
      end
    end
  end
end
