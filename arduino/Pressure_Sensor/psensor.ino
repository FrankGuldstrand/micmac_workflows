/*
Pressure Sensor
Reads input signal which triggers pressure reading
 */
#include <Wire.h>

#include <Adafruit_ADS1015.h>

Adafruit_ADS1115 ads1115(0x48); // construct an ads1115
 
int led = 13; //LEDPIN
int rpin = 8; // trigread pin
int buttonstate = 0; // variable that tells the buttonstate
int bits_zero = 685; // recalibrate to ambient pressure before running
float pa_per_bit = 3.76272; // for gain 2/3 calculated from calibration 
// float pa_per_bit = 0.62712; // calibrated 160711 for gain 4
// float pa_per_bit = 0.31356; // calibrated 160711 for gain 8
int counter = 0;
//int t_step =  500; //30000; // milliseconds
int t_step =  5000; // milliseconds // FRANK 2D EXPERIMENT
// the setup routine runs once when you press reset:
void setup() {
                  
  // initialize the digital pin as an output.
  pinMode(led, OUTPUT); 
  pinMode(rpin, INPUT);
  digitalWrite(rpin, HIGH);
  Serial.begin(9600);
  Serial.println("Receiving differential pressure transducer ...");
  // Serial.println("Max pressure difference at gain 8 is 10kPa");
  // Serial.println("Max pressure difference at gain 4 is 20kPa");
  Serial.println("Max pressure difference at gain 2/3 is 120kPa");
  Serial.println("");
  
  // The ADC input range (or gain) can be changed via the following
  // functions, but be careful never to exceed VDD +0.3V max, or to
  // exceed the upper and lower limits if you adjust the input range!
  // Setting these values incorrectly may destroy your ADC!
  //                                                                    ADS1115
  //                                                                    -------  -------
 ads1115.setGain(GAIN_TWOTHIRDS);  // 2/3x gain +/- 6.144V  1 bit = 0.1875mV (default)
  // ads1115.setGain(GAIN_ONE);        // 1x gain   +/- 4.096V  1 bit = 0.125mV
  // ads1115.setGain(GAIN_TWO);        // 2x gain   +/- 2.048V  1 bit = 0.0625mV
  // ads1115.setGain(GAIN_FOUR);       // 4x gain   +/- 1.024V  1 bit = 0.03125mV
  // ads1115.setGain(GAIN_EIGHT);      // 8x gain   +/- 0.512V  1 bit = 0.015625mV
  // ads1115.setGain(GAIN_SIXTEEN);    // 16x gain  +/- 0.256V  1 bit = 0.0078125mV

  ads1115.begin();
}
// the loop routine runs over and over again forever:
void loop(){
  buttonstate=digitalRead(rpin);
  
  if (buttonstate == HIGH) {
  digitalWrite(led,HIGH);
  int16_t bits_diff;
  bits_diff = ads1115.readADC_Differential_0_1();
  Serial.print("Bits_diff ; ");  Serial.print(bits_diff);  Serial.print(" ; "); 
  Serial.print("Volt ; ");  Serial.print(bits_diff*0.1875);  Serial.print(" ; mV ; "); 
  Serial.print("Pres ; ");  
  Serial.print((bits_diff)*pa_per_bit);  
  Serial.print(" ; Pa ; "); 
  Serial.println("");
  counter = counter + 1;
  delay(t_step);
  }
  if (buttonstate == LOW) {
    digitalWrite(led,LOW);

  }
  
}
