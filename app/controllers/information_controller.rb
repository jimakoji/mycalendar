# coding: utf-8
class InformationController < ApplicationController

  before_filter :admin_user_for_information, except: :index

  def index

  end

  def show
    @information = Information.find(params[:id])
  end

  def new
    @information = Information.new
  end

  # GET /information/1/edit
  def edit
    @information = Information.find(params[:id])
  end

  def create
    @information = Information.new(params[:information])
      if @information.save
        flash[:success] = "Information created! / お知らせ新規作成完了!"
        render 'close_admin_info_dialog'
      else
        render 'new'
      end

  end

  # PUT /information/1
  # PUT /information/1.json
  def update
    @information = Information.find(params[:id])
      if @information.update_attributes(params[:information])
        flash[:success] = "Information updated! / お知らせ更新完了!"
        render 'close_admin_info_dialog'
      else
        render 'edit'
      end
  end

  def destroy
    @information = Information.find(params[:id])
    @information.destroy
    flash[:success] = "Information removed! / お知らせ削除完了"
    redirect_to root_path
  end

  private

    def admin_user_for_information
      if signed_in?
        unless current_user.admin?
          flash[:error] = "You Can't / 管理者以外、お知らせの作成、編集、削除はできません"
          redirect_to root_path
        end
      else
        flash[:error] = "You Can't / 管理者以外、お知らせの作成、編集、削はできません"
        redirect_to root_path 
      end
    end

end
