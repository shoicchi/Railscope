class CreateMyNotes < ActiveRecord::Migration[5.2]
  def change
    create_table :my_notes do |t|

    	t.integer :user_id, null:false
    	t.integer :note_id, null:false


      t.timestamps
    end
  end
end
