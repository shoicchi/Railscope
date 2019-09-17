# frozen_string_literal: true

class Users::PointsController < ApplicationController
  def index
    @points = Point.where(user_id: current_user.id).page(params[:page]).reverse_order
  end

  def new
    @point = Point.new
  end

  def create
    @point = Point.new(point_params)
    @amount = 0
    # NOTE: 以下の条件分岐でpointによる支払い金額を設定、支払いの選択肢追加するときはelseifを増やせば対応できる
    if @point.point == 100
      @amount = 100
    elsif @point.point == 220
      @amount = 200
    elsif @point.point == 360
      @amount = 300
    else
      flash[:notice] = '正常に処理が行われませんでした。もう一度やり直してください。'
      redirect_to points_path
    end
    # NOTE: userがカード登録済みでない場合、登録画面へ飛ばす
    if current_user.payjp_id.nil?
      flash[:notice] = 'カードを登録してください'
      redirect_to new_subscription_path
    # NOTE: userがカード登録済みであれば正常に処理する
    else
      Payjp.api_key = ENV['PAYJP_SECRET']
      charge = Payjp::Charge.create(
        # NOTE: 先の条件分岐によって設定された金額をpayjpに渡す
        amount: @amount,
        # NOTE: 顧客情報をもとに支払いを行う
        customer: current_user.payjp_id,
        currency: 'jpy'
      )
      @point.reason = 2
      @point.user_id = current_user.id
      @point.save
      current_user.holding_point += @point.point
      current_user.save
      redirect_to points_path
    end
  end

  private

  def point_params
    params.require(:point).permit(:user_id, :reason, :point)
  end
end
