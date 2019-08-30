class CreateSubscriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :subscriptions, :options => 'ENGINE=InnoDB ROW_FORMAT=DYNAMIC' do |t|

    	t.references :user, foreign_key: true, null:false
    	t.string :payjp_id

      t.timestamps
    end
  end
end
