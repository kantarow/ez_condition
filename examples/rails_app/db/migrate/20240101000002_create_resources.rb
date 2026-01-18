# frozen_string_literal: true

class CreateResources < ActiveRecord::Migration[7.0]
  def change
    create_table :resources do |t|
      t.string :name, null: false
      t.text :description
      t.string :resource_type, null: false

      t.timestamps
    end
  end
end
