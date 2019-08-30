# frozen_string_literal: true

class MyNote < ApplicationRecord
  belongs_to :user
  belongs_to :note
end
