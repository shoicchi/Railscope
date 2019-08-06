class Users::HashtagsController < ApplicationController

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
	def hash_tag_params
		params.require(:hash_tag).permit(:tag_name)
	end

end
