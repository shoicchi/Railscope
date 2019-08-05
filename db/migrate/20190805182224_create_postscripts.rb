class CreatePostscripts < ActiveRecord::Migration[5.2]
  def change
    create_table :postscripts do |t|

    	t.integer :review_id, null:false
    	t.integer :note_id, null:false
    	t.text :postscript, null:false


      t.timestamps
    end
  end
end
