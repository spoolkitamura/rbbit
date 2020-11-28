require 'rbbit.rb'

# さいころ２

=begin
  ・micro:bitを適当に揺さぶると 1～6の目が表示される
  ・[B]ボタンで終了
=end

mb = Rbbit::Microbit.new(ARGV[0])

mb.led_off

pattern = []
pattern << [
            [0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0],
            [0, 0, 1, 0, 0],
            [0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0]
           ]
pattern << [
            [0, 0, 0, 0, 0],
            [0, 1, 0, 0, 0],
            [0, 0, 0, 0, 0],
            [0, 0, 0, 1, 0],
            [0, 0, 0, 0, 0]
           ]
pattern << [
            [0, 0, 0, 0, 1],
            [0, 0, 0, 0, 0],
            [0, 0, 1, 0, 0],
            [0, 0, 0, 0, 0],
            [1, 0, 0, 0, 0]
           ]
pattern << [
            [0, 0, 0, 0, 0],
            [0, 1, 0, 1, 0],
            [0, 0, 0, 0, 0],
            [0, 1, 0, 1, 0],
            [0, 0, 0, 0, 0]
           ]
pattern << [
            [1, 0, 0, 0, 1],
            [0, 0, 0, 0, 0],
            [0, 0, 1, 0, 0],
            [0, 0, 0, 0, 0],
            [1, 0, 0, 0, 1]
           ]
pattern << [
            [0, 0, 0, 0, 0],
            [1, 0, 1, 0, 1],
            [0, 0, 0, 0, 0],
            [1, 0, 1, 0, 1],
            [0, 0, 0, 0, 0]
           ]

mb.on_release_b do
  mb.break
end

x0 = 0
y0 = 0

puts "Please shake the micro:bit\n(press 'button-B' to exit)"
mb.mainloop do
  x, y = mb.x, mb.y
  next unless x or y
  # puts "#{x} #{y}"
  if (x - x0) > 512 or
     (y - y0) > 512
    # puts "#{x} #{y}   #{x0} #{y0}   #{x - x0}  #{y - y0}"
    dice = [1, 2, 3, 4, 5, 6].sample
    mb.led_show(pattern[dice - 1])
    x0, y0 = x, y
  end
  sleep 0.2
end

mb.puts("OK!")
mb.close(5000)

