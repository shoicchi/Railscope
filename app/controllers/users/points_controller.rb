class Users::PointsController < ApplicationController

	def index
		@points = Point.where(user_id: current_user.id).order(id: "DESC")	#新しい順に表示
	end

	def show
	end

	def new
		@point = Point.new
	end

	def create
		@point = Point.new(point_params)
		@amount = 0
		#以下の条件分岐でpointによる支払い金額を設定、支払いの選択肢追加は以下elsifde記載
		if @point.point == 100
			@amount = 100
		elsif @point.point == 220
			@amount = 200
		elsif @point.point == 360
			@amount = 300
		else
			flash[:notice] = "正常に処理が行われませんでした。もう一度やり直してください。"
			redirect_to new_subscription_path
		end

		if current_user.payjp_id.nil?	#userがカード登録済みでない場合、登録画面へ飛ばす
			flash[:notice] = "カードを登録してください"
			redirect_to new_subscription_path
	    else							#userがカード登録済みであれば正常に処理する
	    	Payjp.api_key = "sk_test_a7ee466c4064bb2ae0bd4717"#秘密鍵
	    	charge = Payjp::Charge.create(
	    		amount:   @amount,				#先の条件分岐によって設定された金額をpayjpに渡す
	    		customer: current_user.payjp_id,#顧客情報をもとに支払いを行う
	    		currency: 'jpy',
	    	)
		@point.reason = 2	#reason2 =>追加購入
		@point.user_id = current_user.id
		@point.save
		current_user.holding_point += @point.point 	#ユーザーの保有ポイントにも反映させる
		current_user.save
		redirect_to points_path
		end
	end

	def edit
	end

	def update
	end

	def destroy
	end



	private
	def point_params
		params.require(:point).permit(:user_id, :reason, :point)
	end



end
