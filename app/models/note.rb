# frozen_string_literal: true

class Note < ApplicationRecord
  belongs_to :user
  has_many :users, through: :bookmarks

  # NOTE: dependent: :delete_allはしない理由はユーザーが急にbookmarkがなくなったと思ってしまうから。
  # TODO: 削除されても、題名と概要のみ残す。（bookmarkから飛んだ時に記事が削除されていることに気がつけば、似ている記事を探しにいくことができる。）
  has_many :bookmarks

  has_many :likes
  has_many :users, through: :likes

  # NOTE: bookmarksと同様の理由でdependent_allは無し
  has_many :my_notes
  has_many :users, through: :my_notes


  # NOTE: bookmarksと同様の理由でdependent_allは無し
  has_many :reviews
  accepts_nested_attributes_for :reviews

  # NOTE: postscriptsはあくまでnoteの一部であるから消す。
  has_many :postscripts, dependent: :delete_all

  has_many :note_hashtags, dependent: :delete_all

  has_many :hashtags, through: :note_hashtags

  enum is_browsable_guest: {
    無料記事: 0,
    有料会員限定記事: 1
  }

  ransack_alias :search_words, :title_or_overview_or_content_or_reviews_review_or_postscripts_postscript_cont

  # NOTE: note投稿後の処理（DBへのコミット直前にハッシュタグ保存を実施する）
  after_create do
    note = Note.find_by(id: id)
    hashtags = overview.scan(/[#＃][\w\p{Han}ぁ-ヶｦ-ﾟー]+/)
    hashtags.uniq.map do |hashtag|
      # NOTE: ハッシュタグは先頭の'#'を外した上で保存
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

  # NOTE: noteに対してのreviewのqualityの平均値
  def note_quality
    if Review.where(note_id: id).exists?
      Review.where(note_id: id).average(:quality)
    # WARNING: reviewがnilの場合は0にする（変更前：viewでnote_quakity.nil?の条件分岐で０を表示）
    else
      0
    end
  end

  # NOTE: 該当noteが購入されている数（countなのでnilを返さない。０を返す）
  def purchace_quantity
    # NOTE: .sizeは配列の場合要素の数を返してくれるので.この場合.countと同義。
    # NOTE: .countはキャッシュを使わないが、.sizeはキャッシュがあれば使ってくれるのでSQL叩く回数が減り高速になる。
    MyNote.where(note_id: id).size
  end

  # NOTE: 該当noteの総いいね数(.count => .size)
  def total_like
    Like.where(note_id: id).size
  end
end
