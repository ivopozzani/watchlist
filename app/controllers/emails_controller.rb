# frozen_string_literal: true

class EmailsController < ApplicationController
  before_action :authenticate_user!

  def index
    UserMailer.with(user: current_user).wallet_email.deliver_later

    redirect_to root_path
  end
end
