# rbbit (rb:-:bit)

'rbbit' is a Class library and WebSocket server to use 'micro:bit'.

## Requirements

serialport ~> 1.3  
em-websocket ~> 0.5  
websocket-client-simple ~> 0.3  

## Installation

Install it yourself as:

    $ gem install rbbit

If you are using Windows, type following in addition to it:

    $ gem uninstall eventmachine
    $ gem   install eventmachine --platform ruby

## Settings

### [micro:bit]

Connect the micro:bit to your PC with USB cable.  
Then, save following file and drop to the micro:bit.  

[microbit-rbbit_20201127_v1.5.hex](microbit/microbit-rbbit_20201127_v1.5.hex)    (for micro:bit v1.5)  
[microbit-rbbit_20201127_v2.0.hex](microbit/microbit-rbbit_20201127_v2.0.hex)    (for micro:bit v2.0)  

### [PC]

To specify  the port name (MB_PORT),  
find out the serial-port connected the micro:bit like as.  

**Windows**

    [windows] + [x] to open Device Manager

Find a description like 'mbed Serial Port (`COM5`)'.  

**macOS**

    $ ls -l /dev/tty.*  

Find a device like `/dev/tty.usbmodem14132`.  

**Linux**

    $ $ls -l /dev/serial/by-id/

Find a device like `/dev/ttyACM1`.  


## Usage

### [as Class library]
```ruby
require 'rbbit'

mb = Rbbit:Microbit.new("COM5")          # or "/dev/tty.usbmodem14132", "/dev/ttyACM1"
mb.led_on
mb.close(1000)
```

### [as WebSocket server]

    $ rbbit COM5                             (Windows)
    $ rbbit /dev/tty.usbmodem14132           (macOS)
    $ rbbit /dev/ttyACM1                     (Linux)

or

    $ set MB_PORT=COM5                       (Windows)
    $ export MB_PORT=/dev/tty.usbmodem14132  (macOS)
    $ export MB_PORT=/dev/ttyACM1            (Linux)

    $ rbbit


## Documents

https://spoolkitamura.github.io/rbbit/index.html

## Samples

https://spoolkitamura.github.io/rbbit/sample_web.html  
https://spoolkitamura.github.io/rbbit/sample_console.html  

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

