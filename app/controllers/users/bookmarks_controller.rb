class Users::BookmarksController < ApplicationController

	def index
		@bookmarks = Bookmark.where(user_id: current_user.id)
	end

	def show
	end

	def new
	end

	def create
		@bookmark = Bookmark.new(bookmark_params) #users/note/showから

		@bookmark.save
		redirect_to notes_path#仮)
	end

	def edit
	end

	def update
	end

	def destroy
		@note = Note.find(params[:id])
		@bookmark = Bookmark.find_by(note_id: @note.id, user_id: current_user.id)
  		@bookmark.destroy
  			flash[:notice] = "Bookmarkを一つ削除しました。"
	  		redirect_to note_bookmarks_path
	end

	private
	def bookmark_params
		params.require(:bookmark).permit(:id, :user_id, :note_id)
	end
	def note_params
		params.require(:note).permit(:user_id, :title, :overview, :content, :is_browsable_guest, :view_point)
	end

end
