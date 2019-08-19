class Users::SubscriptionsController < ApplicationController

	def index
		@point = Point.new
		if Subscription.where(user_id: current_user.id).exists?											#current_userがsubscriptionテーブルを保持しているかどうか（定期課金申し込み済みかどうかの判断）
			Payjp.api_key = "sk_test_a7ee466c4064bb2ae0bd4717"											#秘密鍵
			@subscription = Payjp::Subscription.retrieve(current_user.subscription.payjp_id)			#current_userの定期課金情報をpayjpから持ってくる
		else
		end
	end

	def show
	end

	def new
	end

	def create
	end

	def edit
	end

	def update
	end

	def destroy
	end


	def registration_payjp#カード入力によって得られたトークンで顧客作成（永続的にトークンを使用可能にする）
	    Payjp.api_key = "sk_test_a7ee466c4064bb2ae0bd4717"							#秘密鍵
	   	response_customer = Payjp::Customer.create(card: params['payjp-token'])		#トークンをもとに顧客を作成
	    current_user.payjp_id = response_customer.id 								#作成した顧客のidををuserテーブルのpayjp_id(string)としてDBに保存
	    current_user.save
	    redirect_to user_path(current_user.id)
	end





	def monthly_subscription#月額定期課金支払い
		 @point = Point.new(point_params)	#viewからはPointのみhiddenで持ってくる

		if current_user.payjp_id.nil?		#カードが未登録の場合
			flash[:notice] = "カードを登録してください"
			redirect_to new_subscription_path
		end


	  	if Subscription.where(user_id: current_user.id).exists?									#定期課金に申し込み済みの場合(定期課金額変更の場合)
	  		#以下pay.jpの処理
	  		Payjp.api_key = "sk_test_a7ee466c4064bb2ae0bd4717"										#秘密鍵
	  		change_subscription = Payjp::Subscription.retrieve(current_user.subscription.payjp_id)  #userのsubscription.payjp_idから情報を取得
			change_subscription.plan = @point.point 												#planを上書き
			change_subscription.save																#更新(pay.jp上)
			#以下user.subscriptionの処理
			@subscription = current_user.subscription 												#user.subscriptionにも変更履歴を残す。(update_atから自動ポイント付与するため)
	  		@subscription.save
	  		flash[:notice] = change_subscription.plan.name

	  	else																#定期課金に未申し込みの場合(新規定期課金登録)
	  		Payjp.api_key = "sk_test_a7ee466c4064bb2ae0bd4717"				#秘密鍵
			new_subscription = Payjp::Subscription.create(					#pay.jpのsubscription(定期課金)にcustomerとplanを紐づける
							    		customer: current_user.payjp_id,
							    		plan:     @point.point,				#pay.jpのプランのIDを毎月の付与ポイントと一致させておくことで記述量が少なくなる＋確認しやすくなる
							  		)
			@subscription = Subscription.new
			@subscription.user_id = current_user.id
	  		@subscription.payjp_id = new_subscription.id 					#作成した定期課金情報のidををuser.subscription.payjp_id(string)としてDBに保存
	  		@subscription.save												#↑これをしないと更新や参照ができない＋自前のサーバサイドでモデルを作ることにより履歴も追えてupdate_atから毎月のポイント付与もできる
	  		flash[:notice] = new_subscription.plan.name

	  	end
  		#Pointテーブルについての処理
		@point.reason = 1							#月額付与分
		@point.user_id = current_user.id
		@point.save
		#Userテーブルの保有ポイントカラムについての処理
		current_user.holding_point += @point.point	#選択したplan(PointをUserの保有ポイントに追加)
		current_user.is_member = "有料会員"
		current_user.save
		redirect_to user_path(current_user)
	end


	private
	def subscription_params
		params.require(:subscription).permit(:user_id, :payjp_id)
	end
	def point_params
		params.require(:point).permit(:user_id, :reason, :point)
	end

end
