# EzCondition Rails Example

EzConditionライブラリを使用したアクセス制御システムのサンプルアプリケーションです。

## 概要

このアプリケーションは、EzConditionライブラリを使って動的なアクセス制御ルールを実装する実例を示します。条件式をJSON形式でデータベースに保存し、ユーザーのアクセス権限を実行時に評価します。

### 主な機能

- **動的なアクセス制御**: JSON形式の条件式をデータベースに保存
- **柔軟なルール定義**: AND、OR、NOT、等価比較を組み合わせた複雑な条件
- **実行時評価**: ユーザー属性に基づいてリアルタイムで権限を判定
- **モデルでの条件判定**: ActiveRecordモデルに統合されたアクセス制御

## アーキテクチャ

### モデル

- **User**: ユーザー情報（role, department, age, active）
- **Resource**: 保護対象のリソース
- **AccessRule**: リソースへのアクセスルール（JSON形式の条件式を保持）

### サービス

- **AccessEvaluator**: EzConditionパーサーを使って条件式を評価

## 前提条件

- Ruby 3.2以上
- SQLite3

## セットアップ

### 1. 依存関係のインストール

```bash
cd examples/rails_app
bundle install
```

### 2. データベースのセットアップ

```bash
bundle exec rails db:create
bundle exec rails db:migrate
bundle exec rails db:seed
```

Seedデータには以下が含まれます:
- 4人のユーザー（admin, manager, member, hr）
- 3つのリソース（Salary Report, Engineering Docs, HR System）
- 4つのアクセスルール

### 3. サーバー起動

```bash
bundle exec rails server
```

ブラウザで http://localhost:3000 にアクセスしてください。

## 使い方

### Webブラウザで試す

1. http://localhost:3000 にアクセス
2. 「Users」タブから異なるユーザーに切り替え
3. 「Resources」タブでリソースにアクセスを試行
4. アクセス制御が動作することを確認

### Railsコンソールで試す

```bash
bundle exec rails console
```

#### 基本的な使用例

```ruby
# ユーザーとリソースを取得
user = User.find_by(email: 'admin@example.com')
resource = Resource.first

# アクセス権限をチェック
user.can?('read', resource)  # => true or false

# ユーザーのコンテキストを確認
user.to_context
# => {"role"=>"admin", "department"=>"engineering", "age"=>35, "active"=>true}
```

#### アクセスルールの評価

```ruby
# アクセスルールを取得
rule = AccessRule.first

# 特定のユーザーでルールを評価
rule.evaluate_for(user)  # => true or false

# ルールの条件を確認
rule.condition
# => {"type"=>"equal", "left"=>{"type"=>"var", "name"=>"role"}, ...}
```

## 条件式の例

### 例1: 単純な役割ベースのアクセス

```ruby
{
  "type" => "equal",
  "left" => { "type" => "var", "name" => "role" },
  "right" => { "type" => "string", "value" => "admin" }
}
```

管理者のみがアクセス可能。

### 例2: AND条件（部門とロールの組み合わせ）

```ruby
{
  "type" => "and",
  "left" => {
    "type" => "equal",
    "left" => { "type" => "var", "name" => "department" },
    "right" => { "type" => "string", "value" => "engineering" }
  },
  "right" => {
    "type" => "equal",
    "left" => { "type" => "var", "name" => "role" },
    "right" => { "type" => "string", "value" => "manager" }
  }
}
```

エンジニアリング部門のマネージャーのみがアクセス可能。

### 例3: OR条件（複数の条件のいずれか）

```ruby
{
  "type" => "or",
  "left" => {
    "type" => "equal",
    "left" => { "type" => "var", "name" => "role" },
    "right" => { "type" => "string", "value" => "admin" }
  },
  "right" => {
    "type" => "and",
    "left" => {
      "type" => "equal",
      "left" => { "type" => "var", "name" => "department" },
      "right" => { "type" => "string", "value" => "hr" }
    },
    "right" => {
      "type" => "equal",
      "left" => { "type" => "var", "name" => "active" },
      "right" => { "type" => "boolean", "value" => "true" }
    }
  }
}
```

管理者、またはアクティブなHR部門のメンバーがアクセス可能。

## テストシナリオ

Seedデータで以下のシナリオをテストできます:

1. **Admin User** (`admin@example.com`)
   - すべてのリソースにアクセス可能

2. **Manager User** (`manager@example.com`)
   - Salary ReportとEngineering Docsにアクセス可能
   - HR Systemにはアクセス不可

3. **Member User** (`member@example.com`)
   - いずれのリソースにもアクセス不可（sales部門のため）

4. **HR Member** (`hr@example.com`)
   - HR Systemのみにアクセス可能

## テスト実行

```bash
# すべてのテストを実行
bundle exec rspec

# 特定のテストファイルを実行
bundle exec rspec spec/services/access_evaluator_spec.rb

# テストの詳細出力
bundle exec rspec --format documentation
```

## コード構成

```
app/
├── models/
│   ├── user.rb              # ユーザーモデル（to_context、can?メソッド）
│   ├── resource.rb          # リソースモデル
│   └── access_rule.rb       # アクセスルールモデル（evaluate_forメソッド）
├── controllers/
│   ├── resources_controller.rb  # アクセス制御のデモ
│   ├── users_controller.rb      # ユーザー切り替え
│   └── access_rules_controller.rb  # ルール管理
├── services/
│   └── access_evaluator.rb  # EzCondition統合のコアロジック
└── views/
    ├── resources/           # リソース一覧・詳細画面
    ├── users/               # ユーザー一覧画面
    └── access_rules/        # アクセスルール一覧画面
```

## EzConditionの統合ポイント

### AccessEvaluatorサービス

```ruby
class AccessEvaluator
  def initialize(access_rule, user)
    @access_rule = access_rule
    @user = user
    @parser = EzCondition::Parser.new  # パーサーのインスタンス化
  end

  def evaluate
    parsed_condition = @parser.parse(@access_rule.condition)  # JSON をパース
    context = @user.to_context  # ユーザー属性をコンテキストに変換
    parsed_condition.evaluate(context)  # 条件を評価
  end
end
```

### Userモデル

```ruby
class User < ApplicationRecord
  def to_context
    {
      'role' => role,
      'department' => department,
      'age' => age,
      'active' => active
    }
  end

  def can?(action, resource)
    rules = resource.access_rules.where(action: action.to_s)
    rules.any? { |rule| rule.evaluate_for(self) }
  end
end
```

## カスタマイズ

### 新しいアクセスルールを追加

Railsコンソールまたはアプリケーションから:

```ruby
AccessRule.create!(
  resource: resource,
  name: 'Custom Rule',
  action: 'read',
  condition: {
    # あなたの条件式をここに
  }
)
```

### サポートされている条件式の型

- **var**: 変数参照（ユーザー属性）
- **string**: 文字列リテラル
- **integer**: 整数リテラル
- **boolean**: 真偽値リテラル
- **equal**: 等価比較
- **and**: 論理AND
- **or**: 論理OR
- **not**: 論理NOT

## トラブルシューティング

### データベースエラー

```bash
bundle exec rails db:reset
```

### テストデータのリセット

```bash
bundle exec rails db:seed
```

## 参考リンク

- [EzCondition本体のREADME](../../README.md)
- [EzCondition Parser仕様](../../lib/ez_condition/parser.rb)

## ライセンス

このサンプルアプリケーションはEzConditionライブラリと同じMITライセンスの下で提供されています。
