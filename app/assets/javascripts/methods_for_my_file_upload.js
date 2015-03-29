/* Methods for my upload files on event create and edit forms */

  /* エラー表示用タグ等を変数に格納 */
  var e_counter = 0;
  var e_tag1   = '<div id="error_explanation_js"></div>';
  var e_tag2   = '<div class = "field_with_errors">';
  var e_tag3   = '<ul>'
  var e_msg1_1 = '<div class="alert alert-error"> ';
  var e_msg1_2 = 'つのお願い...</div>';
  var e_msg2   = '<li class = "for_js_check">＊件名を入力してください。</li>';
  var e_msg3   = '<li class = "for_js_check">＊終了時間が開始時間より早くなっているか、同じです。<br/>&emsp;正しい時間を入力してください。</li>';
  /* ブラウザ情報を取得 */
  var userAgent  = window.navigator.userAgent.toLowerCase();
  var appVersion = window.navigator.appVersion.toLowerCase();

  function check_browser_and_submit() {
    /*エラー表示領域リセット*/
    if ($('#error_explanation_js')!=null) { $('#error_explanation_js').remove(); }
    if ($('#error_explanation')!=null) { $('#error_explanation').remove(); }
    /*開始時間と終了時間の取得*/
    get_start_end_time();
    /*件名未入力かつ開始時間が終了時間より遅い場合*/
    if ($('#event_title').val() == '' && start_time >= end_time) {
      e_counter = 2;
      $('#title_label').before(e_tag1);
      $('#error_explanation_js').prepend(e_msg1_1 + e_counter + e_msg1_2).append(e_msg2).append(e_msg3);

      $('li.for_js_check').wrapAll(e_tag3);
      $('#title_label').addClass('field_with_errors');
      $('#title_input').addClass('field_with_errors');
      $('#start_end_time_form').addClass('field_with_errors');
    /*件名未入力のみの場合*/
    }else if ($('#event_title').val() == '') {
      $('#start_end_time_form').removeClass('field_with_errors');
      e_counter = 1;
      $('#title_label').before(e_tag1);
      $('#error_explanation_js').prepend(e_msg1_1 + e_counter + e_msg1_2).append(e_msg2);

      $('li.for_js_check').wrapAll(e_tag3);
      $('#title_label').addClass('field_with_errors');
      $('#title_input').addClass('field_with_errors');
    /*開始時間が終了時間より遅い場合*/
    }else if(start_time >= end_time) {
      $('#title_label').removeClass('field_with_errors');
      $('#title_input').removeClass('field_with_errors');
      e_counter = 1;
      $('#title_label').before(e_tag1);
      $('#error_explanation_js').prepend(e_msg1_1 + e_counter + e_msg1_2).append(e_msg3);
      $('li.for_js_check').wrapAll(e_tag3);
      $('#start_end_time_form').addClass('field_with_errors');
    /*入力チェック*/
    }else{
      /*エラー表示領域リセット*/
      if ($('#error_explanation_js')!=null) { $('#error_explanation_js').remove(); }

      /*ie9lowerチェック*/
      if (userAgent.indexOf('msie') != -1 &&
         (appVersion.indexOf("msie 7.") != -1 ||
          appVersion.indexOf("msie 8.") != -1 ||
          appVersion.indexOf("msie 9.") != -1)) { 
            $('#new_event').submit();
            $('.edit_event').submit();
            $('#submit_btn').attr('value', "処理中...").attr('disabled', true);
            $('#spinner, #uploading_text, .link').toggle();
      }else{ /*ie9lower以外のブラウザで添付ファイルの有無をチェック*/
             if($("#fileupload0").prop('files').length > 0 ||
                $("#fileupload1").prop('files').length > 0 ||
                $("#fileupload2").prop('files').length > 0 )
             {
//             $('#fileupload').fileupload(); /* 使用方法要確認 */
               $('#submit_btn').attr('value', "処理中...").attr('disabled', true);
               $('#spinner, #uploading_text, .link').toggle();
             }
         $('#new_event').submit();
         $('.edit_event').submit();
      }
    }
  }

  /*添付ファイルのサイズチェックと表示処理*/
  function check_files(n) {
    if (userAgent.indexOf('msie') == -1 &&
       (appVersion.indexOf("msie 7.") == -1 ||
        appVersion.indexOf("msie 8.") == -1 ||
        appVersion.indexOf("msie 9.") == -1)) { 
    var file_data = $('#fileupload' + n ).prop('files');

    if ( file_data[0].size > 1048576) {
      var file_size_mb = Math.floor(file_data[0].size*100/1024/1024)/100;
      alert('添付ファイルは1MB以下でお願いします。\n'
             + file_data[0].name + ' は ' + file_size_mb + 'MBあります。');
      $('#fileupload' + n ).val('');
    }else{
      var file_size_kb = Math.floor(file_data[0].size*100/1024)/100;
      var f = file_data[0];
      $('#disp_' + n + ' span' ).empty();
      $('#disp_' + n + ' span' ).replaceWith("<span>ファイルタイプ : " + f.type + " サイズ: " + file_size_kb + " KB </span>");
    }
  }
  }  

  /*開始時間と終了時間の入力値を取得*/
  function get_start_end_time() {

    var start = [];
    var end   = [];

    for(var i=0; i<5; i++){
      start[i] = $('#event_start_time_' + (i+1) + 'i').val();
      end[i]   = $('#event_end_time_' + (i+1) + 'i').val();
    }
    start_time = new Date(start[0], start[1]-1, start[2],start[3], start[4]);
    end_time   = new Date(end[0], end[1]-1, end[2], end[3], end[4]);
  }

