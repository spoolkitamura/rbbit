require 'rbbit.rb'

# 光量計

=begin
  ・明るさによって LEDが 0～25個の範囲で点灯
  ・[B]ボタンで終了
=end

mb = Rbbit::Microbit.new

mb.on_press_b do
  mb.break
end

mb.led_off
sleep 0.2

mb.mainloop do
  light = mb.l
  next unless light   # lightが有効値でない場合はループ先頭に戻る

  level = (light * 25.0 / 255.0).to_i

  i = level / 5       # 商
  j = level % 5       # 剰余

  pattern = []
  line = []
  5.times do |count|
    if count < j
      line << 1
    else
      line << 0
    end
  end
  5.times do |count|
    if count < i
      pattern << [1, 1, 1, 1, 1]
    elsif count == i
      pattern << line
    else
      pattern << [0, 0, 0, 0, 0]
    end
  end

  # puts "#{light} #{level} #{i} #{j}"

  mb.led_show(pattern)    # 明るさのレベルに応じて LEDが点灯
  sleep 0.2               # 適当なウェイトが必要...
end

mb.puts("OK!")
mb.close(5000)

