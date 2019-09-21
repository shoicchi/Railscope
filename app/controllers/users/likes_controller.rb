# frozen_string_literal: true

class Users::LikesController < ApplicationController

  def create
    @note = Note.find_by(id: params[:note_id])
    @like = Like.new(user_id: current_user.id, note_id: @note.id)
    @like.save
    @like_count = Like.where(note_id: @note.id).count
  end

  def delete
    @note = Note.find_by(id: params[:note_id])
    @like = Like.find_by(user_id: current_user.id, note_id: @note.id)
    @like.destroy
    @like_count = Like.where(note_id: @note.id).count
  end

  private

  def like_params
    params.require(:like).permit(:id, :user_id, :note_id)
    end
end
