# frozen_string_literal: true

namespace :point do
  desc 'check_state'
  task monthly_add: :environment do
    require'time'
    time = Time.now
    # タスク開始時刻をputs
    puts "[start]#{time}"
    # １ヶ月前に作成または更新されているsubscriptionテーブルを取り出す。
    add_subscriptions = Subscription.where(updated_at: 1.month.ago.all_day)
    Payjp.api_key = ENV['PAYJP_SECRET']
    i = 0
    add_subscriptions.each do |add_subscription|
      i += 1
      # 視認性確保＋count
      puts "count(#{i})"
      # Subscriptionsテーブルのsubscription.payjp_idから情報を取得
      payjp_data = Payjp::Subscription.retrieve(add_subscription.payjp_id)
      # pointsテーブルの処理ーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー
      # payjpのcustomerからuser判別
      user = User.find_by(payjp_id: payjp_data.customer)
      # pointテーブルに付与履歴を残す
      point = Point.new
      point.user_id = user.id
      # 月額付与分
      point.reason = 1
      # payjpのplanテーブルのidは付与するpointと同値に設定してあるのでplan.idを付与ポイントに代入
      point.point = payjp_data.plan.id
      if point.save
        puts "point.save.success : point.id => #{point.id}, point.user_id => #{point.user_id}, point.point => #{point.point}"
      else
        puts "[!ERROR!] point.save.error : point.id => #{point.id}, point.user_id => #{point.user_id}, point.point => #{point.point}"
      end
      # usersテーブルの処理ーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー
      # userのholding_pointにも付与
      user.holding_point += point.point
      if user.save
        # flashのようなものをつけてユーザーに通知したい。flashは使えない。通知機能実装後？
        puts "user.holding_point.save.success : user.id => #{user.id}, add_point => #{point.point}, user.holding_point => #{user.holding_point}"
      else
        puts "[!ERROR!] user.holding_point.save.error : user.id => #{user.id}, add_point => #{point.point}"
      end
      # subscriptionsテーブルの処理ーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー
      # subscriptionテーブルのupdated_atのみ更新（更新日時を参照して、ポイント付与するため）
      if add_subscription.touch
        puts "user.subscription.save.success : user.id => #{add_subscription.user_id}, payjp_id => #{add_subscription.payjp_id}"
      else
        puts "[!ERROR!] user.subscription.save.error : user.id => #{add_subscription.user_id}, payjp_id => #{add_subscription.payjp_id}"
      end
    end
    # タスク終了時刻をputs
    puts "[finish]#{time}"
  end
end
