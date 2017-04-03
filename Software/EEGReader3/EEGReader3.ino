#define ARRAY_SIZE 1500

int analogPin0 = A0;
int analogPin1 = A1;
int analogPin2 = A2;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);
  //Serial.println("Test");
}

void loop() {
//  float sig0[ARRAY_SIZE];
//  float sig1[ARRAY_SIZE];
  int timeBin = 1000;
  int j = 0;
  unsigned long tic = millis();
  Serial.print("{");
  while (millis() - tic < timeBin) {
    float pin0 = analogRead(analogPin0);                 // read the raw data coming in on analog pin 0:
    pin0 = (pin0 * (5.0 / 1024.0));               // Convert the raw data value (0 - 1023) to voltage (0.0V - 5.0V):
    Serial.print(pin0);
    Serial.print(" ");
    float pin1 = analogRead(analogPin1);                 // read the raw data coming in on analog pin 0:
    pin1 = (pin1 * (5.0 / 1024.0));               // Convert the raw data value (0 - 1023) to voltage (0.0V - 5.0V): 
    Serial.print(pin1);
    Serial.print(" ");
    float pin2 = analogRead(analogPin2);                 // read the raw data coming in on analog pin 0:
    pin2 = (pin2 * (5.0 / 1024.0));               // Convert the raw data value (0 - 1023) to voltage (0.0V - 5.0V): 
    Serial.print(pin2);
    Serial.print(" ");
    j++;
  }
  Serial.println("}");
}

