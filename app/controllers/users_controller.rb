# coding: utf-8
class UsersController < ApplicationController

  before_filter :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :admin_user_or_current_user,     only: :destroy

  def index
    @users = User.page(params[:page]).per(5)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "#{@user.name}さん ユーザー登録完了!"
      render 'close_user_dialog'
    else
      render 'new'
    end
  end

  def edit

  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated / 更新完了!"
      sign_in @user
      render 'close_user_dialog'
    else
      render 'edit'
    end
  end

  def show
    @user = User.find(params[:id])

    if @user == current_user
      @events_in_future = @user.events.find(
        :all,
        :conditions => ["start_time > '#{Time.now.to_formatted_s(:db)}'"],
        :order => "start_time ASC"    
       )
      @events = Kaminari.paginate_array(@events_in_future).page(params[:page]).per(10)
      @events_in_progress = @user.events.find(
        :all,
        :conditions => ["start_time <= '#{Time.now.to_formatted_s(:db)}' and end_time > '#{Time.now.to_formatted_s(:db)}'"],
        :order => "end_time ASC"
       )
    else
      @events_in_future = @user.events.find(
        :all,
        :conditions => ["start_time > '#{Time.now.to_formatted_s(:db)}' and public = ?", true ],
        :order => "start_time ASC"    
       )
      @events = Kaminari.paginate_array(@events_in_future).page(params[:page]).per(10)
      @events_in_progress = @user.events.find(
        :all,
        :conditions => ["start_time <= '#{Time.now.to_formatted_s(:db)}' and end_time > '#{Time.now.to_formatted_s(:db)}' and public = ?", true ],
        :order => "end_time ASC"
       )
    end

  end

  def destroy
    user = User.find(params[:id]).destroy
    flash[:success] = "Goodbye! / #{ user.name } さんの登録を削除しました"

    if current_user.admin?
      render 'reload_user_index_page'
    else
      render 'close_user_dialog'
    end

  end

  private

    def correct_user
      @user = User.find(params[:id])
      redirect_to root_path unless current_user?(@user)
    end

    def admin_user_or_current_user
      @user = User.find(params[:id])
      if !current_user.admin? and !current_user?(@user) 
        flash[:error] = "You Can't / 自分以外のユーザー登録の削除はできません"
        render 'close_user_dialog'
      end
    end

end
