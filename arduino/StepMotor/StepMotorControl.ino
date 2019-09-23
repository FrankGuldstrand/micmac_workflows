 
/* Step Motor Controller

 * ------------------ 
 *
 * Controls a Sanyo Denki 3-phase stepping motor. The motor is turned 
 * on/off either with the flipswitch, via triggering signal sent to 
 * to the BNC input, or via command line. Stepping speed control can 
 * be done with the potentiometer rotary switch or via command line
 *  
 *Håvard Svanes Bertelsen & Frank Guldstrand
*/

//CHANGING VARIABLES
int buttonState = 0;   // variable for reading the pushbutton status
int val = 0;           // variable to store the value coming from the sensor
int switchstate=0;     // reads state of switch
int k; // function variable

// TRIGGER PINS LOCAL AND EXTERNAL,
const int buttonPin = 9;   // Pushbutton pin
int rpin=8;         // PIN WHICH RECEIVES TRIGGER SIGNAL

// POTENTIOMETER
//int potPin = 2;    // select the input pin for the potentiometer

// LEDPINS
int ledPin1 = 10;   // select the pin for the LED|
int ledPin2 = 11;   // select the pin for the LED
int ledPin3 = 12;   // select the pin for the LED
int ledPin4 = 13;   // select the pin for the LED

// STEPPING MOTOR DRIVER PINS
/*
#define stp  STEP Any Transition from low/high will trigger step
#define dir  DIRECTION 
#define MS1  Logic Input  Microstep Select 1 
#define MS2  Logic Input. Microstep Select 2
#define MS3  Logic Input. Microstep Select 3
#define EN  ENABLE
*
*/

// INITIALIZATION

int stp=2;
int dir=3;
int MS1=4;
int MS2=5;
int MS3=6;
int EN=7;

int x;
int y;
int state;



int gct; //Timecheck variables
int ttr; //Timecheck variables 


void setup(){

  Serial.begin(9600);
  Serial.println("Test");
  
   // initialize the pushbutton pin as an input:
  pinMode(buttonPin, INPUT);  
  pinMode(rpin, INPUT);     // SPECIFIES RPIN AS INPUT
  digitalWrite(rpin, HIGH); // UTILIZES ARDUINOS PULLUP FOR STABLE SIGNAL
  switchstate=0;            // INITIAL STATE OFF
  
  pinMode(ledPin1, OUTPUT);  // declare the ledPin as an OUTPUT
  pinMode(ledPin2, OUTPUT);  // declare the ledPin as an OUTPUT
  pinMode(ledPin3, OUTPUT);  // declare the ledPin as an OUTPUT
  pinMode(ledPin4, OUTPUT);  // declare the ledPin as an OUTPUT
  
  // MOTOR CONTROL
  pinMode(stp, OUTPUT);
  pinMode(dir, OUTPUT);
  pinMode(MS1, OUTPUT);
  pinMode(MS2, OUTPUT);
  pinMode(MS3, OUTPUT);
  pinMode(EN, OUTPUT);
  //resetBEDPins(); //Set step, direction, microstep and enable pins to default states
  
// SET STEP SPEED
digitalWrite(MS1,HIGH);
digitalWrite(MS2,HIGH);
digitalWrite(MS3,HIGH);
digitalWrite(dir,LOW); // Direction
digitalWrite(EN, LOW); //Pull enable pin low to set FETs active and allow motor control for serial control

/*
* MS1+MS2+MS3 High = Sixteen Step
* MS1+MS2 High = Eigth Step
* MS2 High = Quarter Step
* MS1 high = Half Step
* All Low = Full Step 
*/

}

// RUNNING LOOP
void loop() {
  int k;

    // Testing
    //int nstep=1; // number of steps / for 16th step

  // 0.5 mm step over 1 second
  int nstep=123; // number of steps / for 16th step
  int tstep=750; // number of steps / for 16th step

  // 1 mm step over 1 second
  //int tstep=500; // Delay between steps
  //int nstep=246; // number of steps / for 16th step ca 1 mm shearbox

  // Full rotations
  //int nstep=3200; // number of steps / for 16th step / full rotation
  //int nstep=200; // number of steps / for full step / fullrotation

  
  digitalWrite(ledPin1, HIGH);  // turn the ledPin on

  buttonState = digitalRead(buttonPin); //LOCAL SWITCH
  
  // check if the pushbutton is pressed.
  // if it is, the buttonState is HIGH:

          if (buttonState == HIGH) {  // LOCAL DIRECTION FORWARD
            // turn LED on:    
            digitalWrite(ledPin1, HIGH);  
            digitalWrite(dir,LOW); // Direction 
            // delay(tstep/2);
            
            //SmallStepMode(nstep); // function running stepmotor
        
            //delay(tstep/2);
          } 
         
          else {
            // turn LED off: // LOCAL DIRECTION BACKWARD
            digitalWrite(ledPin1, LOW); 
            digitalWrite(dir,HIGH); // Direction 
          } 

 switchstate=digitalRead(rpin);// Read Switch Signal State // TRIGGER BOX STATE
  
          if (switchstate == HIGH) // RUNSTATE TRIGGER
          {
      

            digitalWrite(ledPin2, HIGH);
            digitalWrite(ledPin3, HIGH);
            digitalWrite(ledPin4, HIGH);
            //gct=millis(); // get current time
            delay(tstep/2);
      
            SmallStepMode(nstep); // function running stepmotor

            delay(tstep/2);

            //ttr = millis()-gct; //calculate time of stepmode
            //Serial.println(ttr);
     
          }
          else 
          { 
            //digitalWrite(ledPin1, LOW);  // turn the ledPin off
            digitalWrite(ledPin2, LOW);
            //digitalWrite(ledPin3, LOW);
            //digitalWrite(ledPin4, LOW);
            
          }
}


void SmallStepMode(int x){ // run step motor function
  
for (k = 0; k <= x ; k++) {
    digitalWrite(stp,HIGH); //Trigger one step forward
    delay(1);
    digitalWrite(stp,LOW); //Pull step pin low so it can be triggered again
    delay(1);
    }

}
