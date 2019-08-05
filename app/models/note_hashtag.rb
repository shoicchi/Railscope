class NoteHashtag < ApplicationRecord

	belongs_to :note
	#note_hashtagsを消すことはない。noteが削除されたときには削除される。

	belongs_to :hashtag
	#note_hashtagsを消すことはない。hashtagsを消すこともない。

end
