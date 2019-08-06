class Users::ReviewsController < ApplicationController

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
	def review_params
		params.require(:review).permit(:user_id, :note_id, :quality, :review, :is_appending)
	end

end
