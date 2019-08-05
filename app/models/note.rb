class Note < ApplicationRecord

	belongs_to :user
	has_many :bookmarks
	#dependent: :delete_allはしない理由はユーザーが急にbookmarkがなくなったと思ってしまうから。
	#bookmarkから飛んだ時に記事が削除されていることに気がつけば、似ている記事を探しにいくことができる。（題名と概要は残しておく？）

	has_many :my_notes
	#bookmarksと同様の理由でdependent_allは無し

	has_many :reviews
	#bookmarksと同様の理由でいいか？

	has_many :postscripts dependent: :delete_all
	#postscriptsはあくまでnoteの一部であるから消す。noteが論理削除→postscriptsも論理削除にしたい

	has_many :note_hashtags dependent: :delete_all
	#noteが論理削除→note_hashtagsも論理削除にしたい
	#もちろんhashtagsは消えない。

end
