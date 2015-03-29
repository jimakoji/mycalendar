# coding: utf-8
class AttachmentsController < ApplicationController
  def index
  end

  def show
    @attachment = Attachment.find(params[:id])
    @viewer_grid = params[:viewer_grid]
  end

  def serve
    @attachment = Attachment.find(params[:id])
    send_data(@attachment.file_content, 
              :type => @attachment.mime_type,
              :filename => "#{@attachment.file_name}",
              :disposition => 'inline'
              )
  end

  def download_file
    @attachment = Attachment.find(params[:id])
    send_data(@attachment.file_content, 
              :type => @attachment.mime_type,
              :filename => "#{@attachment.file_name}",
              :disposition => "attachment"
              )
  end

  def destroy
    @attachment = Attachment.find(params[:id])
    @attachment.destroy

    flash[:success] = "Attachment removed! / 添付ファイル削除完了"
    render 'reload_event_edit_page'
  end

end
