class Postscript < ApplicationRecord

	belongs_to :review
	#レビューありきの追記のためbelongs_to

	belongs_to :note
end
