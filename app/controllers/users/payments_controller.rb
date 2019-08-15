class Users::PaymentsController < ApplicationController

	def index
		@point = Point.new
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
	    Payjp.api_key = "sk_test_a7ee466c4064bb2ae0bd4717"#秘密鍵
	   	response_customer = Payjp::Customer.create(card: params['payjp-token'])#トークンをもとに顧客を作成
	    current_user.payjp_id = response_customer.id#作成した顧客のidををuserテーブルのpayjp_id(string)としてDBに保存
	    current_user.save
	    redirect_to
	end



	def pay#支払い
    	Payjp.api_key = "sk_test_a7ee466c4064bb2ae0bd4717"#秘密鍵
    	charge = Payjp::Charge.create(
    		amount:   100,#
    		customer: current_user.payjp_id,#顧客情報をもとに支払いを行う
    		currency: 'jpy',
    	)
    	@point = Point.new
		@point.point = 100
		@point.reason = 1
		@point.user_id = current_user.id
		@point.save
		current_user.holding_point += @point.point
		current_user.save
	end

	def monthly_subscription#月額定期課金支払い
		if current_user.ppayjp_id.nil?		#カードが未登録の場合
			flash[:notice] = "カードを登録してください"
			redirect_to new_payment_path
		end

    	Payjp.api_key = "sk_test_a7ee466c4064bb2ae0bd4717"#秘密鍵
		Payjp::Subscription.create(				#pay.jpのsubscription(定期課金)にcustomerとplanを紐づける
    		customer: current_user.payjp_id,
    		plan:     @point.point,				#pay.jpのプランのIDを毎月の付与ポイントと一致させておくことで記述量が少なくなる＋確認しやすくなる
  		)
  		#Pointテーブルについての処理
  		@point = Point.new(point_params)	#viewからはPointのみhiddenで持ってくる
		@point.reason = 1					#月額付与分
		@point.user_id = current_user.id
		@point.save
		#Userテーブルの保有ポイントカラムについての処理
		current_user.holding_point += @point.point_params	#選択したplan(PointをUserの保有ポイントに追加)
		current_user.save
	end

		private
	def point_params
		params.require(:point).permit(:user_id, :reason, :point)
	end

end
