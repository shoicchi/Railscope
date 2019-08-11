class Users::PostscriptsController < ApplicationController

	def index
	end

	def show
	end

	def new
	end

	def create
		@postscript = Postscript.new(postscript_params)
		@postscript.review.is_appending = 2
		if @postscript.save
		redirect_to note_path(@postscript.note_id)
	end
	end

	def edit
	end

	def update
	end

	def destroy
	end

	private
	def postscript_params
		params.require(:postscript).permit(:review_id, :note_id, :postscript)
	end

end
