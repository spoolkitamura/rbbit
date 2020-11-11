require 'rbbit'

# ローテーション

=begin
  ・LEDの点灯位置がグルグル移動する(操作不要)
  ・最後にチェックマークを表示
=end

mb = Rbbit::Microbit.new

leds = [
         [1, 0], [2, 0], [3, 0],
         [4, 1], [4, 2], [4, 3],
         [3, 4], [2, 4], [1, 4],
         [0, 3], [0, 2], [0, 1]
       ]

pattern = [
            [0, 0, 0, 0, 0],
            [0, 0, 0, 0, 1],
            [0, 0, 0, 1, 0],
            [1, 0, 1, 0, 0],
            [0, 1, 0, 0, 0]
          ]

mb.led_off
sleep 0.2

leds.each do |p|
  mb.led_on(p[0], p[1])
  sleep 0.2    # ゆっくり
end

3.times do
  leds.each do |p|
    mb.led_turn(p[0], p[1])
  end
end

mb.wait(500)
mb.led_show(pattern)
mb.wait(2000)              # sleepとの差異...

mb.led_puts("OK!")
mb.close

