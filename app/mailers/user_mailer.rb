# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def wallet_email
    @user = params[:user]
    @wallet_items = WalletItem.includes(asset: :last_quote).where(wallet_id: @user.wallet.id)
    mail(to: @user.email, subject: 'List of assets being monitored')
  end
end
