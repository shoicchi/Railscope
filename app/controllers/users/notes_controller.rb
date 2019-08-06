class Users::NotesController < ApplicationController

	def index
		@note = Note.all #一旦ALL、検索なしには表示しない
	end

	def show
		@note = Note.find(params[:id])
	end

	def new
		@note = Note.new
	end


	def create
		@note = Note.new(note_params)
		@note.user_id = current_user.id
		if @note.save
			flash[:notice] = "この Note を投稿しました。"
			redirect_to note_path(@note)
		else
			flash[:notice] ="投稿に失敗しました。やり直してください。"
			render :new
		end
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
