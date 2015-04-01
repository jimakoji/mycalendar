/* MyFullCalendarDemo javascript*/

  //+++ダミーデータ用 date object の生成

		var date = new Date();
    var min = date.getMinutes();
    var h = date.getHours();
		var d = date.getDate();
		var m = date.getMonth();
		var y = date.getFullYear();

  $(document).ready(function(){
      // page is now ready, initialize the calendar...
      $('#calendar_demo').fullCalendar({
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

          eventSources: [
                          {
                            events: [
                              				{
                                        id: 1,
                              					title: '終日予定',
                                        description: 'This is All Day Event',
	                              				start: new Date(y, m, 1, h, min),
	                              				end: new Date(y, m, 1, (h+8), min ),
                                        allDay: true
	                              			},
	                              			{
                                        id: 2,
	                              				title: '長期間の予定',
                                        description: 'This is Long Event',
	                              				start: new Date(y, m, d-5),
	                              				end: new Date(y, m, d-2),
                                        allDay: true,
                                        className: 'classname_red'
	                              			},
                              				{
	                              				id: 999,
	                              				title: '毎週の予定',
                                        description: 'This is Repeating Event',
	                              				start: new Date(y, m, d-3, 16, 0),
	                              				end: new Date(y, m, d-3, 17, 30),
	                              				allDay: false,
                                        className: 'classname_yellow'
	                              			},
	                              			{
	                              				id: 999,
                              					title: '毎週の予定',
                                        description: 'This is Repeating Event',
	                              				start: new Date(y, m, d+4, 16, 0),
	                              				end: new Date(y, m, d+4, 17, 30),
	                              				allDay: false,
                                        className: 'classname_yellow'
	                              			},
                              				{
                              					id: 999,
                              					title: '毎週の予定',
                                        description: 'This is　Repeating Event',
	                              				start: new Date(y, m, d+11, 16, 0),
	                              				end: new Date(y, m, d+11, 17, 30),
	                              				allDay: false,
                                        className: 'classname_yellow'
	                              			},
	                              			{
	                              				id: 999,
	                              				title: '毎週の予定',
                                        description: 'This is Repeating Event',
	                              				start: new Date(y, m, d+18, 16, 0),
	                              				end: new Date(y, m, d+18, 17, 30),
	                              				allDay: false,
                                        className: 'classname_yellow'
	                              			},
	                              			{
	                              				id: 999,
	                              				title: '毎週の予定',
                                        description: 'This is Repeating Event',
	                              				start: new Date(y, m, d+25, 16, 0),
	                              				end: new Date(y, m, d+25, 17, 30),
	                              				allDay: false,
                                        className: 'classname_yellow'
	                              			},
	                              			{
                                        id: 3,
	                              				title: '会議 : 公開スケジュール',
                                        description: 'This is Meeting',
	                              				start: new Date(y, m, d, 10, 30),
                                        end: new Date(y, m, d, 11, 30),
	                              				allDay: false,
                                        className: 'classname_green'
	                              			},
	                              			{
                                        id: 4,
	                              				title: '昼食',
                                        description: 'This is Lunch',
	                              				start: new Date(y, m, d, 12, 0),
	                              				end: new Date(y, m, d, 13, 0),
	                              				allDay: false,
                                        className: 'classname_blue'
	                              			},
	                              			{
                                        id: 5,
	                              				title: '誕生日 : 公開スケジュール',
                                        description: 'おめでとう！',
	                              				start: new Date(y, m, d+1, 19, 0),
	                              				end: new Date(y, m, d+1, 22, 30),
	                              				allDay: false,
                                        className: 'classname_green'
	                              			},
	                              			{
                                        id: 6,
	                              				title: 'Click for SBC Radio',
	                              				start: new Date(y, m, 28),
	                              				end: new Date(y, m, 29),
	                              				allDay: true,
	                              				url: 'http://sbc21.co.jp/blogwp/radio/'
	                              			}
	                              		],
                           },

                          {
                           googleCalendarApiKey: "AIzaSyC7pAdTUBehmWbddDLJZsGtO4zN7FaZAQc",
                           googleCalendarId: "ja.japanese#holiday@group.v.calendar.google.com",
                           color: 'HotPink',


/*                           url: 'https://www.google.com/calendar/feeds/ja.japanese%23holiday%40group.v.calendar.google.com/public/full/',
                            color: 'pink',
                            success:function(events){
                              $(events).each(function(){
                                this.url = null;
                              });
                            }
*/ 
                          }                         
                        ],

//**セレクトして新規作成
          selectable: true,
          selectHelper: true,
          select: function(start, end, allDay){
                  create_eventDemo(start, end, allDay);
          },

          eventDrop: function(event, dayDelta, minuteDelta, allDay){
                  moveEventDemo(event, dayDelta, minuteDelta, allDay);
          },
          
          eventResize: function(event, dayDelta, minuteDelta){
                  resizeEventDemo(event, dayDelta, minuteDelta);
          },
          
          eventClick: function(event, jsEvent, view){
              showEventDetailsDemo(event);
          },

//**デザインフォーマット
//          eventColor: 'royalblue',
          defaultView: 'month',
          height: '560',
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
    new_eventDemo();  //新規作成ボタン使用の時
  });
