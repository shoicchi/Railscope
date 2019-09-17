# frozen_string_literal: true

class Review < ApplicationRecord
  belongs_to :user

  belongs_to :note

  # NOTE: dependent: :deleteはしない。postscriptはnoteの一部。
  has_one :postscript

  enum is_appending: {
    追記を希望しない: 0,
    追記を希望する: 1,
    希望した追記にリアクション済み: 2
  }
end
