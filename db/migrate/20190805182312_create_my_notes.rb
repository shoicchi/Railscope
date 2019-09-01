# frozen_string_literal: true

class CreateMyNotes < ActiveRecord::Migration[5.2]
  def change
    create_table :my_notes, options: 'ENGINE=InnoDB ROW_FORMAT=DYNAMIC' do |t|
      t.references :user, foreign_key: true, null: false
      t.references :note, foreign_key: true, null: false

      t.timestamps
    end
  end
end
