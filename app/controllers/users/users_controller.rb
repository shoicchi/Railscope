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


	private
	def user_params
		params.require(:user).permit(:name, :profile, :grade, :provider, :uid, :e_mail, :encrypted_password, :is_member, :holding_point, :is_delivery, :fee_category, :phone_number, :is_deleted)
	end

end
