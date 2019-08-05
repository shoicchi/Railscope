class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  #以下全て基本的にはuserは退会フラグで退会状況を確認するので物理論理削除はほとんどない？

  has_many :review
  #userが退会した場合はreviewの取り扱いを確認する。

  has_many :notes
  #userが退会した場合はnotesの取り扱いを確認する。

  has_many :bookmarks
  #再登録があるので保持？再登録したら買い直させる？
  #noteの評価の一つにされるbookmark数への影響は？

  has_many :my_notes
  #再登録があるので保持？再登録したら買い直させる？
  #noteの評価の一つにされる閲覧（購入）数への影響は？

  has_many :points
  #再登録があるので保持or再登録したら買い直させる=>dependent: :delete_all


end
