class CreateReviews < ActiveRecord::Migration[5.2]
  def change
    create_table :reviews do |t|

    	t.integer :user_id, null:false
    	t.integer :note_id, null:false
    	t.float :quantity, null:false
    	t.text :review
    	t.integer :is_appending, null:false, default:0


      t.timestamps
    end
  end
end
