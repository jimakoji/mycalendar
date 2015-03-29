# coding: utf-8
module SessionsHelper

  def sign_in(user)
    cookies.permanent[:remember_token] = user.remember_token
    self.current_user = user
  end

  def signed_in?
    !current_user.nil?
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= User.find_by_remember_token(cookies[:remember_token])
  end

  def current_user?(user)
    user == current_user
  end

  def signed_in_user
    unless signed_in?
      store_location
      flash[:error] = "Please sign in! / ログインしてください"
      redirect_to signin_path
    end
  end

  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end

  def admin_user
    unless current_user.admin?
      flash[:error] = "You Can't / 管理者以外、ユーザー、OldEvents の削除はできません"
      render 'users/close_user_dialog'
    end
  end


#  def redirect_back_or(default)
#    redirect_to(session[:return_to] || default)
#    session.delete(:return_to)
#  end

  def redirect_back_or_render(default)
    if session[:return_to]
      redirect_to(session[:return_to])
    else
      render default
    end
    clear_return_to
  end

  def store_location
    session[:return_to] = request.url
  end

  private

    def clear_return_to
      session.delete(:return_to)
    end

end
