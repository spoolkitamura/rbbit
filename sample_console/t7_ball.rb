require 'rbbit.rb'

# 玉ころがし

=begin
  ・micro:bitを前後左右に傾けると、ボール(LED１つ)が移動
  ・[B]ボタンで終了
=end

mb = Rbbit::Microbit.new

mb.on_press_b do
  mb.puts("OK!")
  mb.break
  mb.close
end

mb.led_off
sleep 0.2

i0, j0  = nil, nil
i,  j   = 2, 2
pitches = []
rolls   = []
mb.mainloop do
  pitch = mb.p                # pitch(前後)
  roll  = mb.r                # roll (左右)
  next unless pitch or roll   # pitch, rollのいずれかが有効値でない場合はループ先頭に戻る

  if i != i0 or j != j0
    #puts "(#{i0}, #{j0}) -> (#{i}, #{j0})"
    mb.led_off(i0, j0)
    mb.led_on(i, j)
  end

  # 配列を使用して 5件ごとに値をサンプリング(連続値での判断だと玉の動きが一方的)
  pitches << pitch
  rolls   << roll
  pitches.clear if pitches.size > 5
  rolls.clear   if rolls.size   > 5
  ave_pitch = (pitches.size == 1 ? pitches[0] : 0)
  ave_roll  = (rolls.size   == 1 ? rolls[0]   : 0)

  #puts "#{ave_pitch} #{ave_roll} #{pitches.size} #{rolls.size}"

  i0 = i                          # 前の値を保持
  j0 = j                          # 前の値を保持
  if ave_roll > 15                # 傾き(左右)が +15度を超えた場合
    i += 1
    i = 4 if i >= 4
  elsif ave_roll < -15            # 傾き(左右)が -15度を超えた場合
    i -= 1
    i = 0 if i <= 0
  end

  if ave_pitch > 15               # 傾き(前後)が +15度を超えた場合
    j += 1
    j = 4 if j >= 4
  elsif ave_pitch < -15           # 傾き(前後)が -15度を超えた場合
    j -= 1
    j = 0 if j <= 0
  end

  #sleep 0.1                       # 適当なウェイト...
end

