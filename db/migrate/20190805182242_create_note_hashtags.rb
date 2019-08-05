class CreateNoteHashtags < ActiveRecord::Migration[5.2]
  def change
    create_table :note_hashtags do |t|

    	t.integer :note_id, null:false
    	t.integer :hashtag_id, null:false


      t.timestamps
    end
  end
end
