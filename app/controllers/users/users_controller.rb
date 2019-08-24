class Users::UsersController < ApplicationController

	def top
		
	end

	def index
	end

	def show
		@user = User.find(params[:id])
		@notes = Note.where(user_id: @user)
		if Subscription.where(user_id: current_user.id).exists?											#current_userがsubscriptionテーブルを保持しているかどうか（定期課金申し込み済みかどうかの判断）
			Payjp.api_key = "sk_test_a7ee466c4064bb2ae0bd4717"											#秘密鍵
			@subscription = Payjp::Subscription.retrieve(current_user.subscription.payjp_id)			#current_userの定期課金情報をpayjpから持ってくる
		else
		end
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
		if @user.update(user_params)
				flash[:notice] = "編集しました。"
			else
				flash[:notice] = "編集に失敗しました。やり直してください。"
			end

		if @user.is_member == "有料会員" && Subscription.where(user_id: @user.id).empty?#無料会員から有料会員へ変更するとsaveの前に月額料金申し込みページへ遷移(遷移先のupdateでis_memberのsave)
			redirect_to subscriptions_path

		else
			if @user.is_member == "無料会員" && Subscription.where(user_id: @user.id).exists?#有料会員から無料会員へ変更すると月額料金は0にする
				Payjp.api_key = "sk_test_a7ee466c4064bb2ae0bd4717"											#秘密鍵
				del_subscription = Payjp::Subscription.retrieve(current_user.subscription.payjp_id)			#current_userの定期課金情報をpayjpから持ってくる
				del_subscription.delete
				@user.subscription.delete
			else
			end
			redirect_to user_path(@user)
		end
	end

	def destroy
	end


	private
	def user_params
		params.require(:user).permit(:name, :profile, :grade, :provider, :uid, :e_mail, :encrypted_password, :is_member, :holding_point, :is_delivery, :payjp_id, :phone_number, :is_deleted)
	end

end
