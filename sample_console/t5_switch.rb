require 'rbbit.rb'

# LEDスイッチ

=begin
  ・[A]ボタン押下中は LEDが点灯
  ・[A]ボタンを離すと LEDが消灯
  ・[B]ボタンで終了
=end

mb = Rbbit::Microbit.new

mb.led_off
sleep 0.2

mb.on_press_a do
  mb.led_on
end

mb.on_release_a do
  mb.led_off
end

mb.on_press_b do
  mb.led_puts("OK!")
  mb.break
  mb.close
end

puts "Please press 'button-A'  (press 'button-B' to exit)"
mb.mainloop {}

