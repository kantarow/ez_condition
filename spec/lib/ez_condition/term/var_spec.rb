# frozen_string_literal: true

require 'spec_helper'

RSpec.describe EzCondition::Term::Var do
  describe '#initialize' do
    context 'nameが文字列の場合' do
      it 'Varオブジェクトを生成できる' do
        var = described_class.new(name: 'variable_name')
        expect(var).to be_a(described_class)
      end
    end

    context 'nameがシンボルの場合' do
      it 'Varオブジェクトを生成できる' do
        var = described_class.new(name: :variable_name)
        expect(var).to be_a(described_class)
      end
    end

    context 'nameがnilの場合' do
      it 'ArgumentErrorを発生させる' do
        expect do
          described_class.new(name: nil)
        end.to raise_error(ArgumentError, /name must be present/)
      end
    end
  end

  describe '#evaluate' do
    context '変数がcontextに存在する場合' do
      it 'contextから値を取得して返す' do
        var = described_class.new(name: 'status')
        context = { 'status' => 'active' }
        expect(var.evaluate(context)).to eq('active')
      end
    end

    context '変数がcontextに存在しない場合' do
      it 'RuntimeErrorを発生させる' do
        var = described_class.new(name: 'undefined_variable')
        context = {}
        expect do
          var.evaluate(context)
        end.to raise_error(RuntimeError, /Undefined variable `undefined_variable`/)
      end
    end

    context 'contextに整数値が格納されている場合' do
      it '整数値を返す' do
        var = described_class.new(name: 'count')
        context = { 'count' => 42 }
        expect(var.evaluate(context)).to eq(42)
      end
    end

    context 'contextにブール値が格納されている場合' do
      it 'ブール値を返す' do
        var = described_class.new(name: 'flag')
        context = { 'flag' => true }
        expect(var.evaluate(context)).to be true
      end
    end

    context 'nameがシンボルの場合' do
      it 'to_sで変換してcontextから値を取得する' do
        var = described_class.new(name: :key)
        context = { 'key' => 'value' }
        expect(var.evaluate(context)).to eq('value')
      end
    end

    context 'contextに複数の変数がある場合' do
      it '指定した変数の値だけを取得する' do
        var = described_class.new(name: 'x')
        context = { 'x' => 10, 'y' => 20, 'z' => 30 }
        expect(var.evaluate(context)).to eq(10)
      end
    end

    context 'contextの値がnilの場合' do
      it 'RuntimeErrorを発生させる' do
        var = described_class.new(name: 'null_var')
        context = { 'null_var' => nil }
        expect do
          var.evaluate(context)
        end.to raise_error(RuntimeError, /Undefined variable `null_var`/)
      end
    end

    context '特殊文字を含む変数名の場合' do
      it '正しく値を取得する' do
        var = described_class.new(name: 'variable_with_123')
        context = { 'variable_with_123' => 'test_value' }
        expect(var.evaluate(context)).to eq('test_value')
      end
    end
  end
end
