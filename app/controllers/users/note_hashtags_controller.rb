class Users::NoteHashtagsController < ApplicationController

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
	def note_hashtag_params
		params.require(:note_hashtag).permit(:note_id, :hashtag_id)
	end

end
