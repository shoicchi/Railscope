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
		@point.reason = 2
		@point.user_id = current_user.id
		@point.save
		current_user.holding_point += @point.point
		current_user.save
		redirect_to points_path
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
