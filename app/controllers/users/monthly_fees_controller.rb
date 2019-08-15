class Users::MonthlyFeesController < ApplicationController

	def index
		@user = current_user
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
		def pay
    Payjp.api_key = '秘密キー'
    charge = Payjp::Charge.create(
    :amount => 3500,
    :card => params['payjp-token'],
    :currency => 'jpy',
)
end

	def destroy
	end

	private
	def monthly_fee_params
		params.require(:monthly_fee).permit(:fee_category, :add_point)
	end

end
