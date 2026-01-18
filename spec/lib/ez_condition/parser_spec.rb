# frozen_string_literal: true

require 'spec_helper'

RSpec.describe EzCondition::Parser do
  describe '#parse' do
    subject(:parse) { described_class.new.parse(condition) }

    context 'Boolean型のparse' do
      context 'trueの場合' do
        let(:condition) { { 'type' => 'boolean', 'value' => 'true' } }

        it 'Booleanオブジェクトを返す' do
          expect(parse).to be_a(EzCondition::Term::Boolean)
        end
      end

      context 'falseの場合' do
        let(:condition) { { 'type' => 'boolean', 'value' => 'false' } }

        it 'Booleanオブジェクトを返す' do
          expect(parse).to be_a(EzCondition::Term::Boolean)
        end
      end
    end

    context 'Integer型のparse' do
      let(:condition) { { 'type' => 'integer', 'value' => 42 } }

      it 'Integerオブジェクトを返す' do
        expect(parse).to be_a(EzCondition::Term::Integer)
      end
    end

    context 'String型のparse' do
      let(:condition) { { 'type' => 'string', 'value' => 'hello' } }

      it 'Stringオブジェクトを返す' do
        expect(parse).to be_a(EzCondition::Term::String)
      end
    end

    context 'Var型のparse' do
      let(:condition) { { 'type' => 'var', 'name' => 'status' } }

      it 'Varオブジェクトを返す' do
        expect(parse).to be_a(EzCondition::Term::Var)
      end
    end

    context 'And型のparse' do
      let(:condition) do
        {
          'type' => 'and',
          'left' => { 'type' => 'boolean', 'value' => 'true' },
          'right' => { 'type' => 'boolean', 'value' => 'false' }
        }
      end

      it 'Andオブジェクトを返す' do
        expect(parse).to be_a(EzCondition::Term::And)
      end

      it '左右のオペランドが正しくparseされる' do
        expect(parse.left).to be_a(EzCondition::Term::Boolean)
        expect(parse.right).to be_a(EzCondition::Term::Boolean)
      end
    end

    context 'Or型のparse' do
      let(:condition) do
        {
          'type' => 'or',
          'left' => { 'type' => 'boolean', 'value' => 'true' },
          'right' => { 'type' => 'boolean', 'value' => 'false' }
        }
      end

      it 'Orオブジェクトを返す' do
        expect(parse).to be_a(EzCondition::Term::Or)
      end

      it '左右のオペランドが正しくparseされる' do
        expect(parse.left).to be_a(EzCondition::Term::Boolean)
        expect(parse.right).to be_a(EzCondition::Term::Boolean)
      end
    end

    context 'Equal型のparse' do
      let(:condition) do
        {
          'type' => 'equal',
          'left' => { 'type' => 'integer', 'value' => 1 },
          'right' => { 'type' => 'integer', 'value' => 1 }
        }
      end

      it 'Equalオブジェクトを返す' do
        expect(parse).to be_a(EzCondition::Term::Equal)
      end

      it '左右のオペランドが正しくparseされる' do
        expect(parse.left).to be_a(EzCondition::Term::Integer)
        expect(parse.right).to be_a(EzCondition::Term::Integer)
      end
    end

    context 'Not型のparse' do
      let(:condition) do
        {
          'type' => 'not',
          'operand' => { 'type' => 'boolean', 'value' => 'true' }
        }
      end

      it 'Notオブジェクトを返す' do
        expect(parse).to be_a(EzCondition::Term::Not)
      end
    end

    context 'ネストした式のparse' do
      context 'And内にOrがある場合' do
        let(:condition) do
          {
            'type' => 'and',
            'left' => {
              'type' => 'or',
              'left' => { 'type' => 'boolean', 'value' => 'true' },
              'right' => { 'type' => 'boolean', 'value' => 'false' }
            },
            'right' => { 'type' => 'boolean', 'value' => 'true' }
          }
        end

        it 'Andオブジェクトを返す' do
          expect(parse).to be_a(EzCondition::Term::And)
        end

        it '左オペランドがOrオブジェクト' do
          expect(parse.left).to be_a(EzCondition::Term::Or)
        end

        it '右オペランドがBooleanオブジェクト' do
          expect(parse.right).to be_a(EzCondition::Term::Boolean)
        end
      end

      context 'Notのネスト' do
        let(:condition) do
          {
            'type' => 'not',
            'operand' => {
              'type' => 'not',
              'operand' => { 'type' => 'boolean', 'value' => 'true' }
            }
          }
        end

        it 'Notオブジェクトを返す' do
          expect(parse).to be_a(EzCondition::Term::Not)
        end
      end

      context '複雑なネスト構造' do
        let(:condition) do
          {
            'type' => 'or',
            'left' => {
              'type' => 'and',
              'left' => { 'type' => 'var', 'name' => 'x' },
              'right' => { 'type' => 'boolean', 'value' => 'true' }
            },
            'right' => {
              'type' => 'equal',
              'left' => { 'type' => 'integer', 'value' => 10 },
              'right' => { 'type' => 'var', 'name' => 'y' }
            }
          }
        end

        it 'Orオブジェクトを返す' do
          expect(parse).to be_a(EzCondition::Term::Or)
        end

        it '左オペランドがAndオブジェクト' do
          expect(parse.left).to be_a(EzCondition::Term::And)
        end

        it '右オペランドがEqualオブジェクト' do
          expect(parse.right).to be_a(EzCondition::Term::Equal)
        end
      end
    end

    context '異常系' do
      context 'nilを渡した場合' do
        let(:condition) { nil }

        it 'nilを返す' do
          expect(parse).to be_nil
        end
      end

      context '空のハッシュを渡した場合' do
        let(:condition) { {} }

        it 'nilを返す' do
          expect(parse).to be_nil
        end
      end

      context '不明なtype' do
        let(:condition) { { 'type' => 'unknown' } }

        it '例外を発生させる' do
          expect { parse }.to raise_error(RuntimeError, /Unknown expr type: unknown/)
        end
      end
    end

    context '実用的な例' do
      context '変数とリテラルの比較' do
        let(:condition) do
          {
            'type' => 'equal',
            'left' => { 'type' => 'var', 'name' => 'status' },
            'right' => { 'type' => 'string', 'value' => 'active' }
          }
        end

        it 'Equalオブジェクトを返す' do
          expect(parse).to be_a(EzCondition::Term::Equal)
        end

        it '左オペランドがVarオブジェクト' do
          expect(parse.left).to be_a(EzCondition::Term::Var)
        end

        it '右オペランドがStringオブジェクト' do
          expect(parse.right).to be_a(EzCondition::Term::String)
        end
      end

      context '複数の条件の組み合わせ' do
        let(:condition) do
          {
            'type' => 'and',
            'left' => {
              'type' => 'equal',
              'left' => { 'type' => 'var', 'name' => 'age' },
              'right' => { 'type' => 'integer', 'value' => 20 }
            },
            'right' => {
              'type' => 'equal',
              'left' => { 'type' => 'var', 'name' => 'status' },
              'right' => { 'type' => 'string', 'value' => 'active' }
            }
          }
        end

        it 'Andオブジェクトを返す' do
          expect(parse).to be_a(EzCondition::Term::And)
        end

        it '左オペランドがEqualオブジェクト' do
          expect(parse.left).to be_a(EzCondition::Term::Equal)
        end

        it '右オペランドがEqualオブジェクト' do
          expect(parse.right).to be_a(EzCondition::Term::Equal)
        end
      end
    end
  end
end
