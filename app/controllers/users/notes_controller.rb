class Users::NotesController < ApplicationController

	def index
		@notes = Note.all.order(id: "DESC") #一旦ALL、検索なしには表示しない

	end

	def show
		@note = Note.find(params[:id])
		@bookmark = Bookmark.new
		@my_note = MyNote.new
		@reviews = @note.reviews
		@review = Review.new
		@postscripts = @note.postscripts

		@bookmarks = Bookmark.where(user_id: current_user.id)#ユーザーがお気に入り済みか否かの判断に使用
		@my_notes = MyNote.where(user_id: current_user.id)#ユーザーが購入済みか否かの判断に使用
	end



	def new
		@note = Note.new
		#@note_hashtag = NoteHashtag.new
		#@hashtag = Hashtag.new
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
		@note = Note.find(params[:id])
	end

	def update
		@note = Note.find(params[:id])
		if @note.update(note_params)
			flash[:notice] = "この Note を編集しました。"
			redirect_to note_path(@note)
		else
			flash[:notice] = "編集に失敗しました。やり直してください。"
			render :edit
		end
	end

	def destroy
		@note = Note.find(params[:id])
		@note.destroy
		redirect_to notes_path
	end

	def hashtag
    	tag = Hashtag.find_by(tag_name: params[:tag_name])#選択したハッシュタグのtag_nameを取り出して
    	@notes = tag.notes.all#tag_nameに基づいたnoteを変数で渡す
    	@note = tag.notes.page(params[:page])
  	end


	private
	def note_params
		params.require(:note).permit(:user_id, :title, :overview, :content, :is_browsable_guest, :view_point)
	end


end
