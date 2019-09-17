# frozen_string_literal: true

class Users::SubscriptionsController < ApplicationController
  def index
    @point = Point.new
    # HACK: modelで処理できそう => current_userがsubscriptionテーブルを保持しているかどうか（定期課金申し込み済みかどうかの判断）
    if Subscription.where(user_id: current_user.id).exists?
      Payjp.api_key = ENV['PAYJP_SECRET']
      # NOTE: current_userの定期課金情報をpayjpから取得
      @subscription = Payjp::Subscription.retrieve(current_user.subscription.payjp_id)
    end
  end

  # NOTE: カード入力によって得られたトークンで顧客作成（単発のみではなく、永続的にトークンを使用可能にする）
  def registration_payjp
    Payjp.api_key = ENV['PAYJP_SECRET']
    # NOTE: トークンをもとに顧客を作成
    response_customer = Payjp::Customer.create(card: params['payjp-token'])
    # NOTE: 作成した顧客のidををuserテーブルのpayjp_id(string)としてDBに保存
    current_user.payjp_id = response_customer.id
    if current_user.save
      flash[:notice] = 'カードを登録しました。お得なプランにしませんか？'
      redirect_to subscriptions_path
    else
      flash[:notice] = 'カードの登録に失敗しました。やり直してください。'
      redirect_to new_subscription_path
    end
  end

  # NOTE: 月額定期課金支払い
  # HACK: さすがに冗長。find_or_created_byが使える？
  def monthly_subscription
    # NOTE: viewからはPointのみhiddenで持ってくる。pointの値をpayjpのplanのIDに設定してある。
    # REVIEW: そもそも金銭にあたるpointをhiddenにするのは危険？
    @point = Point.new(point_params)
    # NOTE: カード登録済みでなければカード登録させる。
    if current_user.payjp_id.nil?
      flash[:notice] = 'カードを登録してください'
      redirect_to new_subscription_path

    else
      # NOTE: 定期課金に申し込み済みの場合(定期課金額変更の場合)
      if Subscription.where(user_id: current_user.id).exists?
        # NOTE: 以下pay.jpの処理
        Payjp.api_key = ENV['PAYJP_SECRET']
        # NOTE: userのsubscription.payjp_idから情報を取得
        change_subscription = Payjp::Subscription.retrieve(current_user.subscription.payjp_id)
        # NOTE: planを上書き、pointはpayjpのplanIDとして設定済
        change_subscription.plan = @point.point
        if change_subscription.save
          # NOTE: 以下user.subscriptionの処理
          @subscription = current_user.subscription
          @subscrition = change_subscription.id
          @subscription.save
          # NOTE: Pointテーブルについての処理
          # HACK: notDRY: else（新規定期課金登録）のpointテーブルについての処理と同じ記述
          @point.reason = 1
          @point.user_id = current_user.id
          @point.save
          # NOTE: Userテーブルの保有ポイントカラムについての処理
          current_user.holding_point += @point.point
          current_user.save
          flash[:notice] = 'プランを変更しました。'
          redirect_to user_path(current_user)
        else
          flash[:notice] = 'プランの変更に失敗しました。やり直してください。'
          subscriptions_path
        end

      # NOTE: 定期課金に未申し込みの場合(新規定期課金登録)
      else
        Payjp.api_key = ENV['PAYJP_SECRET']
        # NOTE: pay.jpのsubscriptionにcustomerとplanを紐づける
        new_subscription = Payjp::Subscription.create(
          customer: current_user.payjp_id,
          # NOTE: pay.jpのプランのIDを毎月の付与ポイントと一致させておくことで記述量が少なくなる＋確認しやすくなる
          plan: @point.point
        )
        @subscription = Subscription.new
        @subscription.user_id = current_user.id
        # NOTE: 作成した定期課金情報のidををuser.subscription.payjp_id(string)としてDBに保存。
        # WARNING: ↑これをしないと更新や参照ができない＋サーバサイドでモデルを作ることにより履歴も追えてupdate_atから毎月のポイント付与もできる
        @subscription.payjp_id = new_subscription.id
        if @subscription.save
          # NOTE: Pointテーブルについての処理
          # HACK: notDRY: 定期課金額変更の場合のpointテーブルについての処理と同じ記述
          @point.reason = 1
          @point.user_id = current_user.id
          @point.save
          # NOTE: Userテーブルの保有ポイントカラムについての処理
          current_user.holding_point += @point.point
          current_user.is_member = '有料会員'
          current_user.save
          flash[:notice] = 'プランの登録に成功しました。'
          redirect_to user_path(current_user)
        else
          flash[:notice] = 'プランの登録に失敗しました。やり直してください。'
          subscriptions_path
        end
      end
    end
  end

  private

  def subscription_params
    params.require(:subscription).permit(:id, :user_id, :payjp_id, :created_at, :updated_at)
  end

  def point_params
    params.require(:point).permit(:id, :user_id, :reason, :point, :created_at, :updated_at)
  end
end
