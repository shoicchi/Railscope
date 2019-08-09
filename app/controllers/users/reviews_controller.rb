class Users::ReviewsController < ApplicationController

	def index
	end

	def show
	end

	def new
	end

	def create
		#@note = Note.find(params[:note_id])
		#@review = @note.review.build(review_params)
		@review = Review.new(review_params)
		@review.user_id = current_user.id
		if @review.save
			render :index
		end
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
