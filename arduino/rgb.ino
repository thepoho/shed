#define CLOCK_PIN 9
#define DATA_PIN 8
#define LIGHT_COUNT 50 //the number of lights in the string
#define SLEEP 1 //time to sleep between flushes in milllis
unsigned char r, g, b;

void setup() {
  pinMode(CLOCK_PIN, OUTPUT);
  pinMode(DATA_PIN, OUTPUT);
  r = 255;
  g = b = 0;
  //Serial.begin(9600); 
}

void loop() {
  for(g; g < (unsigned char)255; g++)
    flushAndSleep();
  for(r; r > (unsigned char)0; r--)
    flushAndSleep();
  for(b; b < (unsigned char)255; b++)
    flushAndSleep();
  for(g; g > (unsigned char)0; g--)
    flushAndSleep();
  for(r; r < (unsigned char)255; r++)
    flushAndSleep();
  for(b; b > (unsigned char)0; b--)
    flushAndSleep();
  while(b-- > 0)
    flushAndSleep();
}
void flushAndSleep(){
  flushLights();
  // Serial.print("R: "); 
  // Serial.print(r, DEC); 
  // Serial.print(" G: "); 
  // Serial.print(g, DEC); 
  // Serial.print(" B: "); 
  // Serial.println(b, DEC); 
  delay(SLEEP);
}
void flushLights(){
  int i = 0;
  for(i=0; i < LIGHT_COUNT; i++){
    
    shiftOut(DATA_PIN, CLOCK_PIN, MSBFIRST, r);
    shiftOut(DATA_PIN, CLOCK_PIN, MSBFIRST, g);
    shiftOut(DATA_PIN, CLOCK_PIN, MSBFIRST, b);
  }
  delayMicroseconds(500); //500 micros to latch which is apparently 0.5 millis
}


