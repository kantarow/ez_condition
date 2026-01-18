# frozen_string_literal: true

require 'spec_helper'

RSpec.describe EzCondition::Term::Integer do
  describe '#initialize' do
    context 'value引数で整数を渡す場合' do
      it 'Integerオブジェクトを生成できる' do
        integer = described_class.new(value: 42)
        expect(integer).to be_a(described_class)
      end
    end

    context '位置引数で整数を渡す場合' do
      it 'Integerオブジェクトを生成できる' do
        integer = described_class.new(42)
        expect(integer).to be_a(described_class)
      end
    end

    context 'valueが文字列の整数の場合' do
      it 'to_iで変換してIntegerオブジェクトを生成できる' do
        integer = described_class.new(value: '123')
        expect(integer.evaluate({})).to eq(123)
      end
    end

    context 'valueがnilの場合' do
      it 'ArgumentErrorを発生させる' do
        expect do
          described_class.new(value: nil)
        end.to raise_error(ArgumentError, /value must be present/)
      end
    end

    context 'valueが引数なしの場合' do
      it 'ArgumentErrorを発生させる' do
        expect do
          described_class.new
        end.to raise_error(ArgumentError, /value must be present/)
      end
    end

    context 'valueがto_iに応答しない場合' do
      it 'ArgumentErrorを発生させる' do
        value_without_to_i = Object.new
        expect do
          described_class.new(value: value_without_to_i)
        end.to raise_error(ArgumentError, /value must respond to `to_i`/)
      end
    end

    context '負の整数の場合' do
      it 'Integerオブジェクトを生成できる' do
        integer = described_class.new(value: -10)
        expect(integer.evaluate({})).to eq(-10)
      end
    end

    context 'ゼロの場合' do
      it 'Integerオブジェクトを生成できる' do
        integer = described_class.new(value: 0)
        expect(integer.evaluate({})).to eq(0)
      end
    end
  end

  describe '#evaluate' do
    it '設定した整数値を返す' do
      integer = described_class.new(value: 42)
      expect(integer.evaluate({})).to eq(42)
    end

    it 'contextを無視する' do
      integer = described_class.new(value: 100)
      context = { 'key' => 'value' }
      expect(integer.evaluate(context)).to eq(100)
    end

    it '文字列から変換した整数値を返す' do
      integer = described_class.new(value: '456')
      expect(integer.evaluate({})).to eq(456)
    end
  end
end
