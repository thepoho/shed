#include <wiringPi.h>

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

int main(void)
{
  
  if (wiringPiSetup () == -1)
    return 1 ;
  

  int rowPins[] = {17,27,22,10,9,11,5,6};
  int colPins[] = {2,3,4};

  for(int i = 0; i < sizeof(rowPins); i++){
    pinMode(rowPins[i], OUTPUT);
    digitalWrite(rowPins[i], 1);
  }
  for(int i = 0; i < sizeof(colPins); i++){
    pinMode(colPins[i], OUTPUT);
  }

  while(true){

    //turn all cols off
    for(int i = 0; i < sizeof(colPins); i++){
      digitalWrite(colPins[i], 0);
    }

    sleep(1);

    digitalWrite(colPins[0], 1);
  }


  printf("hello world\n");
}
