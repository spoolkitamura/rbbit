require 'rbbit.rb'

# ドラゴン・クエストのテーマ曲

=begin
  ・自動再生(操作不要)
=end

mb = Rbbit::Microbit.new

mb.sound_tempo = 150
mb.sound_volume = 48

mb.sound_play(:G4,  0.5)
mb.sound_play(:G4,  0.25)
mb.sound_play(:G4,  0.25)
mb.sound_play(:C5,  1.0)
mb.sound_play(:D5,  1.0)
mb.sound_play(:E5,  1.0)
mb.sound_play(:F5,  1.0)
mb.sound_play(:G5,  1.0)
mb.sound_play(:C6,  2.0)

mb.sound_play(:B5,  0.5)
mb.sound_play(:B5,  0.25)
mb.sound_play(:A5,  0.25)
mb.sound_play(:A5,  1.0)
mb.sound_play(:A5,  0.5)
mb.sound_play(:G5,  0.5)
mb.sound_rest(      0.5)
mb.sound_play(:Fs5, 0.5)
mb.sound_play(:Fs5, 0.5)
mb.sound_play(:A5,  0.5)
mb.sound_play(:G5,  0.5)
mb.sound_rest(      0.5)
mb.sound_play(:E5,  2.0)

mb.sound_play(:E4,  0.5)
mb.sound_play(:E4,  0.25)
mb.sound_play(:E4,  0.25)
mb.sound_play(:E4,  1.0)
mb.sound_play(:E4,  1.0)
mb.sound_play(:Fs4, 1.0)
mb.sound_play(:Gs4, 1.0)
mb.sound_play(:A4,  2.0)
mb.sound_rest(      0.5)

mb.sound_play(:A4,  0.5)
mb.sound_play(:B4,  0.5)
mb.sound_play(:C5,  0.5)
mb.sound_play(:D5,  2.0)
mb.sound_rest(      0.5)

mb.sound_play(:A4,  0.5)
mb.sound_play(:A4,  0.5)
mb.sound_play(:C5,  0.5)
mb.sound_play(:C5,  1.0)
mb.sound_play(:B4,  1.0)
mb.sound_play(:A4,  1.0)
mb.sound_play(:G4,  1.0)

mb.sound_play(:E5,  2.0)
mb.sound_play(:E5,  0.5)
mb.sound_play(:F5,  0.5)
mb.sound_play(:E5,  0.5)
mb.sound_play(:D5,  0.5)
mb.sound_play(:C5,  2.0)
mb.sound_play(:A4,  1.0)

mb.sound_play(:C5,  1.0)
mb.sound_play(:D5,  2.0)
mb.sound_play(:D5,  0.5)
mb.sound_play(:E5,  0.5)
mb.sound_play(:D5,  0.5)
mb.sound_play(:C5,  0.5)
mb.sound_play(:C5,  2.0)
mb.sound_play(:B4,  1.0)

mb.sound_play(:G4,  1.0)
mb.sound_play(:G5,  2.0)
mb.sound_play(:G5,  0.5)
mb.sound_play(:E5,  0.5)
mb.sound_play(:F5,  0.5)
mb.sound_play(:G5,  0.5)
mb.sound_play(:A5,  2.0)

mb.sound_play(:A5,  0.5)
mb.sound_play(:A4,  0.5)
mb.sound_play(:B4,  0.5)
mb.sound_play(:C5,  0.5)
mb.sound_play(:F5,  2.0)
mb.sound_play(:E5,  2.0)
mb.sound_play(:C5,  2.0)
mb.sound_rest(      1.0)

mb.puts("OK!")
mb.close(5000)

