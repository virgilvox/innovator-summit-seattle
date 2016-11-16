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

  meshblu.on 'message', =>
    return if !message.data?
    { command, motor } = message.data

    left[command] if motor == 'left'
    right[command] if motor == 'right'
