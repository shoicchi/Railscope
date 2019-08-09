class Hashtag < ApplicationRecord

	has_many :note_hashtags
	validates :tag_name, presence: true
	has_many :notes, through: :note_hashtags#中間テーブルを通して紐づいているnotesを取り出せるようにする
end
