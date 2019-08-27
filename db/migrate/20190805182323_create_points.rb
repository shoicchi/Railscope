class CreatePoints < ActiveRecord::Migration[5.2]
  def change
    create_table :points do |t|

    	t.references :user, foreign_key: true, null:false
    	t.integer :reason, null:false
    	t.integer :point, null:false


      t.timestamps
    end
  end
end
