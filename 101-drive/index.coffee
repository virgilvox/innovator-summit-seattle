MeshbluSocketIO = require 'meshblu'
config = require './meshblu.json'
meshblu = new MeshbluSocketIO config
five = require 'johnny-five'
# board = new five.Board()
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
    )

  right = new (five.Motor)(
    pins:
      pwm: 5
      dir: 13
    )

  servo = new (five.Servo)(
    pin: 6
    startAt: 90
  )

  forward = (speed) =>
    left.reverse(speed)
    right.forward(speed)

  backward = (speed) =>
    left.forward(speed)
    right.reverse(speed)

  leftDir = (speed) =>
    # left.reverse(speed)
    right.forward(speed)

  rightDir = (speed) =>
    left.reverse(speed)
    # right.reverse(speed)

  stop = () =>
    left.stop()
    right.stop()

  meshblu.on 'message', (message) =>
    return if !message.payload?
    { command, speed } = message.payload

    forward(speed) if command == 'forward'
    backward(speed) if command == 'backward'
    leftDir(speed) if command == 'left'
    rightDir(speed) if command == 'right'
    stop() if command == 'stop'

    servo.to(speed) if command == "servo"
