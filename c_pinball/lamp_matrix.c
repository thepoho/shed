#include <wiringPi.h>

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

#define SIZEOF(n) (sizeof(n) / sizeof(n[0]))
//#define SIZEOF(n) (sizeof(n))


int main(void)
{
  
  if (wiringPiSetup() == -1)
    return 1 ;
  

  FIX THESE PIN NUMBERS
  int rowPins[8] = {11,13,15,19,21,23,29,31};
  int colPins[3] = {3,5,7};
  int colOutputs[8][3] = {{0,0,0},{0,0,1},{0,1,0},{0,1,1},{1,0,0},{1,0,1},{1,1,0},{1,1,1}};

  for(int i = 0; i < SIZEOF(rowPins); i++){
    pinMode(rowPins[i], OUTPUT);
    digitalWrite(rowPins[i], LOW);
  }
  for(int i = 0; i < SIZEOF(colPins); i++){
    pinMode(colPins[i], OUTPUT);
    digitalWrite(colPins[i], LOW);
  }


  while(1){
    for(int k = 0; k <= 7; k++)
    {
      //turn all rows off
      for(int i = 0; i < SIZEOF(rowPins); i++){
      //for(int i = 0; i < 8; i++){
        digitalWrite(rowPins[i], LOW);
      }

      //sleep(1);

      for(int i = 0; i < 3; i++){
	digitalWrite(colPins[i], colOutputs[k][i]);
      }
      /*
      if(k == 0 || 1)
        digitalWrite(colPins[0], LOW);
      else
        digitalWrite(colPins[0], HIGH);
      //*/
     
      for(int i = 0; i < SIZEOF(rowPins); i++){
        if(k == 0){
          digitalWrite(rowPins[i], HIGH);
        }
        else{
          digitalWrite(rowPins[i], HIGH);
        }
      }
    }
  }

//printf("millis is now %d",millis()-start);

printf("hello world\n");
}
