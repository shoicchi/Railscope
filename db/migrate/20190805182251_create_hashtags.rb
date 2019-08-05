class CreateHashtags < ActiveRecord::Migration[5.2]
  def change
    create_table :hashtags do |t|

    	t.string :tag_name, null:false

      t.timestamps
    end
  end
end
