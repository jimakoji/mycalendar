# coding: utf-8
class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by_email(params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      sign_in user
      flash[:success] = "#{user.name}さんがログインしました"
      render 'sessions/close_user_dialog'
#      redirect_back_or_render 'sessions/close_user_dialog'
    else
      flash.now[:error] = 'E_mailとパスワードの組み合わせが違います。<br/>あるいは未入力です。'
      render 'new'
    end
  end

  def destroy
    flash[:success] = "#{current_user.name}さんログアウトしました"
    sign_out
    redirect_to root_url
  end

end
