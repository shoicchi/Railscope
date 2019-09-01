# frozen_string_literal: true

class Postscript < ApplicationRecord
  belongs_to :review
  belongs_to :note
end
