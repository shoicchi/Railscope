class Users::MyNotesController < ApplicationController

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
	def my_note_params
		params.require(:my_note).permit(:user_id, :note_id)
	end

end
