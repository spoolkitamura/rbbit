require 'rbbit.rb'

# タイマー

=begin
  ・数字がカウントダウンしていく(操作不要)
=end

mb = Rbbit::Microbit.new(ARGV[0])

mb.led_off
sleep 0.2

puts "Now, count down..."
(0..9).each do |i|
  mb.led_puts("#{9 - i}")
  sleep 1
end

sleep 0.5

mb.led_puts("OK!")
mb.close(5000)

