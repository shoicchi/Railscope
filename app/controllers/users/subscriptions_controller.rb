# frozen_string_literal: true

class Users::SubscriptionsController < ApplicationController
  def index
    @point = Point.new
    # current_userがsubscriptionテーブルを保持しているかどうか（定期課金申し込み済みかどうかの判断）
    if Subscription.where(user_id: current_user.id).exists?
      Payjp.api_key = ENV['PAYJP_SECRET']
      # current_userの定期課金情報をpayjpから持ってくる
      @subscription = Payjp::Subscription.retrieve(current_user.subscription.payjp_id)
    end
  end

  # カード入力によって得られたトークンで顧客作成（永続的にトークンを使用可能にする）
  def registration_payjp
    Payjp.api_key = ENV['PAYJP_SECRET']
    # トークンをもとに顧客を作成
    response_customer = Payjp::Customer.create(card: params['payjp-token'])
    # 作成した顧客のidををuserテーブルのpayjp_id(string)としてDBに保存
    current_user.payjp_id = response_customer.id
    current_user.save
    redirect_to user_path(current_user.id)
  end

  # 月額定期課金支払い
  def monthly_subscription
    # viewからはPointのみhiddenで持ってくる。pointの値をpayjpのplanのIDに設定してある。
    @point = Point.new(point_params)
    if current_user.payjp_id.nil?
      flash[:notice] = 'カードを登録してください'
      redirect_to new_subscription_path
    end

    # 定期課金に申し込み済みの場合(定期課金額変更の場合)
    if Subscription.where(user_id: current_user.id).exists?
      # 以下pay.jpの処理
      Payjp.api_key = ENV['PAYJP_SECRET']
      # userのsubscription.payjp_idから情報を取得
      change_subscription = Payjp::Subscription.retrieve(current_user.subscription.payjp_id)
      # planを上書き、pointはpayjpのplanIDとして設定済
      change_subscription.plan = @point.point
      change_subscription.save
      # 以下user.subscriptionの処理
      @subscription = current_user.subscription
      @subscrition = change_subscription.id
      @subscription.save
      flash[:notice] = change_subscription.plan.name

    # 定期課金に未申し込みの場合(新規定期課金登録)
    else
      Payjp.api_key = ENV['PAYJP_SECRET']
      # pay.jpのsubscriptionにcustomerとplanを紐づける
      new_subscription = Payjp::Subscription.create(
        customer: current_user.payjp_id,
        # pay.jpのプランのIDを毎月の付与ポイントと一致させておくことで記述量が少なくなる＋確認しやすくなる
        plan: @point.point
      )
      @subscription = Subscription.new
      @subscription.user_id = current_user.id
      # 作成した定期課金情報のidををuser.subscription.payjp_id(string)としてDBに保存。
      # ↑これをしないと更新や参照ができない＋サーバサイドでモデルを作ることにより履歴も追えてupdate_atから毎月のポイント付与もできる
      @subscription.payjp_id = new_subscription.id
      @subscription.save
      flash[:notice] = new_subscription.plan.name
    end

    # Pointテーブルについての処理
    @point.reason = 1
    @point.user_id = current_user.id
    @point.save
    # Userテーブルの保有ポイントカラムについての処理
    current_user.holding_point += @point.point
    current_user.is_member = '有料会員'
    current_user.save
    redirect_to user_path(current_user)
  end

  def new
  end

  private

  def subscription_params
    params.require(:subscription).permit(:id, :user_id, :payjp_id, :created_at, :updated_at)
  end

  def point_params
    params.require(:point).permit(:id, :user_id, :reason, :point, :created_at, :updated_at)
  end
end
