require 'redcarpet'
require 'rouge'
require 'rouge/plugins/redcarpet'
# markdown構文向けの独自のレンダリングクラス
class HTML < Redcarpet::Render::HTML
  include Rouge::Plugins::Redcarpet
end
#Recarpet の renderer を変更してあるので
#Redcarpet::Render::HTML を継承してカスタムなレンダー用クラスを定義する。
#Rougeのプラグインをインクルード。

module MarkdownHelper
	def markdown(content)
		options = {
		filter_html: true,
		hard_wrap: true,
		space_after_headers: true,
		with_toc_data: true
		}
		extensions = {
		autolink: true,
		no_intra_emphasis: true,
		fenced_code_blocks: true,
		tables: true
		}
		#右のコードはredcarpet単体時のコード
		renderer = HTML.new(options)												#renderer = Redcarpet::Render::HTML.new(options)から変更
		markdown = Redcarpet::Markdown.new(renderer, extensions)		#markdown = Redcarpet::Markdown.new(renderer, extensions)から変更
		markdown.render(content).html_safe#html = markdown.render(content) 											#markdown.render(content).html_safeから変更


	end
end