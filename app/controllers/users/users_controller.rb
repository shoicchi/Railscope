# frozen_string_literal: true

class Users::UsersController < ApplicationController
  def top; end

  def show
    @user = User.find(params[:id])
    @notes = Note.where(user_id: @user).page(params[:page]).reverse_order
    # NOTE: current_userがsubscriptionテーブルを保持しているかどうか（定期課金申し込み済みかどうかの判断）
    # HACK: modelで処理できそう
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
    if @user.update(user_params)
      # NOTE: 無料会員から有料会員へ変更すると月額料金申し込みページへ遷移
      if @user.is_member == '有料会員' && Subscription.where(user_id: @user.id).empty?
        # HACK: 現状は遷移先で種別を選んだらis_member == '有料会員'にしてsave
        # TODO: 遷移先で「まだ有料会員に変更処理は終わっていません」等の表示による対応＋プラン選択後に正常に処理が終わった旨通知等
        @user.is_member = '無料会員'
        @user.update(user_params)
        flash[:notice] = '編集しました。有料会員なので、プランを選んでください。'
        redirect_to subscriptions_path
        # NOTE: 有料会員から無料会員に変更すると定期課金情報削除
      elsif @user.is_member == '無料会員' && Subscription.where(user_id: @user.id).exists?
        Payjp.api_key = ENV['PAYJP_SECRET']
        del_subscription = Payjp::Subscription.retrieve(current_user.subscription.payjp_id)
        del_subscription.delete
        @user.subscription.delete
        flash[:notice] = '編集しました。無料会員に変更したので申し込み中のプランを削除しました。'
        redirect_to user_path(@user)
      else
        flash[:notice] = '編集しました。'
        redirect_to user_path(@user)
      end
    else
      flash[:notice] = '編集に失敗しました。やり直してください。'
      redirect_to edit_user_path(@user)
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :profile, :grade, :provider, :uid, :e_mail, :encrypted_password, :is_member, :holding_point, :is_delivery, :payjp_id, :phone_number, :is_deleted)
  end
end
