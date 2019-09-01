# frozen_string_literal: true

class Users::MyNotesController < ApplicationController
  def index
    @my_notes = MyNote.where(user_id: current_user.id).page(params[:page]).reverse_order
  end

  def create
    @my_note = MyNote.new(my_note_params)
    @my_note.user_id = current_user.id

    if current_user.holding_point >= @my_note.note.view_point
      if @my_note.save
        # Pointテーブル処理
        @point = Point.new
        @point.point = @my_note.note.view_point
        @point.reason = 0
        @point.user_id = current_user.id
        @point.save
        # Userテーブル処理
        current_user.holding_point -= @point.point
        current_user.save
        flash[:notice] = 'このNoteを購入しました'
        redirect_to note_path(@my_note.note_id)
      else
        flash[:notice] = 'Noteを購入に失敗しました。やり直してください'
        redirect_to note_path(@my_note.note_id)
      end

    # 保有ポイントが閲覧必要ポイントより少ない場合
    elsif current_user.holding_point < @my_note.note.view_point
      flash[:notice] = '閲覧ポイントが足りません。ポイントを追加購入してください。'
      redirect_to new_point_path

    else
      flash[:notice] = 'Noteを購入に失敗しました。やり直してください'
      redirect_to note_path(@my_note.note_id)
    end
  end

  private

  def my_note_params
    params.require(:my_note).permit(:user_id, :note_id)
  end
end
