class CreateSubscriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :subscriptions do |t|

    	t.integer :user_id, null:false
    	t.string :payjp_id

      t.timestamps
    end
  end
end
