class Note < ApplicationRecord

	belongs_to :user
	has_many :users, through: :bookmarks
	has_many :bookmarks
	#dependent: :delete_allはしない理由はユーザーが急にbookmarkがなくなったと思ってしまうから。
	#bookmarkから飛んだ時に記事が削除されていることに気がつけば、似ている記事を探しにいくことができる。（題名と概要は残しておく？）

	has_many :my_notes
	#bookmarksと同様の理由でdependent_allは無し

	has_many :reviews
	#bookmarksと同様の理由でいいか？
	accepts_nested_attributes_for :reviews

	has_many :postscripts, dependent: :delete_all
	#postscriptsはあくまでnoteの一部であるから消す。noteが論理削除→postscriptsも論理削除にしたい

	has_many :note_hashtags, dependent: :delete_all
	#noteが論理削除→note_hashtagsも論理削除にしたい
	#もちろんhashtagsは消えない。

	has_many :hashtags, through: :note_hashtags#中間テーブルを通して紐づいたhashtagsを取り出せるようにする

	enum is_browsable_guest:{
		無料会員閲覧可能記事: 0,
		有料会員限定記事: 1
	}

	ransack_alias :search_words, :title_or_overview_or_content_or_reviews_review_or_postscripts_postscript_cont

	#DBへのコミット直前に実施する
 	after_create do
    	note = Note.find_by(id: self.id)
    	hashtags  = self.overview.scan(/[#＃][\w\p{Han}ぁ-ヶｦ-ﾟー]+/)
    	hashtags.uniq.map do |hashtag|
    	  #ハッシュタグは先頭の'#'を外した上で保存
    		tag = Hashtag.find_or_create_by(tag_name: hashtag.downcase.delete('#'))
   			note.hashtags << tag#追加してる
    	end
	end

	before_update do
    	note = Note.find_by(id: self.id)
    	note.hashtags.clear
    	hashtags = self.overview.scan(/[#＃][\w\p{Han}ぁ-ヶｦ-ﾟー]+/)
    	hashtags.uniq.map do |hashtag|
    		tag = Hashtag.find_or_create_by(tag_name: hashtag.downcase.delete('#'))
     	note.hashtags << tag
    	end
 	end




end
