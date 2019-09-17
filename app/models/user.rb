# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         # NOTE: github認証のために記載
         :omniauthable, omniauth_providers: %i[github]

  has_many :review

  has_many :notes
  has_many :notes, through: :bookmarks
  has_many :notes, through: :my_notes

  # NOTE: 再登録があるので保持
  has_many :bookmarks

  # NOTE: 再登録があるので保持、noteの評価の一つにされる購入数への影響がなくなる
  has_many :my_notes

  # NOTE: 再登録があるので保持
  has_many :points

  has_one :subscription

  has_many :likes

  has_many :users, through: :likes

  enum is_member: {
    無料会員: 0,
    有料会員: 1
  }

  enum is_delivery: {
    配信中: 1,
    配信停止中: 0
  }

  # NOTE: github認証に使用、ランダムにuid作成
  def self.create_unique_string
    SecureRandom.uuid
  end

  # TODO: 内容理解
  def self.find_for_github_oauth(auth, _signed_in_resource = nil)
    user = User.find_by(provider: auth.provider, uid: auth.uid)
    user ||= User.new(provider: auth.provider,
                      uid: auth.uid,
                      name: auth.info.name,
                      email: User.dummy_email(auth),
                      password: Devise.friendly_token[0, 20])
    user.save
    user
  end

  # XXX: 内容理解
  def self.dummy_email(auth)
    "#{auth.uid}-#{auth.provider}@example.com"
  end

  # NOTE: 該当ユーザーの投稿Note数
  def total_notes
    Note.where(user_id: id).size
  end

  # NOTE: 該当ユーザーの投稿した総noteに対する合計レビュー数
  def total_reviews
    notes = Note.where(user_id: id)
    # WARNING: 初期値を与えておかないと以下のeachでnilに対する+=処理となってしまう。
    total = 0
    notes.each do |note|
      total += Review.where(note_id: note.id).size
    end
    total
  end

  # NOTE: 該当ユーザーの投稿した総noteに対する合計いいね数
  # TODO: rename
  def all_likes
    notes = Note.where(user_id: id)
    # WARNING: 初期値を与えておかないと以下のeachでnilに対する+=処理となってしまう。
    total = 0
    notes.each do |note|
      total += Like.where(note_id: note.id).size
    end
    total
  end

  # NOTE: reviewのqualityの平均値
  def average_quality
    notes = Note.where(user_id: id)
    # WARNING: 初期値を与えておかないと以下のeachでnilに対する+=処理となってしまう。
    average = 0
    notes.each do |note|
      # WARNING: reviewがnilの場合は.averageで0を足させる。 nil.to_i => 0を返す
      average += Review.where(note_id: id).average(:quality).to_i
    end
    notes = Note.where(user_id: id).size
    # NOTE: average / notesの分母が0だと計算できないので0を返させる。
    if notes == 0
      0
    else
      average / notes
    end
  end

  # NOTE: 追記希望レビューへのリアクション率
  def reply_rate
    notes = Note.where(user_id: id)
    # WARNING: 初期値を与えておかないと以下のeachでnilに対する+=処理となってしまう。
    hope = 0
    reply = 0
    notes.each do |note|
      hope += Review.where(note_id: note.id).where(is_appending: '追記を希望する').size
      reply += Review.where(note_id: note.id).where(is_appending: '希望した追記にリアクション済み').size
    end
    # NOTE: reviewが０またはreviewのis_appendingが全て0の場合の処理。
    # NOTE: 100 * reply / (hope + reply)の分母が0だと計算できないので0を返させる。
    if (hope + reply) == 0
      0
    else
      100 * reply / (hope + reply)
    end
  end

end
