# frozen_string_literal: true

require 'spec_helper'

RSpec.describe EzCondition::Term::Boolean do
  describe '#initialize' do
    context 'valueが"true"の場合' do
      it 'Booleanオブジェクトを生成できる' do
        boolean = described_class.new(value: 'true')
        expect(boolean).to be_a(described_class)
      end
    end

    context 'valueが"false"の場合' do
      it 'Booleanオブジェクトを生成できる' do
        boolean = described_class.new(value: 'false')
        expect(boolean).to be_a(described_class)
      end
    end

    context 'valueが"true"でも"false"でもない場合' do
      it 'ArgumentErrorを発生させる' do
        expect do
          described_class.new(value: 'invalid')
        end.to raise_error(ArgumentError, /value must be true or false/)
      end
    end

    context 'valueがnilの場合' do
      it 'ArgumentErrorを発生させる' do
        expect do
          described_class.new(value: nil)
        end.to raise_error(ArgumentError, /value must be true or false/)
      end
    end
  end

  describe '#evaluate' do
    context 'valueが"true"の場合' do
      it 'trueを返す' do
        boolean = described_class.new(value: 'true')
        expect(boolean.evaluate({})).to be true
      end
    end

    context 'valueが"false"の場合' do
      it 'falseを返す' do
        boolean = described_class.new(value: 'false')
        expect(boolean.evaluate({})).to be false
      end
    end

    context 'contextに値が含まれている場合' do
      it 'contextを無視してvalueを評価する' do
        boolean = described_class.new(value: 'true')
        context = { 'key' => 'value' }
        expect(boolean.evaluate(context)).to be true
      end
    end
  end
end
