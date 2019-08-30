# frozen_string_literal: true

class NoteHashtag < ApplicationRecord
  belongs_to :note
  # note_hashtagsを消すことはない。noteが削除されたときには削除される。

  belongs_to :hashtag
  # note_hashtagsを消すことはない。hashtagsもほとんど消すこともない。

  validates  :note_id, presence: true
  validates  :hashtag_id, presence: true
end
