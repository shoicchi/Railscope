class Users::ReviewsController < ApplicationController

	def index
	end

	def show
		@review = Review.find(params[:id])
		@note = @review.note
		@postscript = Postscript.new
	end

	def new
	end

	def create
		#@note = Note.find(params[:note_id])
		#@review = @note.review.build(review_params)
		@review = Review.new(review_params)
		if @review.save
			redirect_to note_path(@review.note_id)
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
