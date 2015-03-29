class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper

  #for debug
  $ev1 = nil
  $ev2 = nil

  # CSRF脆弱性の対策のために、サインアウトさせる。
  def handle_unverified_request
    sign_out
    super
  end

end
