# frozen_string_literal: true

class Hashtag < ApplicationRecord
  has_many :note_hashtags
  validates :tag_name, presence: true
  # NOTE: 中間テーブルを通して紐づいているnotesを取り出せるようにする
  has_many :notes, through: :note_hashtags
end
