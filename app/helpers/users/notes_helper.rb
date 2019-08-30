# frozen_string_literal: true

module Users::NotesHelper
  def render_with_hashtags(overview)
    # ハッシュタグに基づいたurlを作る
    overview.gsub(/[#＃][\w\p{Han}ぁ-ヶｦ-ﾟー]+/) { |tag_name| link_to tag_name, "/notes/hashtag/#{tag_name.delete('#')}" }.html_safe
  end
end
