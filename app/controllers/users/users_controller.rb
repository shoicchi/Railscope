class Users::UsersController < ApplicationController

	def index
		@user = current_user
	end

	def show
		@user = User.find(params[:id])
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

	private
	def user_params
		params.require(:user).permit(:name, :profile, :grade, :provider, :uid, :e_mail, :encrypted_password, :is_member, :holding_point, :is_delivery, :fee_category, :phone_number, :is_deleted)
	end

end
