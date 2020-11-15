require 'rbbit.rb'

# アルファベット

=begin
  ・[A]ボタンを押すたびにアルファベットが１文字ずつランダムに表示される
  ・[B]ボタンで終了
=end

mb = Rbbit::Microbit.new

mb.led_off
sleep 0.2

mb.on_press_a do
  mb.led_puts((rand(0...26) + 65).chr)
end

mb.on_press_b do
  mb.break
end

puts "Please press 'button-A'  (press 'button-B' to exit)"
mb.mainloop {}

mb.led_puts("OK!")
mb.close(5000)

