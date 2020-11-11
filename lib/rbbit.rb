require "rbbit/version"

require 'serialport'
require 'em-websocket'
require 'websocket-client-simple'
require 'json'

module Rbbit
  class Error < StandardError; end

  WS_PORT = 50215   # default WebSocket port

  #
  # WebSocket Server
  #
  class Agent
    def initialize(mb, ws_server)
      @mb = mb
      #
      ws_port = (ws_server == :default ? WS_PORT : ws_server)
      run_server(ws_port)
      @con = WebSocket::Client::Simple.connect "ws://127.0.0.1:#{ws_port}"
      @con.on :message do |msg|
        #puts msg.data
      end
      @con.on :open do
        @con.send('Hello')
      end
      @con.on :close do |e|
        p e
        exit 1
      end
    end

    def send_to_ws(data)
      @con.send(data)
    end

    private def send_to_mb(data)
      #p data
      if data["command"] == 'on'
        x = (data["arg1"] ? data["arg1"] : nil)
        y = (data["arg2"] ? data["arg2"] : nil)
        @mb.led_on(x, y)
      elsif data["command"] == 'off'
        x = (data["arg1"] ? data["arg1"] : nil)
        y = (data["arg2"] ? data["arg2"] : nil)
        @mb.led_off(x, y)
      elsif data["command"] == 'turn'
        x = data["arg1"]
        y = data["arg2"]
        @mb.led_turn(x, y)
      elsif data["command"] == 'show'
        pattern = data["arg1"]
        @mb.led_show(pattern)
      elsif data["command"] == 'puts'
        str = data["arg1"]
        @mb.led_puts(str)
      elsif data["command"] == 'play'
        freq = data["arg1"].to_sym
        beat = data["arg2"].to_f
        @mb.sound_play(freq, beat)   # ★引数の数やタイプ不一致の場合の例外処理 要
      elsif data["command"] == 'rest'
        beat = data["arg2"].to_f
        @mb.sound_rest(beat)         # ★引数の数やタイプ不一致の場合の例外処理 要
      elsif data["command"] == 'volume'
        v = data["arg1"].to_f
        @mb.sound_volume = v         # ★引数の数やタイプ不一致の場合の例外処理 要
      elsif data["command"] == 'tempo'
        bpm = data["arg1"].to_f
        @mb.sound_tempo = bpm        # ★引数の数やタイプ不一致の場合の例外処理 要
      end
    end

    private def run_server(ws_port)
      Thread.new do
        connections = Array.new
        EventMachine::WebSocket.start(host: "127.0.0.1", port: ws_port) do |ws|
          ws.onopen {
            # ws.send "Connected"
            connections.push(ws) unless connections.index(ws)
          }
          ws.onmessage { |msg|
            data = JSON.parse(msg) rescue nil
            if data
              if data.has_key?("command")
                #p data
                #p connections.size
                send_to_mb(data)
              else
                connections.each do |con|
                  con.send(msg)
                end
              end
            end
          }
          ws.onclose {
            puts "Close"
            connections.delete(ws) if connections.index(ws)
            exit if connections.size == 0
          }
        end
      end
    end
  end


  #
  # Class Library
  #
  class Microbit
    TONE = {
      C3:   131 ,  # do3
      Cs3:  139 ,  # do#3
      D3:   147 ,  # re3
      Ds3:  156 ,  # re#3
      E3:   165 ,  # mi3
      F3:   175 ,  # fa3
      Fs3:  185 ,  # fa#3
      G3:   196 ,  # so3
      Gs3:  208 ,  # so#3
      A3:   220 ,  # la3
      As3:  233 ,  # la#3
      B3:   247 ,  # ti3
      C4:   262 ,  # do4
      Cs4:  277 ,  # do#4
      D4:   294 ,  # re4 
      Ds4:  311 ,  # re#4
      E4:   330 ,  # mi4
      F4:   349 ,  # fa4
      Fs4:  370 ,  # fa#4
      G4:   392 ,  # so4
      Gs4:  415 ,  # so#4
      A4:   440 ,  # la4
      As4:  466 ,  # la#4
      B4:   494 ,  # ti4
      C5:   523 ,  # do5
      Cs5:  554 ,  # do#5
      D5:   587 ,  # re5
      Ds5:  622 ,  # re#5
      E5:   659 ,  # mi5
      F5:   698 ,  # fa5
      Fs5:  740 ,  # fa#5
      G5:   784 ,  # so5
      Gs5:  831 ,  # so#5
      A5:   880 ,  # la5
      As5:  932 ,  # la#5
      B5:   988 ,  # ti5
      C6:  1047 ,  # do6
    }
    WAIT = 0.05
    attr_reader :x, :y, :z, :p, :r, :l, :t

    def initialize(port = nil, ws_server = :default)
      @agent = Agent.new(self, ws_server) if ws_server
      @q     = Queue.new

      @x                    = nil
      @y                    = nil
      @z                    = nil
      @p                    = nil
      @r                    = nil
      @l                    = nil
      @t                    = nil
      @button_down          = {}
      @button_down_last     = {}
      @button_press         = {}
      @button_release       = {}
      @button_down[:a]      = nil
      @button_down[:b]      = nil
      @button_down_last[:a] = nil
      @button_down_last[:b] = nil
      @button_press[:a]     = nil
      @button_press[:b]     = nil
      @button_release[:a]   = nil
      @button_release[:b]   = nil

      @on_press_a           = nil
      @on_press_b           = nil
      @on_release_a         = nil
      @on_release_b         = nil

      @bpm                  = 120   # ウェイト調整のため、この値で明示的に初期化(initialize末尾)

      @continue_thread      = nil
      @continue_loop        = nil

      @port     = port || ENV['MB_PORT']
      baud_rate = 115200
      data_bits = 8
      stop_bits = 1
      parity    = 0

      @sp = SerialPort.open(@port, baud_rate, data_bits, stop_bits, parity)
      Kernel.sleep 0.5

      # -- for write
      @thread_w = Thread.new do
        loop do
          Thread.pass   # for other threads
          unless @q.empty?
            cmd = @q.pop
            if cmd.class == Array
              @sp.write cmd[0]; Kernel.sleep cmd[1]
            else
              @sp.write cmd
            end
          end
        end
      end

      # -- for read
      @thread_r = Thread.new do
        # Thread.pass
        @sp.read_timeout = 200
        @continue_thread = true
        loop do
          break unless @continue_thread
          Thread.pass   # for other threads
          begin
            value = @sp.readline.chomp.strip.split(',')
            # Kernel.p value
          rescue EOFError
            Kernel.sleep 0.1
            retry
          rescue ArgumentError
            # 回避：`strip': invalid byte sequence in UTF-8 (ArgumentError)
            #       `split': invalid byte sequence in UTF-8 (ArgumentError)
            Kernel.sleep 0.1
            retry
          end

          @x = value[0].to_i
          @y = value[1].to_i
          @z = value[2].to_i
          @p = value[3].to_i          # pitch
          @r = value[4].to_i          # roll
          @l = value[5].to_i          # light
          @t = value[6].to_i          # temp
          @button_down[:a] = (value[7] == "1" ? true : false)
          @button_down[:b] = (value[8] == "1" ? true : false)
          button_status
          event_proc
          if @agent
            senddata = JSON.generate({x: @x,
                                      y: @y,
                                      z: @z,
                                      p: @p,
                                      r: @r,
                                      l: @l,
                                      t: @t,
                                      a_down:    @button_down[:a],
                                      a_press:   @button_press[:a],
                                      a_release: @button_release[:a],
                                      b_down:    @button_down[:b],
                                      b_press:   @button_press[:b],
                                      b_release: @button_release[:b]})
            @agent.send_to_ws senddata
          end
        end
      end

      # -- init
      self.sound_tempo = @bpm
    end

    def mainloop(&block)
      @b = block           # ブロックを登録
      @continue_loop = true
      loop do
        break unless @continue_loop
        @b.call
        Kernel.sleep WAIT  # ブロック１回処理ごとにウェイト
      end
    end

    def on_press_a(&block)
      @on_press_a = block
    end

    def on_release_a(&block)
      @on_release_a = block
    end

    def on_press_b(&block)
      @on_press_b = block
    end

    def on_release_b(&block)
      @on_release_b = block
    end

    def break
      Kernel.sleep 0.5         # 調整...★
      @continue_loop = false
    end

    def close
      @continue_thread = false
      Kernel.sleep 1
      until @q.empty?       # wait for until command queue has been empty
        Kernel.sleep 0.5
        # Kernel.puts "sync #{@q.size}"
      end
      Kernel.sleep 0.5
      @thread_w.kill
      @thread_r.kill
      @sp.close
    end

    private def button_status
      @button_down.each_key do |k|
        change  = @button_down[k] ^ @button_down_last[k]        # Get change of mouse press status (XOR)
        press   = change &  @button_down[k]                     # Detect change to press from release
        release = change & !@button_down[k]                     # Detect change to release from press
        @button_press[k] = press                                # Set mouse_press status
        @button_release[k] = release                            # Set mouse_release status
        @button_down_last[k] = @button_down[k]
      end
    end

    def event_proc
      @on_press_a.call   if @on_press_a   and @button_press[:a]
      @on_press_b.call   if @on_press_b   and @button_press[:b]
      @on_release_a.call if @on_release_a and @button_release[:a]
      @on_release_b.call if @on_release_b and @button_release[:b]
    end

    def button_down?(k)
      @button_down[k]
    end

    def button_press?(k)
      status = @button_press[k]
      @button_press[k] = false if @button_press[k]              # avoid continuous judgment
      status
    end

    def button_release?(k)
      status = @button_release[k]
      @button_release[k] = false if @button_release[k]          # avoid continuous judgment
      status
    end

    def led_on(x = nil, y = nil)
      if (x == nil and y == nil)
        @q << ["LEDfil\n", WAIT]
      else
        @q << ["LEDon #{x}#{y}\n", WAIT]
      end
    end

    def led_off(x = nil, y = nil)
      if (x == nil and y == nil)
        @q << ["LEDclr\n", WAIT]
      else
        @q << ["LEDoff#{x}#{y}\n", WAIT]
      end
    end

    def led_turn(x, y)
      @q << ["LEDtrn#{x}#{y}\n", WAIT]
    end

    def led_puts(str)
      @q << ["LEDput#{str}\n", WAIT + str.length * 0.5]
    end

    def led_show(pattern)
      ptn = []
      5.times do |j|
        ptn[j] = 0
        5.times do |i|
          ptn[j] += (2 ** (4 - i)) unless pattern[j][i] == 0   # 5-digits to decimal
        end
      end
      #Kernel.p ptn
      @q << ["LEDshw%02d%02d%02d%02d%02d\n" % ptn, WAIT]
    end

    def sound_volume=(v)
      @q << ["SNDvol#{v}\n", WAIT]
    end

    def sound_tempo=(bpm)
      @q << ["SNDbpm#{bpm}\n", WAIT]
      @bpm = bpm
    end

    def sound_play(freq, beat)
      @q << ["SNDply%04d%s\n" % [TONE[freq], _beat(beat)], WAIT * 0 + 60.0 / @bpm * beat]   # ★ WAIT調整
    end

    def sound_rest(beat)
      @q << ["SNDrst%s\n" % [_beat(beat)], WAIT + 60.0 / @bpm * beat]
    end

    def reset
      @q << "RESET \n"
    end

    def wait(ms)
      @q << ["SLEEP %03d\n" % [ms], WAIT + ms / 1000.0]
    end

    def port
      @port
    end

    private def _beat(beat)
      if    beat >= 4.0      # Whole note
        return "4"
      elsif beat >= 2.0      # Half note
        return "2"
      elsif beat >= 1.0      # Quarter note
        return "1"
      elsif beat >= 0.5      # Eighth note
        return "/2"
      elsif beat >= 0.25     # Sixteenth note
        return "/4"
      elsif beat >= 0.125    # Thirty-second note
        return "/8"
      else                   # Sixty-fourth note
        return "/16"
      end
    end

    alias_method :on,       :led_on
    alias_method :off,      :led_off
    alias_method :turn,     :led_turn
    alias_method :show,     :led_show
    alias_method :puts,     :led_puts

    alias_method :play,     :sound_play
    alias_method :rest,     :sound_rest
    alias_method :volume=,  :sound_volume=
    alias_method :tempo=,   :sound_tempo=

    alias_method :down?,    :button_down?
    alias_method :release?, :button_release?
    alias_method :press?,   :button_press?

  end

end

