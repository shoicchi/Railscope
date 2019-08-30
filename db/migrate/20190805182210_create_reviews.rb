# frozen_string_literal: true

class CreateReviews < ActiveRecord::Migration[5.2]
  def change
    create_table :reviews do |t|
      t.references :user, foreign_key: true, null: false
      t.references :note, foreign_key: true, null: false
      t.float :quality, null: false
      t.text :review
      t.integer :is_appending, null: false, default: 0

      t.timestamps
    end
  end
end
