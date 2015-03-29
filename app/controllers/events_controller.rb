# coding: utf-8
class EventsController < ApplicationController

  before_filter :signed_in_user, only: [:create, :destroy, :get_events]
  before_filter :correct_user,   only: [:destroy, :edit, :update, :move, :resize]
  before_filter :admin_user,     only: :db_cleanup

  def index
#    @@display_mode = 'my_events_only'
   @@display_mode = params[:display] || 'my_events_only'
    if signed_in?
      if current_user.admin?
        @information = Information.all
        @microposts = Micropost.all
      else  
        @information = Information.find(:all, limit: 6)
        @microposts = Micropost.find(:all, limit: 8)
      end
    else
     @information = Information.find(:all, limit: 6)
     @microposts = Micropost.find(:all, limit: 8)
    end
  end

  def get_events

    s = Time.at(params['start'].to_i).to_formatted_s(:db)
    e = Time.at(params['end'].to_i).to_formatted_s(:db)  

    if @@display_mode == 'my_events_and_public'
      @events = Event.find(
        :all,
        :conditions => ["(start_time >= ? and end_time <= ?) and (user_id = ? or public = ?)", s, e, current_user.id, true ]
       )
    elsif @@display_mode == 'public_only'
      @events = Event.find(
        :all,
        :conditions => ["(start_time >= ? and end_time <= ?) and  public = ?", s, e, true ]
       )
    else
      @events = Event.find(
        :all,
        :conditions => ["(start_time >= ? and end_time <= ?) and user_id = ? ", s, e, current_user.id ]
       )
    end

=begin #not in use 2014_01_ 24
    public_events = Event.find(
      :all,
      :conditions => ["(start_time >= ? and end_time <= ?) and public = ?", s, e, 'true' ]
     )

    current_user_has_this_event = true 
    public_events.each do |event|
      event.classname = "classname_green"
      user_name = User.find_by_id(event.user_id).name
      if event.user_id != current_user.id
        current_user_has_this_event = false
        event.editable = false
        event.title += " :#{user_name}さん公開スケジュール"
      else
        current_user_has_this_event = true
        event.editable = true
        event.title += " :#{user_name}公開スケジュール"
      end
    end

    @events += public_events
=end

    events = [] 
    @events.each do |event|

      current_user_has_this_event = true 
      user_name = User.find_by_id(event.user_id).name
      attachments = event.attachments

        attachments_info = []
        attachments.each do |a|
          attachments_info << { file_name: a.file_name,
                                mime_type: a.mime_type,
                                file_size: a.file_size,
                                file_id:   a.id
                               }
        end

        if event.public == true
          event.classname = "classname_green"
          if event.user_id != current_user.id
            event.editable = false
            current_user_has_this_event = false
            event.title += " :#{user_name}さん公開スケジュール"
          else
            event.editable = true
            current_user_has_this_event = true 
            event.title += " :#{user_name}公開スケジュール"
          end
        end

      events << {:id => event.id,
                 :title => event.title,
                 :description => event.description || "メモ...", 
                 :start => "#{event.start_time.iso8601}",
                 :end => "#{event.end_time.iso8601}", 
                 :allDay => event.allday,
                 :editable => event.editable,
                 :className => event.classname,
                 :public => event.public,
                 :user_id => event.user_id,
                 :current_user_has_this_event => current_user_has_this_event,
                 :attachments_info => attachments_info,
                }
    end
    render json: events
  end

  def show

=begin #not in use 2014_01_24
    @event = current_user.events.find_by_id(params[:id])

    dayN = %w{日 月 火 水 木 金 土}

    s = @event.start_time
    e = @event.end_time

    sm  = s.month.to_s
    sd  = s.day.to_s
    sw  = "(#{dayN[s.wday]})";
    sh  = s.hour.to_s
    smi = "%02d" % s.min.to_i  #2桁のゼロ埋め

    em  = e.month.to_s
    ed  = e.day.to_s
    ew  = "(#{dayN[e.wday]})";
    eh  = e.hour.to_s
    emi = "%02d" % e.min.to_i  #2桁のゼロ埋め

    if @event.allday == true and (sm == em and sd == ed)
      @time_info = sm + "/" + sd + sw  + "終日!!"
    elsif @event.allday == true
      @time_info = sm + "/" + sd + " " + sw + "～" + em + "/" + ed + ew + "終日!!"
    elsif sd == ed
      @time_info = sm + "/" + sd + sw + " " + sh + ":" + smi + "～"  + eh + ":" + emi
    else
      @time_info = sm + "/" + sd + sw + " " + sh + ":" + smi + "～" + em + "/" + ed + ew + " " + eh + ":" + emi
    end
=end

  end

  def new
    if signed_in? 
      @event = current_user.events.build
      @event.attachments.build
    else
      @event = Event.new
      @event.attachments.build
    end
    #条件によってstart_time,end_timeの初期値を設定
    if params[:event]
    #select_create(Demo時も含む)の場合
        pstime = DateTime.parse(params[:event][:start])
        petime = DateTime.parse(params[:event][:end])
        if params[:event][:allday] == 'true' && pstime.today? && petime.today?
          #当日の終日予定、
          @event.start_time = Time.now
          @event.end_time = pstime + 23.hours + 59.minutes 
        elsif params[:event][:allday] == 'true' && pstime.today?
          #当日から始まる終日予定
          @event.start_time = Time.now
          @event.end_time = pstime + 18.hours 
        elsif params[:event][:allday] == 'true' &&
              pstime.seconds_since_midnight == petime.seconds_since_midnight      #fullcalendarの終日予定は00:00～00:00が初期設定のため
          #当日以外の終日予定、当日以外から始まる終日予定
          @event.start_time = pstime + 9.hours
          @event.end_time = petime + 18.hours
        else
          @event.start_time = pstime 
          @event.end_time = petime  
        end
      @event.allday = params[:event][:allday]
    else  #新規作成ボタンを押下した場合
      @event.start_time = Time.now
      @event.end_time = @event.start_time + 30.minutes
    end

    #デモ画面の場合
    render 'events/views_for_demo/new_demo' if !signed_in?

  end

  def edit
    #@event = current_user.events.find_by_id(params[:id])
    @attachments = @event.attachments.all
  end

  def create 
    @event = current_user.events.build(params[:event])
    #添付ファイルの処理
    if params[:file]
      params[:file].each_value do |file|
        @event.attachments.build  file_content: file[0].read,
                                  file_name: file[0].original_filename,
                                  mime_type: file[0].content_type,
                                  file_size: file[0].size
