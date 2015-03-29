// Fullcalendar デモ画面用メソッド

var flash_fadeout_timer_demo;
var dialog_close_timer;
var delete_info_timer;

function moveEventDemo(event){
  clearTimeout(flash_fadeout_timer_demo);
  clearTimeout(delete_info_timer);
  $('#flash_info').removeClass();
  $('#flash_info').addClass('alert alert-notice').html('Event moved!/予定を移動しました' );

  $('#flash_info').fadeIn("fast");
  flash_fadeout_timer_demo = setTimeout( function(){ $('#flash_info').fadeOut("slow"); }, '5000');

}

function resizeEventDemo(event){
  clearTimeout(flash_fadeout_timer_demo);
  clearTimeout(delete_info_timer);
  $('#flash_info').removeClass();
  $('#flash_info').addClass('alert alert-notice').html('Event resized!/終了時間を変更しました' );

  $('#flash_info').fadeIn("fast");
  flash_fadeout_timer_demo = setTimeout( function(){ $('#flash_info').fadeOut("slow"); }, '5000');

}

function showEventDetailsDemo(event){
  dayN = new Array('日','月','火','水','木','金','土');

  var myRe = /^[1-9]/;        //祝日か否か、の判断
  if (myRe.test(event.id)) {  //祝日ではない場合 
    
    var s = event.start;
    var e = event.end;

      var sm  = s.getMonth() + 1;
      var sd  = s.getDate();
      var sw  = "(" + dayN[s.getDay()] + ")";
      var sh  = s.getHours();
      var smi = ("0" + s.getMinutes()).slice(-2);  //2桁のゼロ埋め

      var em  = e.getMonth() + 1;
      var ed  = e.getDate();
      var ew  = "(" + dayN[e.getDay()] + ")";
      var eh  = e.getHours();
      var emi = ("0" + e.getMinutes()).slice(-2);  //2桁のゼロ埋め

    if ((event.allDay == true) && (sd == ed)){
      $('#event_info').html( sm + "/" + sd + sw + "<br/>" + "終日!!<br/>" +"メモ：  " + nl2br(event.description));
    }else if (event.allDay == true){
      $('#event_info').html( sm + "/" + sd + " " + sw + "～" + em + "/" + ed + ew + "<br/>" + "終日!!<br/>" +"メモ：  " + nl2br(event.description));
    }else if (sd == ed){
      $('#event_info').html(sm + "/" + sd + sw + " " + sh + ":" + smi + "～" + " " + eh + ":" + emi + "<br/>" + "メモ：  " + nl2br(event.description));
    }else{
      $('#event_info').html(sm + "/" + sd + sw + " " + sh + ":" + smi + "～" + em + "/" + ed + ew + " " + eh + ":" + emi + "<br/>" + "メモ：  " + nl2br(event.description));
    }

    //edit deleteがボタンの場合
    $('#edit_event').html("<input type='button' onclick ='editEventDemo()' id = 'edit_button' name = 'button' value = '編集' >");
    $('#delete_event').html("<input type='button' onclick ='deleteEventDemo("+event.id+")' id = 'delete_button' name = 'button' value = '削除' >");

/*  edit deleteがリンクの場合
    $('#edit_event').html("<a href = 'javascript:void(0);' onclick ='editEvent("+event.id+")'>編集</a>");
    $('#delete_event').html("<a href = 'javascript:void(0);' onclick ='deleteEvent("+event.id+")'>削除</a>");
*/

    $('#event_dialog').dialog({
        title: event.title,
        modal: true,
        position: {
                 of: '.fc-header',
                 my: "center top",
                 at: "center bottom"
                },
        width: 600,
        close: function(event, ui) {
                 $('#event_dialog').dialog('destroy');
                 event_dialog_reset();
               }
    });

  }else{      // 祝日の場合
    $('#event_dialog').dialog({
        title: event.title,
        modal: true,
        position: {
                 of: '.fc-header',
                 my: "center top",
                 at: "center bottom"
                },
        width: 300,
        height: 100,
        close: function(event, ui) { 
                 $('#event_dialog').dialog('destroy')
                 event_dialog_reset();
               }
    });
  }
}

function editEventDemo(){
    $('#edit_event').empty();  //まずeditボタンを消去
    $('#error_explanation_demo').addClass('alert alert-error').html('ユーザー登録、ログインしないと編集できません<br/>&emsp;7秒後にこのDialogは自動的に閉じます');

    dialog_close_timer = setTimeout( function(){
                          $('#event_dialog').dialog('destroy');
                          event_dialog_reset();
                        }, 7000);

    $('.ui-dialog-titlebar-close').click(function(){
      clearTimeout(dialog_close_timer);
    });
}

function deleteEventDemo(event_id){
    if (confirm('削除してもいいですか？')){
      $('#calendar_demo').fullCalendar("removeEvents", event_id);
      $('#event_dialog').dialog('destroy');
      event_dialog_reset();
      clearTimeout(dialog_close_timer);
      clearTimeout(flash_fadeout_timer_demo);
      clearTimeout(delete_info_timer);
      $('#flash_info').removeClass();
      $('#flash_info').addClass('alert alert-success').html('Event removed!/予定削除完了!' );
      $('#flash_info').fadeIn("fast");
      delete_info_timer = setTimeout( function(){ $('#flash_info').fadeOut("slow"); }, '5000');
    }
}

function create_eventDemo(start, end, allDay) {

    var demo;
    var data = {event: {start: start,
                        end: end, 
                        allday: allDay,
                       },
                demo: true  //デモ画面上での操作であることをRails側に伝える
               };
    $.ajax({
        data: data,
        dataType: 'script',
        type: "get",
        url: "/events/new",
    });
  $('#calendar_demo').fullCalendar('unselect');
}

function new_eventDemo() {
    $('#new_event_demo').click(function(){
      var date = new Date();  //今現在の時間を取得

      var start  = date;
      var end    = new Date(date.getTime()  + 60 * 30 * 1000);  //30分後の時間を取得
      var allDay = false;

      create_eventDemo(start, end, allDay);
    });
}

