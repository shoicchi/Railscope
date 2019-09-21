# frozen_string_literal: true

class Users::BookmarksController < ApplicationController
  def index
    @bookmarks = current_user.bookmarks.page(params[:page]).reverse_order
  end

  def create
    @bookmark = Bookmark.new(bookmark_params)
    if @bookmark.save
      flash[:notice] = 'Bookmarkを１つ追加しました。'
      redirect_to bookmarks_path
    else
      flash[:notice] = 'Bookmarkの追加に失敗しました。再度やり直してください。'
      redirect_to note_path(@bookmark.note_id)
    end
  end

  def destroy
    @bookmark = Bookmark.find(params[:id])
    if @bookmark.destroy
      flash[:notice] = 'Bookmarkを一つ削除しました。'
    else
      flash[:notice] = 'Bookmarkの削除に失敗しました。再度やり直してください。'
    end
    redirect_to bookmarks_path
  end

  private

  def bookmark_params
    params.require(:bookmark).permit(:id, :user_id, :note_id)
  end
end
