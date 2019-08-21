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