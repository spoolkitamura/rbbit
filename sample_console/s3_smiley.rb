require 'rbbit.rb'

# スマイリー

=begin
  ・[A]ボタン押下で笑顔
  ・[B]ボタン押下で渋面
  ・[A]+[B]ボタン押下で〇
  ・15秒間で自動的に終了
=end


mb = Rbbit::Microbit.new

pattern_a = [
             [1, 1, 0, 1, 1],
             [1, 1, 0, 1, 1],
             [0, 0, 0, 0, 0],
             [1, 0, 0, 0, 1],
             [0, 1, 1, 1, 0]
            ]

pattern_b = [
             [1, 1, 0, 1, 1],
             [1, 1, 0, 1, 1],
             [0, 0, 0, 0, 0],
             [0, 1, 1, 1, 0],
             [1, 0, 0, 0, 1]
            ]

pattern_s = [
             [0, 1, 1, 1, 0],
             [1, 0, 0, 0, 1],
             [1, 0, 0, 0, 1],
             [1, 0, 0, 0, 1],
             [0, 1, 1, 1, 0]
            ]

mb.led_off

mb.on_press_a do
  if mb.button_down?(:b)
    mb.led_show(pattern_s)
  else
    mb.led_show(pattern_a)
  end
end

mb.on_press_b do
  if mb.button_down?(:a)
    mb.led_show(pattern_s)
  else
    mb.led_show(pattern_b)
  end
end

sleep 15

mb.led_off
mb.led_puts("OK!")
mb.close(5000)

