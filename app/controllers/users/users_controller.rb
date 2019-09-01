# frozen_string_literal: true

class Users::UsersController < ApplicationController
  def top; end

  def show
    @user = User.find(params[:id])
    @notes = Note.where(user_id: @user).page(params[:page]).reverse_order
    # current_userがsubscriptionテーブルを保持しているかどうか（定期課金申し込み済みかどうかの判断）
    if @user == current_user && Subscription.where(user_id: current_user.id).exists?
      Payjp.api_key = ENV['PAYJP_SECRET']
      @subscription = Payjp::Subscription.retrieve(current_user.subscription.payjp_id)
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    flash[:notice] = if @user.update(user_params)
                       '編集しました。'
                     else
                       '編集に失敗しました。やり直してください。'
                     end

    # 無料会員から有料会員へ変更するとsaveの前に月額料金申し込みページへ遷移(遷移先のupdateでis_memberのsave)
    if @user.is_member == '有料会員' && Subscription.where(user_id: @user.id).empty?
      redirect_to subscriptions_path

    elsif @user.is_member == '無料会員' && Subscription.where(user_id: @user.id).exists?
      Payjp.api_key = ENV['PAYJP_SECRET']
      del_subscription = Payjp::Subscription.retrieve(current_user.subscription.payjp_id)
      del_subscription.delete
      @user.subscription.delete
      redirect_to user_path(@user)
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :profile, :grade, :provider, :uid, :e_mail, :encrypted_password, :is_member, :holding_point, :is_delivery, :payjp_id, :phone_number, :is_deleted)
  end
end
