# coding: utf-8
class MicropostsController < ApplicationController
  before_filter :signed_in_user, only: [:new, :create, :destroy]
  before_filter :correct_user,   only: :destroy

  def index
    
  end

  def new
    @micropost = current_user.microposts.build
  end

  def create
    @micropost = current_user.microposts.build(params[:micropost])
    if @micropost.save
      flash[:success] = "Posted! / 投稿完了!"
      render 'close_micropost_dialog'
    else
      render 'new'
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = "Your post destroyed! / 投稿コメント削除完了!"
    redirect_to root_url
  end

  private

    def correct_user
#      @micropost = current_user.microposts.find_by_id(params[:id])
      @micropost = Micropost.find_by_id(params[:id])
      if @micropost.user_id != current_user.id and !current_user.admin?
        flash[:error] = "自分以外の投稿コメントは削除できません"
        redirect_to root_url
      end 
    end

end