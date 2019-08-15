class Users::UsersController < ApplicationController

	def index
	end

	def show
		@user = User.find(params[:id])
	end

	def new
	end

	def create
	end

	def edit
		@user = User.find(params[:id])
	end

	def update
		@user = User.find(params[:id])
		if @user.is_member == 0#無料会員へ変更すると月額料金は0にする
			@user.fee_category = 0
		end
		if @user.update
			flash[:notice] = "編集しました。"
		else
			flash[:notice] = "編集に失敗しました。やり直してください。"
		end
		redirect_to user_path(@user)
	end

	def destroy
	end

	def registration_payjp#カード入力によって得られたトークンで顧客作成（永続的にトークンを使用可能にする）
		        Payjp.api_key = "sk_test_a7ee466c4064bb2ae0bd4717"#秘密鍵
		       	response_customer = Payjp::Customer.create(card: params['payjp-token'])#トークンをもとに顧客を作成
		        current_user.payjp_id = response_customer.id#作成した顧客をpay_jpとしてDBに保存
		        current_user.save
	end

	def payp
	    Payjp.api_key = 'sk_test_a7ee466c4064bb2ae0bd4717'
	    charge = Payjp::Charge.create(
		    :amount => 3500,
		    :card => params['payjp-token'],
		    :currency => 'jpy',
			)



	end

	def pay#支払い
    	Payjp.api_key = "sk_test_a7ee466c4064bb2ae0bd4717"#秘密鍵
    	charge = Payjp::Charge.create(
    		amount: 100,#
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

	private
	def user_params
		params.require(:user).permit(:name, :profile, :grade, :provider, :uid, :e_mail, :encrypted_password, :is_member, :holding_point, :is_delivery, :fee_category, :phone_number, :is_deleted)
	end

end
