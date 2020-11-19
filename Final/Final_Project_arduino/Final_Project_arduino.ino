
const int buttonPin = 2;   
const int potControllerPin = A0;

int buttonState = 0;       
int potControllerInput = 0;
int potControllerValue = 0;

void setup() {
  pinMode(buttonPin, INPUT);
  Serial.begin(9600);
}

void loop() {
  delay(100);
  buttonState = digitalRead(buttonPin);
  potControllerInput = analogRead(potControllerPin);
  potControllerValue = map(potControllerInput, 0, 1023, 25, 775); 

  Serial.print(buttonState); 
  Serial.print(",");
  Serial.println(potControllerValue);
}
