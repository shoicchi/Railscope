# frozen_string_literal: true

class Users::ReviewsController < ApplicationController
  def show
    @review = Review.find(params[:id])
    @note = @review.note
    @postscript = Postscript.new
  end

  def create
    @review = Review.new(review_params)
    redirect_to note_path(@review.note_id) if @review.save
  end

  private

  def review_params
    params.require(:review).permit(:user_id, :note_id, :quality, :review, :is_appending)
  end
end
