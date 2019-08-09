class CreateNoteHashtags < ActiveRecord::Migration[5.2]
  def change
    create_table :note_hashtags do |t|

    	t.references :note,  foreign_key: true
    	t.references :hashtag, foreign_key: true


      t.timestamps
    end
  end
end
