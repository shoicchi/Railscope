class Admins::NotesController < ApplicationController

	def index
	end

	def show
	end

	def new
		@note = Note.new
	end

	def create
		@note = Note.find(params[:id])
	end

	def edit
	end

	def update
	end

	def destroy
	end

	private
	def note_params
		params.require(:note).permit(:user_id, :title, :overview, :content, :is_browsable_guest, :view_point)
	end

end
