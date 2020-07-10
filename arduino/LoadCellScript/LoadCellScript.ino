#include "HX711.h"
// HX711 circuit wiring
const int d = 100; // delay in millis
const int LOADCELL1_DOUT_PIN = 2;
const int LOADCELL1_SCK_PIN = 3;
const int LOADCELL2_DOUT_PIN = 4;
const int LOADCELL2_SCK_PIN = 5;
const int LOADCELL3_DOUT_PIN = 6;
const int LOADCELL3_SCK_PIN = 7;
long currentMillis = millis();
int rpin=8;         // PIN WHICH RECEIVES SIGNAL
int switchstate=0;  // reads state of switch
int statevar=0;     // used for checking state of runmode
int led = 13;       // LEDPIN To Show when running

HX711 loadcell1;
HX711 loadcell2;
HX711 loadcell3;

void setup() {
  pinMode(led, OUTPUT);     // SPECIFIES LEDPIN AS OUTPUT
  pinMode(rpin, INPUT);     // SPECIFIES RPIN AS INPUT
  digitalWrite(rpin, HIGH); // UTILIZES ARDUINOS PULLUP FOR STABLE SIGNAL
  switchstate=0;            // INITIAL STATE OFF

  Serial.begin(57600);
  Serial.println("Initializing the scale");
  loadcell1.begin(LOADCELL1_DOUT_PIN, LOADCELL1_SCK_PIN);
  loadcell2.begin(LOADCELL2_DOUT_PIN, LOADCELL2_SCK_PIN);
  loadcell3.begin(LOADCELL3_DOUT_PIN, LOADCELL3_SCK_PIN);

  delay(500);
// CHECK CELLS IF READY
          if (loadcell1.is_ready()) {
              Serial.println("    HX711 loadcell1 Ready");
            } else {
              Serial.println("!!!!HX711 loadcell1 not found.");
            }
          
          if (loadcell2.is_ready()) {
              Serial.println("    HX711 loadcell2 Ready");
            } else {
              Serial.println("!!!!HX711 loadcell2 not found.");
            }
          
          if (loadcell3.is_ready()) {
              Serial.println("    HX711 loadcell3 Ready");
            } else {
              Serial.println("!!!!HX711 loadcell3 not found.");
            }
delay(500);
 
  // CALIBRATE LOAD CELLS
            Serial.println("Calibrating loadcell 1 no weight on");
            loadcell1.set_scale();     // this value is obtained by calibrating the scale with known weights; see the README for details
            loadcell1.tare();                // reset the scale to 0  
            loadcell1.set_scale(-214.54); 
            Serial.println("    loadcell 1 Ready");
          

            Serial.println("Calibrating loadcell 2 no weight on");
            Serial.println("!!!!loadcell 2 FAKE CALIBRATION ");
            loadcell2.set_scale();     // this value is obtained by calibrating the scale with known weights; see the README for details
            loadcell2.tare();                // reset the scale to 0  
            loadcell2.set_scale(-214.54); 
            Serial.println("    loadcell 2 FAKE Ready");

            

            Serial.println("Calibrating loadcell 3 no weight on");
            Serial.println("!!!!loadcell 3 FAKE CALIBRATION ");
            loadcell3.set_scale();     // this value is obtained by calibrating the scale with known weights; see the README for details
            loadcell3.tare();                // reset the scale to 0  
            loadcell3.set_scale(-214.54); 
            Serial.println("    loadcell 3 FAKE Ready");  
  delay(500);

  Serial.println("Ready to run experiment");  


          // CALIBRATION PROCEDURE
          //Serial.println("Put reference weight on.");
          //delay(10000);
          //Serial.println("Calibrating");
          
          //float reading = loadcell.get_units(20);
          // Serial.print("Loadcell reading: ");
          // Serial.println(reading);
          
          //float scaleparam=reading / 611.72; // scale with reference weight
          //Serial.print("scaleparam reading: ");
          //Serial.println(scaleparam);
          //-214.69
          //  loadcell.set_scale(scaleparam);
          
          //Serial.println("Remove Weight (Optional)");
          //delay(10000);

  // CHECK CURRENT TIME
  currentMillis = millis();
}
void loop() {
  
  switchstate=digitalRead(rpin);// Read Switch Signal State 
  
  if (switchstate == HIGH) { // RUNSTATE
  // EXPERIMENT RUNNING
  digitalWrite(led,HIGH); // LED SHOWS EXPERIMENT RUNNING
 
          if (loadcell1.is_ready()) {
            float reading = loadcell1.get_units(1);
            Serial.print(reading/1000*9.82); //Newtons
            Serial.println(" N1 ");
            //Serial.print(millis()-currentMillis);
            //Serial.println(" ms");
        
          } else {
            Serial.print("HX711 loadcell 1 not found.");
            Serial.print(millis()-currentMillis);
            Serial.println(" ms");
        
          }
/* LOAD CELLS 2 and 3
          if (loadcell2.is_ready()) {
            float reading = loadcell2.get_units(1);
            Serial.print(reading/1000*9.82); // Newtons
            Serial.print(" N2 ");
            //Serial.print(millis()-currentMillis);
            //Serial.println(" ms");
        
          } else {
            Serial.print("HX711 loadcell 2 not found.");
            Serial.print(millis()-currentMillis);
            Serial.println(" ms");
          
          }
        
          if (loadcell3.is_ready()) {
            float reading = loadcell3.get_units(1);
            Serial.print(reading/1000*9.82); //Newtons
            Serial.println(" N3 ");
            //Serial.print(millis()-currentMillis);
            //Serial.println(" ms");
        
          } else {
            Serial.print("HX711 loadcell 3 not found.");
            Serial.print(millis()-currentMillis);
            Serial.println(" ms");
      
          }
*/
  delay(d);
  }  
  else
  {
   // EXPERIMENT STOP
   digitalWrite(led,LOW);  // LED OFF
   currentMillis = millis(); // Checks current time
  }    
}
