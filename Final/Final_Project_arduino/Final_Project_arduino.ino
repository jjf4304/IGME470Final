
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
  buttonState = digitalRead(buttonPin);
  potControllerInput = analogRead(potControllerPin);
  potControllerValue = map(potControllerInput, 0, 1023, 0, 800); 

  Serial.println(buttonState);
  Serial.println(potControllerValue);
}
