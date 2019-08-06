class Users::MonthlyFeesController < ApplicationController

	def index
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

	private
	def monthly_fee_params
		params.require(:monthly_fee).permit(:fee_category, :add_point)
	end

end
