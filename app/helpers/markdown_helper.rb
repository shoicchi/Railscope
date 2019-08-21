require 'redcarpet'
require 'rouge'
require 'rouge/plugins/redcarpet'

class HTML < Redcarpet::Render::HTML
  include Rouge::Plugins::Redcarpet
end
#Redcarpet::Render::HTML を継承。
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
		renderer = HTML.new(options)									#Redcarpet::Render::HTML.new(options)を継承させ、rougeのプラグインをした状態のHTMLを使用
		markdown = Redcarpet::Markdown.new(renderer, extensions)
		markdown.render(content).html_safe

	end
end