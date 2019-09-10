# frozen_string_literal: true

class Users::PostscriptsController < ApplicationController

  def create
    @postscript = Postscript.new(postscript_params)
    if @postscript.save
      @review = @postscript.review
      @review.is_appending = 2
      @review.save
      flash[:notice] = 'このNoteに追記しました。'
      redirect_to note_path(@postscript.note_id)
    else
      flash[:notice] = 'このNoteに追記に失敗しました。やり直してください。'
      redirect_to note_path(@postscript.note_id)
    end
  end

  def edit
    @postscript = Postscript.find(params[:id])
    @review = @postscript.review
    @note = @postscript.note
  end

  def update
    @postscript = Postscript.new(postscript_params)
    if @postscript.update
      flash[:notice] = '追記を編集しました。'
      redirect_to note_path(@postscript.note_id)
    else
      flash[:notice] = '追記の編集に失敗しました。やり直してください。'
      redirect_to note_path(@postscript.note_id)
    end
  end

  def destroy
    @postscript = Postscript.find(params[:id])
    if @postscript.destroy
      flash[:notice] = '追記を一つ削除しました。'
      @review = @postscript.review
      @review.is_appending = 1
      @review.save
      redirect_to note_path(@postscript.note)
    else
      flash[:notice] = '追記の削除に失敗しました。やり直してください。'
      redirect_to note_postscript_path(@postscript)
      end
  end

  private

  def postscript_params
    params.require(:postscript).permit(:review_id, :note_id, :postscript)
  end
end
