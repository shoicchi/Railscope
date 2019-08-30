# frozen_string_literal: true

class Users::NotesController < ApplicationController
  def index
    # params[:q]=nilだとエラー出るのでif #.deleteしないとwordsがシンボル？として扱われてsplitできない
    words = params[:q].delete(:search_words) if params[:q].present?
    if words.present?
      # 配列の生成
      params[:q][:groupings] = []
      # 全角空白と半角空白で文字列を区切る。<=( /と/の間が区切る文字&[と]の間にある文字はどれか1つが選択される )
      # .each_with_indexで要素の数|i|だけブロック|word|を繰り返し実行
      words.split(/[ 　]/).each_with_index do |word, i|
        # 検索範囲にかけて格納していく
        params[:q][:groupings][i] = { title_or_overview_or_content_or_reviews_review_or_postscripts_postscript_cont: word }
      end
    end
    @q = Note.ransack(params[:q])
    # 何も検索していない時は@notes=nilとしてview側にも条件分岐記載して、notes.allが出ないようにする
    @notes = if params[:q].nil?
               nil
             else
               # distinctで一意性を持たせる
               @q.result.distinct.page(params[:page]).per(4).reverse_order
             end
  end

  def show
    @note = Note.find(params[:id])
    if user_signed_in?
      if Bookmark.find_by(user_id: current_user.id, note_id: @note.id).present?
        @bookmark = Bookmark.find_by(user_id: current_user.id, note_id: @note.id)
      else
        @bookmark = Bookmark.new
      end
      if MyNote.find_by(user_id: current_user.id, note_id: @note.id).present?
        @my_note = MyNote.find_by(user_id: current_user.id, note_id: @note.id)
      else
        @my_note = MyNote.new
      end
      @like_count = @note.total_like
      @review = Review.new
    end
    @reviews = @note.reviews.page(params[:page]).reverse_order
    @postscripts = @note.postscripts
  end

  def new
    @note = Note.new
  end

  def create
    @note = Note.new(note_params)
    @note.user_id = current_user.id
    if @note.save
      flash[:notice] = 'この Note を投稿しました。'
      redirect_to note_path(@note)
    else
      flash[:notice] = '投稿に失敗しました。やり直してください。'
      render :new
    end
  end

  def edit
    @note = Note.find(params[:id])
  end

  def update
    @note = Note.find(params[:id])
    if @note.update(note_params)
      flash[:notice] = 'この Note を編集しました。'
      redirect_to note_path(@note)
    else
      flash[:notice] = '編集に失敗しました。やり直してください。'
      render :edit
    end
  end

  def destroy
    @note = Note.find(params[:id])
    @note.destroy
    redirect_to notes_path
  end

  def hashtag
    # 選択したハッシュタグのtag_nameを取り出して
    tag = Hashtag.find_by(tag_name: params[:tag_name])
    # tag_nameに基づいたnoteを変数で渡す
    @notes = tag.notes.all.page(params[:page]).per(4).reverse_order
    @note = tag.notes.page(params[:page])
    end

  private

  def note_params
    params.require(:note).permit(:user_id, :title, :overview, :content, :is_browsable_guest, :view_point)
  end
end
