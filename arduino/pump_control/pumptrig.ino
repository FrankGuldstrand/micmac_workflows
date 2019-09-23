/*
Triggers pump on input signal
Frank Guldstrand PhD Student
Physics of Geological Processes
UiO
 */
 
int led = 13;       //LEDPIN To Show when running
int rpin=9;         // PIN WHICH RECEIVES SIGNAL
int trigpin=12;     // PIN WHICH TRIGGERS PUMP
int switchstate=0;  // reads state of switch
int statevar=0;     // used for checking state of runmode
int run=0;          // variable used to store if running or nog


  // initialize pin and variables.
void setup() {                
  pinMode(led, OUTPUT);     // SPECIFIES LEDPIN AS OUTPUT
  pinMode(rpin, INPUT);     // SPECIFIES RPIN AS INPUT
  pinMode(trigpin,OUTPUT);  // SPECIFIES TRIGPIN AS OUTPUT
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
  }
  else
  {
   run=0;                  // EXPERIMENT STOP
   digitalWrite(led,LOW);  // LED OFF
  }
 
  if (run == 1 && statevar == 0) // Starts Pump
  {
   digitalWrite(trigpin,HIGH); // TRIGGER PUMP
   delay(100);
   digitalWrite(trigpin,LOW);
   statevar=1;                 // STATE VARIABLE
    }
    
  if (run == 0 && statevar == 1)// Stops Pump
  {
   digitalWrite(trigpin,HIGH); // TRIGGER PUMP
   delay(100);
   digitalWrite(trigpin,LOW);
    statevar=0;                // STATE VARIABLE
    
   }
}
