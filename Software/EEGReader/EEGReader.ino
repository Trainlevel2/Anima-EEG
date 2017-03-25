#define ARRAY_SIZE 1700

int analogPin = 0;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);
}

void loop() {
  float sig[ARRAY_SIZE];
  int timeBin = 1000;
  unsigned long tic = millis();
  int j = 0;
  while (millis() - tic < timeBin) {
    // read the raw data coming in on analog pin 0:
    int pin0 = analogRead(analogPin);
    // Convert the raw data value (0 - 1023) to voltage (0.0V - 5.0V):
    float voltage = (pin0 * (5.0 / 1024.0));
    // write the voltage value to the serial monitor:
    sig[j] = voltage;
    j++;
    delayMicroseconds(500);
  }
  Serial.print("{");
  for (int i = 0; i < j; i++) {
    Serial.print(sig[i]);
    Serial.print(" ");
  }
  Serial.println("}");
}

