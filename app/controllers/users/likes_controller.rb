# frozen_string_literal: true

class Users::LikesController < ApplicationController
  def create
    like = Like.new(user_id: current_user.id, note_id: params[:note_id])
    like.save
    @note = Note.find_by(id: like.note_id)
    @like_count = Like.where(note_id: params[:note_id]).count
  end

  def delete
    like = Like.find_by(user_id: current_user.id, note_id: params[:note_id])
    @note = Note.find_by(id: like.note_id)
    like.destroy
    @like_count = Like.where(note_id: params[:note_id]).count
  end

  private

  def like_params
    params.require(:like).permit(:id, :user_id, :note_id)
    end
end
