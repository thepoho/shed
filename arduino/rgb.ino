#define CLOCK_PIN 8
#define DATA_PIN 9
#define LIGHT_COUNT = 50 //the number of lights in the string
#define SLEEP = 100  //time to sleep between flushes in milllis
char r, g, b;

void setup()   {
  pinMode(clock_pin,  OUTPUT);
  pinMode(data_pin, OUTPUT);
  r = 255;
  g = b = 0;
}

void loop() {
  while(g++ < 255)
    flushAndSleep();
  while(r-- > 0)
    flushAndSleep();
  while(b++ < 255)
    flushAndSleep();
  while(g-- > 0)
    flushAndSleep();
  while(r++ < 255)
    flushAndSleep();
  while(b-- > 0)
    flushAndSleep();
}

void flushAndSleep(){
  flushLights();
  delay(sleep);
}

void flushLights(){
  for(int i=0; i < LIGHT_COUNT; i++){
    shiftOut(DATA_PIN, CLOCK_PIN, MSBFIRST, r);
    shiftOut(DATA_PIN, CLOCK_PIN, MSBFIRST, g);
    shiftOut(DATA_PIN, CLOCK_PIN, MSBFIRST, b);
  }
  delayMicroseconds(500); //500 micros to latch which is apparently 0.5 millis
}
