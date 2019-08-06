class Users::PostscriptsController < ApplicationController

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
	def postscript_params
		params.require(:postscript).permit(:review_id, :note_id, :postscript)
	end

end
