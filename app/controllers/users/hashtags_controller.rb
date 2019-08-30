# frozen_string_literal: true

class Users::HashtagsController < ApplicationController
  private

  def hash_tag_params
    params.require(:hash_tag).permit(:tag_name)
  end
end
