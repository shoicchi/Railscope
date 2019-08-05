class CreateMonthlyFees < ActiveRecord::Migration[5.2]
  def change
    create_table :monthly_fees do |t|

    	t.integer :fee_category, null:false
    	t.integer :add_point, null:false


      t.timestamps
    end
  end
end
