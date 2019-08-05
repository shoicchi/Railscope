class Review < ApplicationRecord

	belongs_to :user
	belongs_to :note

	has_one :postscript
	#dependent: :deleteはしない。postscriptはnoteの一部。
	#reviewあってのpostscriptなのでhas_one
end
