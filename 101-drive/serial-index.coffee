MeshbluSocketIO = require 'meshblu'
config = require './meshblu.json'
meshblu = new MeshbluSocketIO config
SerialPort = require 'serialport'
port = new SerialPort '/dev/ttyACM0'


meshblu.connect()
meshblu.on 'ready', =>
  console.log 'Connected'

port.on 'open', =>

  returnLine = '\r\n'

  forward = (speed) =>
    data = 'f ' + speed + returnLine
    write(data)

  backward = (speed) =>
    data = 'b ' + speed + returnLine
    write(data)

  leftDir = (speed) =>
    data = 'l ' + speed + returnLine
    write(data)

  rightDir = (speed) =>
    data = 'r ' + speed + returnLine
    write(data)

  stop = () =>
    data = 's' + returnLine
    write(data)

  servo = (angle) =>
    data = 'servo ' + angle + returnLine
    write(data)

  shoot = () =>
    data = 't' + returnLine
    write(data)

  write = (data) =>
    port.write data, (err) =>
      if err
        return console.log('Error on write: ', err.message)
      console.log 'message written', data

  meshblu.on 'message', (message) =>
    return if !message.payload?
    { command, speed } = message.payload

    forward(speed) if command == 'forward'
    backward(speed) if command == 'backward'
    leftDir(speed) if command == 'left'
    rightDir(speed) if command == 'right'
    stop() if command == 'stop'
    shoot() if command == 'shoot'

    servo speed if command == "servo"
