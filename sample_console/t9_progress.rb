require 'rbbit.rb'

# プログレスバー

=begin
  ・[A]ボタンでバーが伸長
  ・[B]ボタンでバーが収縮
  ・[A]+[B]同時押下で終了
=end

mb = Rbbit::Microbit.new

pattern = [
           [
            [0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0],
           ],
           [
            [0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0],
            [1, 1, 1, 1, 1],
           ],
           [
            [0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0],
            [1, 1, 1, 1, 1],
            [1, 1, 1, 1, 1],
           ],
           [
            [0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0],
            [1, 1, 1, 1, 1],
            [1, 1, 1, 1, 1],
            [1, 1, 1, 1, 1],
           ],
           [
            [0, 0, 0, 0, 0],
            [1, 1, 1, 1, 1],
            [1, 1, 1, 1, 1],
            [1, 1, 1, 1, 1],
            [1, 1, 1, 1, 1],
           ],
           [
            [1, 1, 1, 1, 1],
            [1, 1, 1, 1, 1],
            [1, 1, 1, 1, 1],
            [1, 1, 1, 1, 1],
            [1, 1, 1, 1, 1],
           ]
          ]

def finish(mb)
  mb.puts("OK!")
  mb.break
  mb.close
end

level = 0

mb.on_press_a do
  if mb.button_down?(:b)
    finish(mb)
  else
    level += 1 if level < 5
    mb.led_show(pattern[level])
  end
end

mb.on_press_b do
  if mb.button_down?(:a)
    finish(mb)
  else
    level -= 1 if level > 0
    mb.led_show(pattern[level])
  end
end

mb.led_off
mb.mainloop {}

