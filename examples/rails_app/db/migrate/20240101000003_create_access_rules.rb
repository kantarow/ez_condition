# frozen_string_literal: true

class CreateAccessRules < ActiveRecord::Migration[7.0]
  def change
    create_table :access_rules do |t|
      t.references :resource, null: false, foreign_key: true
      t.string :name, null: false
      t.json :condition, null: false
      t.string :action, null: false

      t.timestamps
    end

    add_index :access_rules, [:resource_id, :action]
  end
end
