# rbbit (rb:-:bit)

'rbbit' is a Class library and WebSocket server to use 'micro:bit' written by Ruby.

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
And then, drag and drop 'rbbit/microbit/microbit-rbbit_20201107.hex' to the micro:bit.  

### [PC]

To specify  the port name (MB_PORT),  
find out the serial-port connected the micro:bit like as.  

**Windows**

    > chgport

Find a description like `COM5` = \ Devices \ thcdcacm0.  

**macOS**

    $ ls -l /dev/tty.*  

Find a device like `/dev/tty.usbmodem1421`.  

**Linux**

    $ $ls -l /dev/serial/by-id/

Find a device like `/dev/ttyACM0`.  


## Usage

### [for Class library]
```ruby
require 'rbbit'
```

### [for WebSocket server]

    $ rbbit MB_PORT

       or

    $ set MB_PORT=COM5                       (Windows)
    $ export MB_PORT=/dev/tty.usbmodem1421   (macOS)
    $ export MB_PORT=/dev/ttyACM0            (Linux)

    $ rbbit


## Documents

https://github.com/spoolkitamura/rbbit/wiki  

## Samples

https://github.com/spoolkitamura/rbbit/tree/main/sample_console  
https://github.com/spoolkitamura/rbbit/tree/main/sample_web  

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

