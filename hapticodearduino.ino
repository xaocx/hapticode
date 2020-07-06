int motor = 3;
int pwm = 0;
int pwm1 = 0;
int val = 0;
//char val;
boolean estado0 = false;
boolean estado1 = false;
boolean estado2 = false;


void setup() {
  //  Serial.begin(57600);
  Serial.begin(9600);
  pinMode(motor, OUTPUT);
}

void loop() {
  if (Serial.available()  > 0) {//Si el Arduino recibe datos a través del puerto serie
  val = Serial.read();

  }


  analogWrite(motor, int(val));

  delay(1);

}
