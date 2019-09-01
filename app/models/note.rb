# frozen_string_literal: true

class Note < ApplicationRecord
  belongs_to :user
  has_many :users, through: :bookmarks
  # dependent: :delete_allはしない理由はユーザーが急にbookmarkがなくなったと思ってしまうから。
  # bookmarkから飛んだ時に記事が削除されていることに気がつけば、似ている記事を探しにいくことができる。（題名と概要は残しておき、削除されていることがわかるようにする）
  has_many :bookmarks

  has_many :likes
  has_many :users, through: :likes

  # bookmarksと同様の理由でdependent_allは無し
  has_many :my_notes
  has_many :users, through: :my_notes


  # bookmarksと同様の理由でdependent_allは無し
  has_many :reviews
  accepts_nested_attributes_for :reviews

  # postscriptsはあくまでnoteの一部であるから消す。
  has_many :postscripts, dependent: :delete_all


  has_many :note_hashtags, dependent: :delete_all


  has_many :hashtags, through: :note_hashtags

  enum is_browsable_guest: {
    無料記事: 0,
    有料会員限定記事: 1
  }

  ransack_alias :search_words, :title_or_overview_or_content_or_reviews_review_or_postscripts_postscript_cont

  # DBへのコミット直前に実施する
  after_create do
    note = Note.find_by(id: id)
    hashtags = overview.scan(/[#＃][\w\p{Han}ぁ-ヶｦ-ﾟー]+/)
    hashtags.uniq.map do |hashtag|
      # ハッシュタグは先頭の'#'を外した上で保存
      tag = Hashtag.find_or_create_by(tag_name: hashtag.downcase.delete('#'))
      note.hashtags << tag
    end
  end

  before_update do
    note = Note.find_by(id: id)
    note.hashtags.clear
    hashtags = overview.scan(/[#＃][\w\p{Han}ぁ-ヶｦ-ﾟー]+/)
    hashtags.uniq.map do |hashtag|
      tag = Hashtag.find_or_create_by(tag_name: hashtag.downcase.delete('#'))
      note.hashtags << tag
    end
  end

  # noteに対してのreviewのqualityの平均値
  def note_quality
    if Review.where(note_id: id).exists?
      Review.where(note_id: id).average(:quality)
    # reviewがnilの場合は0にする
    else
      0
    end
  end

  #購入数
  def purchace_quantity
    MyNote.where(note_id: id).count
  end

  #ノート一つの総いいね数
  def total_like
    Like.where(note_id: id).count
  end
end
