/*
Triggers cameras on input signal
Frank Guldstrand PhD Student
Physics of Geological Processes
UiO, 2016
 */
 
int led = 13;       // LEDPIN To Show when running
int rpin=8;         // PIN WHICH RECEIVES SIGNAL
int trigpin1=12;    // PIN WHICH TRIGGERS 2 cameras
int trigpin2=11;    // PIN WHICH TRIGGERS 2 cameras
int trigpin3=10;    // PIN WHICH TRIGGERS 2 cameras
int trigpin4=9;     // PIN WHICH TRIGGERS 2 cameras
int switchstate=0;  // reads state of switch
int statevar=0;     // used for checking state of runmode
int run=0;          // variable used to store if running or nog


  // initialize pin and variables.
void setup() {                
  pinMode(led, OUTPUT);     // SPECIFIES LEDPIN AS OUTPUT
  pinMode(rpin, INPUT);     // SPECIFIES RPIN AS INPUT
  digitalWrite(rpin, HIGH); // UTILIZES ARDUINOS PULLUP FOR STABLE SIGNAL
  pinMode(trigpin1,OUTPUT);  // SPECIFIES TRIGPIN AS OUTPUT
  pinMode(trigpin2,OUTPUT);  // SPECIFIES TRIGPIN AS OUTPUT
  pinMode(trigpin3,OUTPUT);  // SPECIFIES TRIGPIN AS OUTPUT
  pinMode(trigpin4,OUTPUT);  // SPECIFIES TRIGPIN AS OUTPUT
  switchstate=0;            // INITIAL STATE OFF
  run=0;                    // INITIAL RUN OFF
}

// the loop 
void loop(){
 
  switchstate=digitalRead(rpin);// Read Switch Signal State 
  
  if (switchstate == HIGH) // RUNSTATE
  {
   run=1;                  // EXPERIMENT RUNNING
   digitalWrite(led,HIGH); // LED ON SHOWING EXPERIMENT RUNNING
   digitalWrite(trigpin1,HIGH); // TRIGGER CAMERAS  
   digitalWrite(trigpin2,HIGH); // TRIGGER CAMERAS
   digitalWrite(trigpin3,HIGH);  // TRIGGER CAMERAS  
   digitalWrite(trigpin4,HIGH);   // TRIGGER CAMERAS
   delay(50);
   digitalWrite(trigpin1,LOW);  // TRIGGER CAMERAS  
   digitalWrite(trigpin2,LOW);   // TRIGGER CAMERAS
   digitalWrite(trigpin3,LOW);  // TRIGGER CAMERAS  
   digitalWrite(trigpin4,LOW);   // TRIGGER CAMERAS
   //delay(9950);  // 10s
   //delay(950); // 1s 
   delay(119950); // 2 minute delay
      digitalWrite(trigpin1,HIGH); // TRIGGER CAMERAS  
   digitalWrite(trigpin2,HIGH); // TRIGGER CAMERAS
   digitalWrite(trigpin3,HIGH);  // TRIGGER CAMERAS  
   digitalWrite(trigpin4,HIGH);   // TRIGGER CAMERAS
   delay(50);
   digitalWrite(trigpin1,LOW);  // TRIGGER CAMERAS  
   digitalWrite(trigpin2,LOW);   // TRIGGER CAMERAS
   digitalWrite(trigpin3,LOW);  // TRIGGER CAMERAS  
   digitalWrite(trigpin4,LOW);   // TRIGGER CAMERAS
   delay(299950); // 5 min delay // Total 7 min loop
  }
  else
  {
   run=0;                  // EXPERIMENT STOP
   digitalWrite(led,LOW);  // LED OFF
  }  
 
}
