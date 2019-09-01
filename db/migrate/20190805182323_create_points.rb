# frozen_string_literal: true

class CreatePoints < ActiveRecord::Migration[5.2]
  def change
    create_table :points, options: 'ENGINE=InnoDB ROW_FORMAT=DYNAMIC' do |t|
      t.references :user, foreign_key: true, null: false
      t.integer :reason, null: false
      t.integer :point, null: false

      t.timestamps
    end
  end
end
