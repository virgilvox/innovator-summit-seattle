#include <Servo.h>
#include <SerialCommand.h>

// https://github.com/kroimon/Arduino-SerialCommand

int MotR = 5;
int MotL = 3;
int DirR = 13;
int DirL = 12;
int ServoPos=90;
Servo myservo;
SerialCommand sCmd;

void setup() {
  myservo.attach(6);
  Serial.begin(9600);
  pinMode(MotR, OUTPUT);
  pinMode(MotL, OUTPUT);
  pinMode(DirL, OUTPUT);
  pinMode(DirR, OUTPUT);

  sCmd.addCommand("f", Forward);
  sCmd.addCommand("b", Backward);
  sCmd.addCommand("l", Left);
  sCmd.addCommand("r", Right);
  sCmd.addCommand("s", Stop);
  sCmd.addCommand("servo", ServoDir);
  Serial.println("Ready");
}

void loop()
{
  sCmd.readSerial();
}


void Forward() {
  int number;
  char *arg;

  arg = sCmd.next();
  number = atoi(arg);

  analogWrite(MotR, number);
  analogWrite(MotL, number);
  digitalWrite(DirL, LOW);
  digitalWrite(DirR, HIGH);

}

void Backward() {
  int number;
  char *arg;

  arg = sCmd.next();
  number = atoi(arg);

  analogWrite(MotR, number);
  analogWrite(MotL, number);
  digitalWrite(DirL, HIGH);
  digitalWrite(DirR, LOW);

}

void Left() {
  int number;
  char *arg;

  arg = sCmd.next();
  number = atoi(arg);

  analogWrite(MotR, number);
  analogWrite(MotL, 0);
  digitalWrite(DirR, HIGH);

}

void Right() {
  int number;
  char *arg;

  arg = sCmd.next();
  number = atoi(arg);

  analogWrite(MotR, 0);
  analogWrite(MotL, number);
  digitalWrite(DirL, LOW);

}

void ServoDir() {
  int number;
  char *arg;

  arg = sCmd.next();
  number = atoi(arg);

  myservo.write(number);

}

void Stop() {
  analogWrite(MotR, 0);
  analogWrite(MotL, 0);
}