#                                 pubic:     params[:file][:public][0]

        if file[0].size >1048576
          file_size = (file[0].size*100/1024.0/1024).floor/100.0
          file_name = file[0].original_filename
          @file_error_dialog = "添付ファイルは1MB以下でお願いします...\n #{file_name} は #{file_size} MBあります。" 
          render 'new' and return
        end
      end
    end
=begin
      if @event.save
        flash[:success] = "Event created! / スケジュール新規作成完了!" 
        render 'events/shared/close_event_dialog'
      else
        render 'new'
      end
    else
=end
      if @event.save
        flash[:success] = "Event created! / スケジュール新規作成完了!" 
        render 'events/shared/close_event_dialog'
      else
        render 'new'
      end
#    end
  end


  #デモ用のcreateメソッド
  def demo_create
      @info = '＊ユーザー登録、ログインしないと<br/>&emsp;&emsp;&emsp;スケジュール登録はできません<br/>&emsp;7秒後にこのDialogは自動的に閉じます'
      render 'events/views_for_demo/error_info_and_close_dialog'
  end
  
  def update
    @event = current_user.events.find_by_id(params[:event][:id])

    if params[:file]
      params[:file].each_value do |file|
        @event.attachments.build  file_content: file[0].read,
                                  file_name: file[0].original_filename,
                                  mime_type: file[0].content_type,
                                  file_size: file[0].size
#                                 pubic:     params[:file][:public][0]
        if file[0].size >1048576
          file_size = (file[0].size*100/1024.0/1024).floor/100.0
          file_name = file[0].original_filename
          @file_error_dialog = "添付ファイルは1MB以下でお願いします...\n #{file_name} は #{file_size} MBあります。" 
          render 'edit' and return
#        else
#          if @event.update_attributes(params[:event])
#            flash[:success] = "Event updated! / スケジュール更新完了!"
#            render 'events/shared/close_event_dialog'
#          else
#            render 'edit'
#          end
        end
      end
    end
#    else
      if @event.update_attributes(params[:event])
        flash[:success] = "Event updated! / スケジュール更新完了!"
        render 'events/shared/close_event_dialog'
      else
        render 'edit'
      end
#    end
  end

  def move
    @flag = 0
    #リサイズによってstart_timeとend_time共に23:59になった終日予定イベントを非終日予定エリアに移動した場合、
    #イベント時間が５分未満の終日イベントを非終日予定エリアに移動した場合、
    #イベント時間が５分未満の非終日予定イベントを移動した場合、イベント時間を30分に変更する。
    if (params[:event][:end_time].to_datetime).to_i - (params[:event][:start_time].to_datetime).to_i < 300 && params[:event][:allday] == "false"
      params[:event][:end_time] = params[:event][:start_time].to_datetime + 30.minutes
	    @flag = 1
    end
#    @event = current_user.events.find_by_id params[:event][:id]
    unless @event.update_attributes(params[:event])
      flash[:error] = "Sorry,Something went wrong! / エラー発生!予定は更新されませんでした"
      @flag = 1
    else
      flash.now[:notice] = "Event moved! / スケジュールを移動しました"
    end
    render 'events/shared/refetch_or'
  end

  def resize
    @flag = 0
    #限界値対策：start_timeが23:59で、複数日の終日予定を単日の終日予定にリサイズした場合
    #つまり、start_timeとend_time共に23:59になった場合、railsのメソッドでend_timeを23:59:59にする。
    #（表記は23:59のまま）
    if params[:event][:end_time] == "null"
      params[:event][:end_time] = params[:event][:start_time].to_datetime.end_of_day
	    @flag = 1
    end
#    @event = current_user.events.find_by_id params[:event][:id]
    unless @event.update_attributes(params[:event])
      flash[:error] = "Sorry,Something went wrong! / エラー発生!スケジュールは更新されませんでした"
      @flag = 1
    else
      flash.now[:notice] = "Event resized! / 終了時間を変更しました"
    end
    render 'events/shared/refetch_or'
  end

  def destroy
    @event.destroy
    flash[:success] = "Event removed! / スケジュール削除完了"
    render 'events/shared/close_event_dialog'
  end

  def db_cleanup
    Event.cleanup
    Micropost.cleanup
    flash[:success] = "Old Events deleted! /  3ヶ月以上前のイベント削除完了!"
    redirect_to users_path #, status: 303
  end

  private

    def correct_user
      event_id = params[:id] ||= params[:event][:id]
      @event = current_user.events.find_by_id(event_id)
      if @event.nil?
        flash[:error] = "You Can't / 自分のスケジュール以外は、編集、削除はできません"
        render 'events/shared/close_event_dialog' 
      end
    end

end
