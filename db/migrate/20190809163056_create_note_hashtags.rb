class CreateNoteHashtags < ActiveRecord::Migration[5.2]
  def change
    create_table :note_hashtags, :options => 'ENGINE=InnoDB ROW_FORMAT=DYNAMIC' do |t|

    	t.references :note,  foreign_key: true, null: false
    	t.references :hashtag, foreign_key: true, null:false


      t.timestamps
    end
  end
end
