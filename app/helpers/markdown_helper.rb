# frozen_string_literal: true

require 'redcarpet'
require 'rouge'
require 'rouge/plugins/redcarpet'

# NOTE: Redcarpet::Render::HTML を継承してRougeのプラグインをインクルード。
class HTML < Redcarpet::Render::HTML
  include Rouge::Plugins::Redcarpet
end

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
    # NOTE: Redcarpet::Render::HTML.new(options)を継承させ、rougeのプラグインをした状態のHTMLを使用
    renderer = HTML.new(options)
    markdown = Redcarpet::Markdown.new(renderer, extensions)
    markdown.render(content).html_safe
  end
end
