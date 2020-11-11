require 'rbbit.rb'

# 点滅

=begin
  ・中央の LEDが５回点滅(操作不要)
=end

mb = Rbbit::Microbit.new

10.times do
  mb.led_turn(2, 2)
  sleep 0.5
end

mb.led_puts("OK!")
mb.close

