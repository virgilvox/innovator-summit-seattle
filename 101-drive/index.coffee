MeshbluSocketIO = require 'meshblu'
config = require './meshblu.json'
meshblu = new MeshbluSocketIO config
five = require 'johnny-five'
BLESerialPort = require('ble-serial').SerialPort
Firmata = require('firmata').Board
board = new five.Board {
  io: new Firmata(new BLESerialPort({}))
}

meshblu.connect()
meshblu.on 'ready', =>
  console.log 'Connected'

board.on 'ready', =>
  left = new (five.Motor)(
    pins:
      pwm: 3
      dir: 12
    invertPWM: true)

  right = new (five.Motor)(
    pins:
      pwm: 11
      dir: 13
    invertPWM: true)

  forward = (speed) =>
    left.forward(speend)
    right.forward(speed)

  backward = (speed) =>
    left.reverse(speed)
    right.reverse(speed)

  left = (speed) =>
    left.reverse(speed)
    right.forward(speed)

  right = (speed) =>
    left.forward(speed)
    right.reverse(speed)

  stop = () =>
    left.stop()
    right.stop()

  meshblu.on 'message', =>
    return if !message.payload?
    { command, speed } = message.payload

    forward(speed) if command == 'forward'
    backward(speed) if command == 'backward'
    left(speed) if command == 'left'
    right(speed) if command == 'right'
    stop() if command == 'stop'
