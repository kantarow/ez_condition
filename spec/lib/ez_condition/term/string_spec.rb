# frozen_string_literal: true

require 'spec_helper'

RSpec.describe EzCondition::Term::String do
  describe '#initialize' do
    context 'valueが文字列の場合' do
      it 'Stringオブジェクトを生成できる' do
        string = described_class.new(value: 'hello')
        expect(string).to be_a(described_class)
      end
    end

    context 'valueが空文字列の場合' do
      it 'Stringオブジェクトを生成できる' do
        string = described_class.new(value: '')
        expect(string).to be_a(described_class)
      end
    end

    context 'valueが整数の場合' do
      it 'to_sで変換してStringオブジェクトを生成できる' do
        string = described_class.new(value: 123)
        expect(string.evaluate({})).to eq('123')
      end
    end

    context 'valueがnilの場合' do
      it 'ArgumentErrorを発生させる' do
        expect do
          described_class.new(value: nil)
        end.to raise_error(ArgumentError, /value must be present/)
      end
    end

    context 'valueがシンボルの場合' do
      it 'to_sで変換してStringオブジェクトを生成できる' do
        string = described_class.new(value: :symbol)
        expect(string.evaluate({})).to eq('symbol')
      end
    end

    context 'valueが特殊文字を含む文字列の場合' do
      it 'Stringオブジェクトを生成できる' do
        string = described_class.new(value: "hello\nworld\t!")
        expect(string.evaluate({})).to eq("hello\nworld\t!")
      end
    end
  end

  describe '#evaluate' do
    it '設定した文字列を返す' do
      string = described_class.new(value: 'hello world')
      expect(string.evaluate({})).to eq('hello world')
    end

    it 'contextを無視する' do
      string = described_class.new(value: 'test')
      context = { 'key' => 'value' }
      expect(string.evaluate(context)).to eq('test')
    end

    it '整数から変換した文字列を返す' do
      string = described_class.new(value: 456)
      expect(string.evaluate({})).to eq('456')
    end

    it '空文字列を返す' do
      string = described_class.new(value: '')
      expect(string.evaluate({})).to eq('')
    end

    it 'マルチバイト文字列を正しく扱う' do
      string = described_class.new(value: 'こんにちは')
      expect(string.evaluate({})).to eq('こんにちは')
    end
  end
end
