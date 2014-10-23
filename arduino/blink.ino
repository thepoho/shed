int led  = 13;
int clk  = 9;//green
int data = 8;//white

int rgb[5][3] = {{1,1,0},{1,0,1},{1,0,0},{0,1,0},{0,0,1}};
int rbgIdx = 0;

int count = 50;
// the setup routine runs once when you press reset:
void setup() {                
  // initialize the digital pin as an output.
  pinMode(led, OUTPUT);    
  pinMode(clk, OUTPUT);    
  pinMode(data, OUTPUT);    

  digitalWrite(clk,  LOW);
  digitalWrite(data, LOW);
}

int flagOn = 1;
// the loop routine runs over and over again forever:
void loop() {

	flagOn = !flagOn;

	rbgIdx++;
	rbgIdx%=5;

  for(int i=0; i < count; i++){

  	
  	for(int j=0; j < 8; j++){
  		digitalWrite(data, rgb[rbgIdx][0]);
  		digitalWrite(clk, HIGH);
  		digitalWrite(clk, LOW);
  	}
  	for(int j=0; j < 8; j++){
  		digitalWrite(data, rgb[rbgIdx][1]);
  		digitalWrite(clk, HIGH);
  		digitalWrite(clk, LOW);
  	}
  	for(int j=0; j < 8; j++){
  		digitalWrite(data, rgb[rbgIdx][2]);
  		digitalWrite(clk, HIGH);
  		digitalWrite(clk, LOW);
  	}
  }
  delay(500);
  digitalWrite(led, HIGH);   // turn the LED on (HIGH is the voltage level)
  // digitalWrite(led, HIGH);   // turn the LED on (HIGH is the voltage level)
  delay(100);               // wait for a second
  digitalWrite(led, LOW);    // turn the LED off by making the voltage LOW
  // delay(100);               // wait for a second

}

