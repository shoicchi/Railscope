# frozen_string_literal: true

class CreatePostscripts < ActiveRecord::Migration[5.2]
  def change
    create_table :postscripts do |t|
      t.references :review, foreign_key: true, null: false
      t.references :note, foreign_key: true, null: false
      t.text :postscript, null: false

      t.timestamps
    end
  end
end
