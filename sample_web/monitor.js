
// チャート１設定
let chart = $('#myChart1').epoch({
  type: 'time.line',                         //グラフの種類
  data: [
          { values: [], range: [-2048, 2048] },
          { values: [], range: [-2048, 2048] },
          { values: [], range: [-2048, 2048] }
        ],
  axes: ['bottom', 'left', 'right'],         //利用軸の選択
  range: {                                   //軸の範囲
           left: [-2048, 2048]
         },
  ticks: {time: 10, left: 5},                // 目盛りの設定(間隔秒数、目盛り数)
  tickFormats: {                             // 目盛りの書式
                 bottom: function (d) { return moment(d * 1000).format('HH:mm:ss'); },
                 left:   function (d) { return (d).toFixed(0); },
                 right:  function (d) { return ''; }
               },
  margins: {left: 60},
  fps: 24,                                   // フレームレート
  queueSize: 1,                              // キューサイズ(push時にキューからあふれたデータは破棄される)
  windowSize: 20                             // 表示データ件数
});

// チャート２設定
let chart2 = $('#myChart2').epoch({
  type: 'time.line',                         //グラフの種類
  data:  [
           { values: [], range: [-180, 180] },
           { values: [], range: [-180, 180] }
         ],
  axes:  ['left', 'right'],                  //利用軸の選択
  range: {                                   //軸の範囲
           left: [-180, 180]
         },
  ticks: {time: 10, left: 3},                // 目盛りの設定(間隔秒数、目盛り数)
  tickFormats: {                             // 目盛りの書式
                 left: function (d) {
                   return (d).toFixed(0) + "°";
                 },
                 right: function (d) { return ''; }
               },
  margins: {left: 60},
  fps: 24,                                   // フレームレート
  queueSize:   1,                            // キューサイズ(push時にキューからあふれたデータは破棄される)
  windowSize: 20                             // 表示データ件数
});

// チャート３設定
let chart3 = $('#myChart3').epoch({
  type: 'time.line',                         //グラフの種類
  data: [
          { values: [], range: [-20.5, 60.5] },
          { values: [], range: [0, 255] }
        ],
  axes: ['left', 'right'],                   //利用軸の選択
  range: {                                   //軸の範囲
           left: [-20.5, 60.5],
           right: [0, 255]
         },
  margins: {left: 60},
  ticks: {time: 5, right: 3, left: 3},       // 目盛りの設定(間隔秒数、目盛り数)
  tickFormats: {                             // 目盛りの書式
                 left: function (d) {
                   return (d).toFixed(0) + "℃";
                 },
                 right: function (d) {
                   return (d).toFixed(0);
                 }
               },
  fps: 24,                                   // フレームレート
  queueSize: 1,                              // キューサイズ(push時にキューからあふれたデータは破棄される)
  windowSize: 20                             // 表示データ件数
});

// チャート４設定
let chart4 = $('#myChart4').epoch({
  type: 'time.line',                         // グラフの種類
  data: [
          { values: [], range: [-1.05, 1.05] },
          { values: [], range: [-1.05, 1.05] }
        ],
  axes: ['left', 'right'],                   // 利用軸の選択
  range: {                                   // 軸の範囲
           left: [-1.05, 1.05],
           right: [0, 100]
         },
  margins: {left: 60},
  ticks: {time: 10, left: 3},                // 目盛りの設定(間隔秒数、目盛り数)
  tickFormats: {                             // 目盛りの書式
                 left:  function (d) { return (d == 0 ? '' : d > 0 ? "Up" : "Down"); },
                 right: function (d) { return ''; }
               },
  fps: 24,                                   // フレームレート
  queueSize: 1,                              // キューサイズ(push時にキューからあふれたデータは破棄される)
  windowSize: 20                             // 表示データ件数
});


// データ更新
$(function() {
  ws = new WebSocket("ws://127.0.0.1:50215");
  ws.onmessage = (evt) => {
//    console.log(evt.data);
    let data = JSON.parse(evt.data);         // ###
    let x = data.x
    let y = data.y
    let z = data.z
    let p = data.p
    let r = data.r
    let t = data.t
    let l = data.l
    let a = (data.a_down ? -1 : 1)
    let b = (data.b_down ? -1 : 1)

    chart.push(
      [
        {time: Date.now() / 1000, y: x },
        {time: Date.now() / 1000, y: y },
        {time: Date.now() / 1000, y: z },
      ],
    );
    chart2.push(
      [
        {time: Date.now() / 1000, y: p },
        {time: Date.now() / 1000, y: r },
      ],
    );
    chart3.push(
      [
        {time: Date.now() / 1000, y: t },
        {time: Date.now() / 1000, y: l },
      ],
    );
    chart4.push(
      [
        {time: Date.now() / 1000, y: a,},
        {time: Date.now() / 1000, y: b,},
      ],
    );
  };

  ws.onclose = () => {
    console.log("Disconnected from server")
  };

  ws.onopen = () => {
    ws.send("Connected to server");
  };
});

