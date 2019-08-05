class CreateNotes < ActiveRecord::Migration[5.2]
  def change
    create_table :notes do |t|

    	t.integer :user_id, null:false
    	t.string :title, null:false
    	t.string :overview, null:false
    	t.text :content, null:false
    	t.integer :is_browsable_guest, null:false, default:1
    	t.integer :view_point, null:false, default:0


      t.timestamps
    end
  end
end
