require 'rbbit.rb'

# 点滅するハート

=begin
  ・ハートマークが 5回点滅(操作不要)
=end

mb = Rbbit::Microbit.new(ARGV[0])

pattern = [
            [0, 1, 0, 1, 0],
            [1, 1, 1, 1, 1],
            [1, 1, 1, 1, 1],
            [0, 1, 1, 1, 0],
            [0, 0, 1, 0, 0]
          ]

5.times do
  mb.led_show(pattern)
  sleep 0.5
  mb.led_off
  sleep 0.5
end

mb.led_puts("OK!")
mb.close(5000)

