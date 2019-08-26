class Users::NotesController < ApplicationController

	def index
		words = params[:q].delete(:search_words) if params[:q].present?	#params[:q]=nilだとエラー出るのでif #.deleteしないとwordsがシンボル？として扱われてsplitできない
		if words.present?
			params[:q][:groupings] = [] 								#配列の生成
		    words.split(/[ 　]/).each_with_index do |word, i|			#全角空白と半角空白で文字列を区切る。<=( /と/の間が区切る文字&[と]の間にある文字はどれか1つが選択される )
		    															#.each_with_indexで要素の数|i|だけブロック|word|を繰り返し実行
		    	params[:q][:groupings][i] = { title_or_overview_or_content_or_reviews_review_or_postscripts_postscript_cont: word }
		    end 														#検索範囲にかけて格納していく
		end
		@q = Note.ransack(params[:q])
		if params[:q].nil?												#何も検索していない時は@notes=nilとしてview側にも条件分岐記載して、notes.allが出ないようにする
			@notes = nil
		else
			@notes = @q.result.distinct.page(params[:page]).per(10).reverse_order	#distinctで一意性を持たせる
		end
	end

	def show
		@note = Note.find(params[:id])
		if user_signed_in?
			if 	Bookmark.find_by(user_id: current_user.id, note_id: @note.id).present?
				@bookmark = Bookmark.find_by(user_id: current_user.id, note_id: @note.id)
			else
				@bookmark = Bookmark.new
			end
			if MyNote.find_by(user_id: current_user.id, note_id: @note_id).present?
				@my_note = MyNote.find_by(user_id: current_user.id, note_id: @note_id).present?
			else
				@my_note = MyNote.new
			end
			@review = Review.new
		else

		end
		@reviews = @note.reviews.page(params[:page]).reverse_order
		@postscripts = @note.postscripts

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
    	@notes = tag.notes.all.page(params[:page]).per(10).reverse_order#tag_nameに基づいたnoteを変数で渡す
    	@note = tag.notes.page(params[:page])

    	words = params[:q].delete(:search_words) if params[:q].present?	#params[:q]=nilだとエラー出るのでif #.deleteしないとwordsがシンボル？として扱われてsplitできない
		if words.present?
			params[:q][:groupings] = [] 								#配列の生成
		    words.split(/[ 　]/).each_with_index do |word, i|			#全角空白と半角空白で文字列を区切る。<=( /と/の間が区切る文字&[と]の間にある文字はどれか1つが選択される )
		    															#.each_with_indexで要素の数|i|だけブロック|word|を繰り返し実行
		    	params[:q][:groupings][i] = { title_or_overview_or_content_or_reviews_review_or_postscripts_postscript_cont: word }
		    end 														#検索範囲にかけて格納していく
		end
		@q = Note.ransack(params[:q])

  	end


	private
	def note_params
		params.require(:note).permit(:user_id, :title, :overview, :content, :is_browsable_guest, :view_point)
	end


end
