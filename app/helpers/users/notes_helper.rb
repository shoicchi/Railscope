# frozen_string_literal: true

module Users::NotesHelper
	# NOTE: ハッシュタグに基づいたurlを作る
	def render_with_hashtags(overview)
    overview.gsub(/[#＃][\w\p{Han}ぁ-ヶｦ-ﾟー]+/) { |tag_name| link_to tag_name, "/notes/hashtag/#{tag_name.delete('#')}" }.html_safe
	end
end
