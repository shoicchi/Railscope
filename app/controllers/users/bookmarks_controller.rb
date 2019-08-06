class Users::BookmarksController < ApplicationController

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
	def bookmark_params
		params.require(:bookmark).permit(:user_id, :note_id)
	end

end
