class Users::PointsController < ApplicationController

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
	def point_params
		params.require(:point).permit(:user_id, :reason, :point)
	end

end
