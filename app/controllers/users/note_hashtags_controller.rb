# frozen_string_literal: true

class Users::NoteHashtagsController < ApplicationController

  private

  def note_hashtag_params
    params.require(:note_hashtag).permit(:note_id, :hashtag_id)
  end
end
