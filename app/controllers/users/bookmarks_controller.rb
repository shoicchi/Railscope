class Users::BookmarksController < ApplicationController

	def index
		@bookmark =
	end

	def show
	end

	def new
	end

	def create
		@bookmark = Bookmark.new(bookmark_params) #users/note/showから
		@bookmark.save
		redirect_to bookmarks_path
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
