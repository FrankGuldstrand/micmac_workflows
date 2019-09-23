/*
 On/Off Box used for triggering experimental equipment
 Frank Guldstrand
 Physics of Geological Processes
 UiO, 2016
 */
 
int led = 13;        //LEDPIN
int rpin=12;         // signal for on off switch
int buttonstate = 0; // Button state variable
int spin1=8;         // send signal out 1
int spin2=9;         // send signal out 2
int spin3=10;        // send signal out 3
int spin4=11;        // send signal out 4


// Initialize pins and setup
void setup() {                

  pinMode(led, OUTPUT); 
  pinMode(rpin, INPUT);
  pinMode(spin1, OUTPUT);
  pinMode(spin2, OUTPUT);
  pinMode(spin3, OUTPUT);
  pinMode(spin4, OUTPUT);
  digitalWrite(rpin, HIGH);
}

// Loop program
void loop(){
  buttonstate=digitalRead(rpin); // Read Switch
  
  if (buttonstate == HIGH) // Experiment On Send On signal
  {
 digitalWrite(led,HIGH);
 digitalWrite(spin1,HIGH);
 digitalWrite(spin2,HIGH);
 digitalWrite(spin3,HIGH);
 digitalWrite(spin4,HIGH);
  }
  if (buttonstate == LOW) // Experiment off Turn off Signal
  {
    digitalWrite(led,LOW);
    digitalWrite(spin1,LOW);
    digitalWrite(spin2,LOW);
    digitalWrite(spin3,LOW);
    digitalWrite(spin4,LOW);
  }
  
}
