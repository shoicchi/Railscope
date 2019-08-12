class Point < ApplicationRecord

	belongs_to :user

	enum reason: {
		Note購入:0,
		月額料金分付与:1,
		Point追加購入:2,
	}


end
