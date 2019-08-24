class Users::BookmarksController < ApplicationController

	def user_index
		@bookmarks = Bookmark.where(user_id: current_user.id)
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

	def destroy#show/noteからの削除
		@note = Note.find(params[:id])
		@bookmark = Bookmark.find_by(note_id: @note.id, user_id: current_user.id)
  		@bookmark.destroy
  			flash[:notice] = "Bookmarkを一つ削除しました。"
	  		redirect_to bookmarks_path
	end

	def one_destroy#bookmarks_pathからの削除
		@bookmark = Bookmark.find(params[:id])
  		@bookmark.destroy
  			flash[:notice] = "Bookmarkを一つ削除しました。"
	  		redirect_to bookmarks_path
	  end

	private
	def bookmark_params
		params.require(:bookmark).permit(:id, :user_id, :note_id)
	end


end
