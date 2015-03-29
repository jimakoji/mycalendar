
// Fullcalendar用メソッド

function moveEvent(event){
    var data = {event: {id: event.id,
                        start_time: event.start,
                        end_time: event.end, 
                        allday: event.allDay}};
    $.ajax({
        data: data,
        dataType: 'script',
        type: 'post',
        url: "/events/move"
    });
}

function resizeEvent(event){
    var data = {event: {id: event.id,
                        end_time: event.end}}; 
    $.ajax({
        data: data,
        dataType: 'script',
        type: 'post',
        url: "/events/resize"
    });
}

function showEventDetails(event){

  dayN = new Array('日','月','火','水','木','金','土');

  var myRe = /^[1-9]/;        //祝日か否か、の判定
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

    if ((event.allDay == true) && (sm == em && sd == ed)){
      $('#event_info').html( sm + "/" + sd + sw + "<br/>"
                             + "終日!!<br/>"
                             +"メモ： " + nl2br(event.description));
    }else if (event.allDay == true){
      $('#event_info').html( sm + "/" + sd + " " + sw + "～" + em + "/" + ed + ew + "<br/>"
                             + "終日!!<br/>"
                             +"メモ：" + nl2br(event.description));
    }else if (sd == ed){
      $('#event_info').html( sm + "/" + sd + sw + " " + sh + ":" + smi + "～" + eh + ":" + emi + "<br/>"
                             + "メモ：" + nl2br(event.description));
    }else{
      $('#event_info').html( sm + "/" + sd + sw + " " + sh + ":" + smi + "～"
                             + em + "/" + ed + ew + " " + eh + ":" + emi + "<br/>"
                             + "メモ：" + nl2br(event.description));
    }

    $('#event_info').append('<hr/>');

    var a_info = event.attachments_info;
    for (var i=0; i<a_info.length; i++) {
      $('#event_info').append('<span>添付ファイル' + (i+1) + ' : ' + a_info[i].file_name + '</span>');
      $('#event_info').append('<input type = "button" onclick = "download_attachment('
                                 + a_info[i].file_id + ')" value = "ダウンロード">');
      if (a_info[i].mime_type.match(/image\/(x-|p)?(jpe?g|png|gif)/)) {
        $('#event_info').append('<form class="button_to" method="get" data-remote="true" action="/attachments/'
                                + a_info[i].file_id + '?viewer_grid=' + i +
                                '"><input id="view_toggle' + i + '" type="submit" value="表示する"></form>');
        $('#event_info').append('<span id = "viewer_' + i + '" style = "display: none;"></span>');
      }else if (a_info[i].mime_type=='application/pdf' || a_info[i].mime_type=='text/plain' ){
        $('#event_info').append('<div><input type = "button" onclick = "popup_pdf_txt('
                                 + a_info[i].file_id + ')" value = "内容を確認する"></div>');
      }
    $('#event_info').append('<hr/>');
    }

    viewer_toggle();

    if (event.current_user_has_this_event == true ) {
    //edit deleteがボタンの場合
    $('#edit_event').html("<input type='button' onclick ='editEvent("
                           +event.id+
                           ")' id = 'edit_button' name = 'button' value = '編集' >");
    $('#delete_event').html("<input type='button' onclick ='deleteEvent("
                             +event.id+
                             ")' id = 'delete_button' name = 'button' value = '削除' >");
    /*edit deleteがリンクの場合
    $('#edit_event').html("<a href = 'javascript:void(0);' onclick ='editEvent("+event.id+")'>編集</a>");
    $('#delete_event').html("<a href = 'javascript:void(0);' onclick ='deleteEvent("+event.id+")'>削除</a>");
    */
    }

    $('#event_dialog').dialog({
        title: event.title,
        modal: true,
        position: {
                 of: '.fc-header',
                 my: "center top",
                 at: "center bottom"
                },
        width: 660,
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
                 $('#event_dialog').dialog('destroy');
               }
    });
  }
}

function editEvent(event_id){
    $('#edit_event').empty();
    $('#delete_event').empty();
    $.ajax({
        data: 'id=' + event_id,
        dataType: 'script',
        type: 'get',
        url: "/events/" + event_id + "/edit"
    });  
}

function deleteEvent(event_id){
  if (confirm('You sure? / 削除します')){
    $.ajax({
        data: 'id=' + event_id,
        dataType: 'script',
        type: 'delete',
        url: "/events/" + event_id 
    });
  }
}

function create_event(start, end, allDay) {
    var data = {event: {start: start,
                        end: end, 
                        allday: allDay}};
    $.ajax({
        data: data,
        dataType: 'script',
        type: "get",
        url: "/events/new",
    });
  $('#calendar').fullCalendar('unselect');
}

function new_event() {
    $('#new_event_create').click(function(){
      //var date = new Date();

      var start;//  = date;
      var end;//    = new Date(date.getTime()  + 60 * 30 * 1000);
      var allDay;// = false;

      create_event(start, end, allDay);
    });
}

/* 改行処理 */
function nl2br(str) {
    return str.replace(/\r\n?/g, "<br />");
}

/* event dialog reset */
function event_dialog_reset() {
    $('#event_info').empty();
    $('#edit_event').empty();
    $('#delete_event').empty();
    $('#error_explanation_demo').removeClass().empty();
    $('#attachment_info').removeClass().empty();}

/* user dialog reset */
function user_dialog_reset() {
    $('#user_info').empty();
    $('#flash_for_user_dialog').removeClass().empty();
}

/* admin_info dialog reset */
function admin_info_dialog_reset() {
    $('#admin_info').empty();
    $('#flash_for_admin_info_dialog').removeClass().empty();
}

/* micropost dialog reset */
function micropost_dialog_reset() {
    $('#micropost').empty();
    $('#flash_for_micropost_dialog').removeClass().empty();
}

/* accordion_menu */
function dt_ac_menu(){
    $("dt").on("click", function() {
        $(this).next().slideToggle('fast');
    });
}

function viewer_toggle(){
/*
    for (var i=0; i<n; i++) {
        $('#view_toggle'+ i).on("click", function() {
          if ($('#view_toggle'+ i).val() == '表示する') {
            var button_name = '非表示にする';
          }else{
            button_name = '表示する';
          }
          $(this).val( button_name );
          $('#viewer_'+ i).toggle();
        });
    }
*/
        $("#view_toggle0").on("click", function() {
          if ($("#view_toggle0").val() == '表示する') {
            var button_name = '非表示にする';
          }else{
            button_name = '表示する';
          }
          $(this).val( button_name );
          $('#viewer_0').toggle();
        });
        $("#view_toggle1").on("click", function() {
          if ($("#view_toggle1").val() == '表示する') {
            var button_name = '非表示にする';
          }else{
            button_name = '表示する';
          }
          $(this).val( button_name );
          $('#viewer_1').toggle();
        });
        $("#view_toggle2").on("click", function() {
          if ($("#view_toggle2").val() == '表示する') {
            var button_name = '非表示にする';
          }else{
            button_name = '表示する';
          }
          $(this).val( button_name );
          $('#viewer_2').toggle();
        });
    }

function popup_pdf_txt(n){
          window.open('/attachments/' + n + '/serve',"WindowName","width=600,height=500,resizable=yes,scrollbars=yes");
          return false;
    }

function download_attachment(n){
          location.href='/download_file?id=' + n;
    }
