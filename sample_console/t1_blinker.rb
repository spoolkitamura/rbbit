require 'rbbit.rb'

# 点滅

=begin
  ・LEDが 2パターン交互に 10回点滅(操作不要)
=end

pattern1 = [
             [1, 1, 1, 1, 1],
             [1, 0, 0, 0, 1],
             [1, 0, 1, 0, 1],
             [1, 0, 0, 0, 1],
             [1, 1, 1, 1, 1]
           ]

pattern2 = [
             [0, 0, 0, 0, 0],
             [0, 1, 1, 1, 0],
             [0, 1, 0, 1, 0],
             [0, 1, 1, 1, 0],
             [0, 0, 0, 0, 0]
           ]

mb = Rbbit::Microbit.new(ARGV[0])

mb.led_off
sleep 0.2

10.times do
  mb.led_show(pattern1)
  sleep 0.5
  mb.led_show(pattern2)
  sleep 0.5
end

mb.led_puts("OK!")
mb.close(5000)

