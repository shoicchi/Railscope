namespace :point do
  desc "check_state"
  task monthly_add: :environment do

  		#ログの最初に日付をputs
  		require"date"
  		today = Date.today
  		puts today

    	add_subscriptions = Subscription.where(created_at: 3.day.ago.all_day)	#１ヶ月前に作成または更新されているsubscriptionテーブルを取り出す。#本来は1.month.ago.all_day
		Payjp.api_key = "sk_test_a7ee466c4064bb2ae0bd4717"									#秘密鍵
		 add_subscriptions.each do |add_subscription|
		   	payjp_data = Payjp::Subscription.retrieve(add_subscription.payjp_id)  #Subscriptionsテーブルのsubscription.payjp_idから情報を取得

		   	#pointsテーブルの処理
		   	user = User.find_by(payjp_id: payjp_data.customer)	#payjpのcustomerからuser判別
		   	point = Point.new									#pointテーブルに付与履歴を残す
		   	point.user_id = user.id
		   	point.reason = 1									#月額付与分
		   	point.point = payjp_data.plan.id 					#payjpのplanテーブルのidは付与するpointと同値に設定してあるのでplan.idを付与ポイントに代入
		   	if point.save
		   		puts "point.save.success : point.id => #{point.id}, point.user_id => #{point.user_id}, point.point => #{point.point}"
		   	else
		   		puts "[!ERROR!] point.save.error : point.id => #{point.id}, point.user_id => #{point.user_id}, point.point => #{point.point}"
		   	end

		   	#usersテーブルの処理
		   	user.holding_point += point.point 					#userのholding_pointにも付与
		   	if user.save
		   		#flashのようなものをつけてユーザーに通知したい。flashは使えない。通知機能実装後？
		   		puts "user.holding_point.save.success : user.id => #{user.id}, add_point => #{point.point}, user.holding_point => #{user.holding_point}"
		   	else
		   		puts "[!ERROR!] user.holding_point.save.error : user.id => #{user.id}, add_point => #{point.point}"
		   	end

		   	#subscriptionsテーブルの処理
		   	if add_subscription.touch							#subscriptionテーブルのupdated_atのみ更新
		   		puts "user.subscription.save.success : user.id => #{add_subscription.user_id}, payjp_id => #{add_subscription.payjp_id}"
		   	else
		   		puts "[!ERROR!] user.subscription.save.error : user.id => #{add_subscription.user_id}, payjp_id => #{add_subscription.payjp_id}"
		   	end


		  end

  end
end