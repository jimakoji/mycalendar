/* MyFullCalendar javascript*/

  $(document).ready(function(){
      $('#calendar').fullCalendar({
          editable: true,
          ignoreTimezone: false,
          header: {
              left: 'prev,next today',
              center: 'title',
              right: 'month,agendaWeek,agendaDay'
          },

          loading: function(bool){
              if (bool) 
                  $('#loading').show();
              else 
                  $('#loading').hide();
          },

          events: "/events/get_events",
/*
          eventSources: [   "/events/get_events",//?display_mode=" + disp,
                          {
                            url: 'https://www.google.com/calendar/feeds/ja.japanese%23holiday%40group.v.calendar.google.com/public/full/',
                            color: 'pink',
                            success:function(events){
                              $(events).each(function(){
                                this.url = null;
                              });
                            },
                          }
                        ],
*/

//**セレクトして新規作成
          selectable: true,
          selectHelper: true,
          select: function(start, end, allDay){
                  create_event(start, end, allDay);
          },

          eventDrop: function(event, dayDelta, minuteDelta, allDay, revertFunc){
                  moveEvent(event, dayDelta, minuteDelta, allDay);
          },
          
          eventResize: function(event, dayDelta, minuteDelta, revertFunc){
                  resizeEvent(event, dayDelta, minuteDelta);
          },
          
          eventClick: function(event, jsEvent, view){
              showEventDetails(event);
          },

//**デザインフォーマット
//          eventColor: 'royalblue',
          defaultView: 'month',
          height: 700,
          aspectRatio: 1.35,
          slotMinutes: 30,
          dragOpacity: "0.5",
          allDayText: '終日',
          // スクロール開始時間
//          firstHour: 9,
          // 表示最小時間
          minTime: 6,
          // 表示最大時間 
          maxTime: 22,
          header: {
            left: 'prev next today',
            center: 'title',
            right: 'month agendaWeek agendaDay',
          },

          titleFormat: {
              month: 'yyyy年 M月',
              week: '[yyyy年 ]M月 d日{ &#8212;[yyyy年 ][ M月] d日}',
              day: 'yyyy年 M月 d日 dddd'
          },
          columnFormat: {
              month: 'ddd',
              week: 'M/d（ddd）',
              day: 'M/d（ddd）'
          },

          timeFormat: { // for event elements
              '': 'H:mm - ',
          agenda: 'H:mm { - H:mm}'
          },

          axisFormat: 'H:mm',

//** 日本語翻訳      
          dayNames: ['日曜日','月曜日','火曜日','水曜日','木曜日','金曜日','土曜日'],
          dayNamesShort: ['日','月','火','水','木','金','土'],

          buttonText: {
               prev: '&nbsp;&#9668;&nbsp;',
               next: '&nbsp;&#9658;&nbsp;',
               prevYear: '&nbsp;&lt;&lt;&nbsp;',
               nextYear: '&nbsp;&gt;&gt;&nbsp;',
               today: '今日',
               month: '月',
               week: '週',
               day: '日'
          }

      });
    new_event();  //新規作成ボタン押下の時
    dt_ac_menu();
  });
