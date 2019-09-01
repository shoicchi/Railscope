# frozen_string_literal: true

class Users::PostscriptsController < ApplicationController

  def create
    @postscript = Postscript.new(postscript_params)
    @review = @postscript.review
    @review.is_appending = 2
    if @postscript.save
      @review.save
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
    redirect_to note_path(@postscript.note_id) if @postscript.update
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
      redirect_to note_postscript_path(@postscript)
      end
  end

  private

  def postscript_params
    params.require(:postscript).permit(:review_id, :note_id, :postscript)
  end
end
