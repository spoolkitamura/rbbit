require 'rbbit.rb'

# 名札

=begin
  ・名前を表示(操作不要)
=end

mb = Rbbit::Microbit.new(ARGV[0])

mb.led_puts("rbbit")
mb.led_off

mb.led_puts("OK!")
mb.close(10000)

