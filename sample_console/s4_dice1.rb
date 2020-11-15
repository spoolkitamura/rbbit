require 'rbbit.rb'

# さいころ１

=begin
  ・micro:bitを適当に揺さぶると 1～6の数字が表示される
  ・[B]ボタンで終了
=end

mb = Rbbit::Microbit.new

mb.led_off

mb.on_release_b do
  mb.break
end

x0 = 0
y0 = 0
mb.mainloop do
  x, y = mb.x, mb.y
  next unless x or y
  # puts "#{x} #{y}"
  if (x - x0) > 512 or
     (y - y0) > 512
    # puts "#{x} #{y}   #{x0} #{y0}   #{x - x0}  #{y - y0}"
    dice = [1, 2, 3, 4, 5, 6].sample.to_s
    mb.led_puts(dice)
    x0, y0 = x, y
  end
  sleep 0.2
end

mb.puts("OK!")
mb.close(5000)

