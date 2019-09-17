# frozen_string_literal: true

namespace :point do
  desc 'check_state'
  task monthly_add: :environment do
    require'time'
    time = Time.now
    puts "[start]#{time}"
    # NOTE: １ヶ月前に作成または更新されているsubscriptionテーブルを処理。
    add_subscriptions = Subscription.where(updated_at: 1.month.ago.all_day)
    Payjp.api_key = ENV['PAYJP_SECRET']
    i = 0
    add_subscriptions.each do |add_subscription|
      i += 1
      puts "count(#{i})"
      payjp_data = Payjp::Subscription.retrieve(add_subscription.payjp_id)

      # NOTE: pointsテーブルの処理
      # NOTE: payjpのcustomerからuser判別
      user = User.find_by(payjp_id: payjp_data.customer)
      point = Point.new
      point.user_id = user.id
      point.reason = 1
      point.point = payjp_data.plan.id
      if point.save
        puts "point.save.success : point.id => #{point.id}, point.user_id => #{point.user_id}, point.point => #{point.point}"
      else
        puts "[!ERROR!] point.save.error : point.id => #{point.id}, point.user_id => #{point.user_id}, point.point => #{point.point}"
      end

      # NOTE: usersテーブルの処理
      user.holding_point += point.point
      if user.save
        # TODO: flashのようなものをつけてユーザーに通知したい。flashは使えない。通知機能実装後？
        puts "user.holding_point.save.success : user.id => #{user.id}, add_point => #{point.point}, user.holding_point => #{user.holding_point}"
      else
        puts "[!ERROR!] user.holding_point.save.error : user.id => #{user.id}, add_point => #{point.point}"
      end

      # NOTE: subscriptionsテーブルの処理
      # NOTE: subscriptionテーブルのupdated_atのみ更新（バッチ処理の対象が1ヶ月前に更新されているのsubscriptionテーブルも該当するため）
      if add_subscription.touch
        puts "user.subscription.save.success : user.id => #{add_subscription.user_id}, payjp_id => #{add_subscription.payjp_id}"
      else
        puts "[!ERROR!] user.subscription.save.error : user.id => #{add_subscription.user_id}, payjp_id => #{add_subscription.payjp_id}"
      end
    end
    puts "[finish]#{time}"
  end
end
