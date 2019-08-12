class Users::MyNotesController < ApplicationController

	def index
		@my_notes =  MyNote.where(user_id: current_user.id)
	end

	def show
	end

	def new

	end

	def create
		@my_note = MyNote.new(my_note_params)
		@my_note.user_id = current_user.id

		if @my_note.save#条件分岐はポイントが足りているかどうかでする
			@point = Point.new#以下Pointテーブルに使用履歴を残すため
			@point.point = @my_note.note.view_point
			@point.reason = 0
			@point.user_id = current_user.id
			@point.save

			current_user.holding_point -= @point.point#保有ポイントから閲覧ポイント消費
			current_user.save

			flash[:notice] = "このNoteを購入しました"
			redirect_to note_path(@my_note.note_id)
		else
			redirect_to my_notes_path
		end
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
