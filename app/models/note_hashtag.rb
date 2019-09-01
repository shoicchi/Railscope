# frozen_string_literal: true

class NoteHashtag < ApplicationRecord
  belongs_to :note
  belongs_to :hashtag

  validates  :note_id, presence: true
  validates  :hashtag_id, presence: true
end
