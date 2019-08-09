class CreateHashtags < ActiveRecord::Migration[5.2]
  def change
    create_table :hashtags do |t|

    	t.string :tag_name

      t.timestamps
    end
    add_index :hashtags, :tag_name, unique: true
  end
end
