class CreateLikes < ActiveRecord::Migration[5.2]
  def change
    create_table :likes, :options => 'ENGINE=InnoDB ROW_FORMAT=DYNAMIC' do |t|

    	t.references :note,  foreign_key: true, null: false
    	t.references :user, foreign_key: true, null:false


      t.timestamps
    end
  end
end
