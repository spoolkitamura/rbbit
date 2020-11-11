require 'rbbit.rb'

# 名札

=begin
  ・名前を表示(操作不要)
=end

mb = Rbbit::Microbit.new

mb.led_puts("I'm rbbit.")
mb.led_off

mb.led_puts("OK!")
mb.close

