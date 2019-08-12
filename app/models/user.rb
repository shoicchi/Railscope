class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: %i(github) #この一行はgithub認証のために記載

  #以下全て基本的にはuserは退会フラグで退会状況を確認するので論理削除はほとんどない？

  has_many :review
  #userが退会した場合はreviewの取り扱いを確認する。

  has_many :notes
  #userが退会した場合はnotesの取り扱いを確認する。

  has_many :bookmarks
  #再登録があるので保持？再登録したら買い直させる？
  #noteの評価の一つにされるbookmark数への影響は？
  has_many :notes, through: :bookmarks

  has_many :my_notes
  #再登録があるので保持？再登録したら買い直させる？
  #noteの評価の一つにされる閲覧（購入）数への影響は？
  has_many :notes, through: :my_notes

  has_many :points
  #再登録があるので保持or再登録したら買い直させる=>dependent: :delete_all

  enum is_member: {
    無料会員:0,
    有料会員:1
  }

  enum is_delivery: {
    配信中:1,
    配信停止中:0
  }


  #以下github認証に使用
  def self.create_unique_string #ランダムにuid作成
    SecureRandom.uuid
  end

  def self.find_for_github_oauth(auth, signed_in_resource=nil)
    user = User.find_by(provider: auth.provider, uid: auth.uid)

    unless user
      user = User.new(provider: auth.provider,
                      uid:      auth.uid,
                      name:     auth.info.name,
                      email:    User.dummy_email(auth),
                      password: Devise.friendly_token[0, 20]
                      )
    end
    user.save
    user
  end

  def self.dummy_email(auth)
    "#{auth.uid}-#{auth.provider}@example.com"
  end


end
