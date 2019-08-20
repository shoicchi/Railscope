namespace :point do
  desc "check_state"
  task monthly_add: :environment do

  		require"date"
  		today = Date.today
  		puts today			#いつのログかわかるように

    	add_subscriptions = Subscription.where(updated_at: 1.day.ago.all_day)#1.month.ago.all_day
		Payjp.api_key = "sk_test_a7ee466c4064bb2ae0bd4717"									#秘密鍵
		 add_subscriptions.each do |add_subscription|
		   	payjp_data = Payjp::Subscription.retrieve(add_subscription.payjp_id)  #Subscriptionsテーブルのsubscription.payjp_idから情報を取得

		   	user = User.find_by(payjp_id: payjp_data.customer)
		   	point = Point.new
		   	point.user_id = user.id
		   	point.reason = 1
		   	point.point = payjp_data.plan.id
		   	if point.save
		   		puts "point.save.success : point.id => #{point.id}, point.user_id => #{point.user_id}, point.point => #{point.point}"
		   	else
		   		puts "[!ERROR!] point.save.error : point.id => #{point.id}, point.user_id => #{point.user_id}, point.point => #{point.point}"
		   	end


		   	user.holding_point += point.point
		   	if user.save
		   		puts "user.holding_point.save.success : user.id => #{user.id}, add_point => #{point.point}, user.holding_point => #{user.holding_point}"
		   	else
		   		puts "[!ERROR!] user.holding_point.save.error : user.id => #{user.id}, add_point => #{point.point}"
		   	end

		   	if add_subscription.touch
		   		puts "user.subscription.save.success : user.id => #{add_subscription.user_id}, payjp_id => #{add_subscription.payjp_id}"
		   	else
		   		puts "[!ERROR!] user.subscription.save.error : user.id => #{add_subscription.user_id}, payjp_id => #{add_subscription.payjp_id}"
		   	end


		  end

  end
end