# frozen_string_literal: true

class Users::ReviewsController < ApplicationController

  def show
    @review = Review.find(params[:id])
    @note = @review.note
    @postscript = Postscript.new
  end

  def create
    @review = Review.new(review_params)
    if @review.save
      flash[:notice] = 'レビューしました。'
      redirect_to note_path(@review.note_id)
    else
      flash[:notice] = 'レビューに失敗しました。やり直してください。'
      redirect_to note_path(@review.note_id)
    end
  end

  def destroy
    @review = Review.find(params[:id])
    @note = @review.note
    if @review.destroy
      flash[:notice] = 'レビューを削除しました。'
      redirect_to note_path(@note)
    else
      flash[:notice] = 'レビューの削除に失敗しました。やり直してください。'
      redirect_to note_path(@note)
    end
  end

  private

  def review_params
    params.require(:review).permit(:user_id, :note_id, :quality, :review, :is_appending)
  end
end
