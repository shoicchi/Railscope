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

		if current_user.holding_point >= @my_note.note.view_point
			if @my_note.save
				#以下Pointテーブルに使用履歴を残すため
				@point = Point.new
				@point.point = @my_note.note.view_point
				@point.reason = 0
				@point.user_id = current_user.id
				@point.save
				#保有ポイントから閲覧ポイント消費
				current_user.holding_point -= @point.point
				current_user.save
				flash[:notice] = "このNoteを購入しました"
				redirect_to note_path(@my_note.note_id)
			else
				flash[:notice] = "Noteを購入に失敗しました。やり直してください"
				redirect_to note_path(@my_note.note_id)
			end

		elsif current_user.holding_point < @my_note.note.view_point#保有ポイントが閲覧必要ポイントより少ない場合
				flash[:notice] = "閲覧ポイントが足りません。ポイントを追加購入してください。"
				redirect_to new_point_path

		else
			flash[:notice] = "Noteを購入に失敗しました。やり直してください"
			redirect_to note_path(@my_note.note_id)
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
