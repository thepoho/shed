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
  

  //int rowPins[] = {17,27,22,10,9,11,5,6};
  int rowPins[] = {11,13,15,19,21,23,29,31};
  //int colPins[] = {2,3,4};
  int colPins[] = {3,5,7};

  for(int i = 0; i < SIZEOF(rowPins); i++){
    printf("setting row %d\n", i);
  //  pinMode(rowPins[i], OUTPUT);
  //  digitalWrite(rowPins[i], LOW);
  }
  for(int i = 0; i < SIZEOF(colPins); i++){
    printf("setting col %d\n", i);
    pinMode(colPins[i], OUTPUT);
    digitalWrite(colPins[i], LOW);
  }
delay(1000);
printf("HERE\n");
exit(0);
  while(1){
    for(int k = 0; k <= 7; k++)
    {
      //turn all rows off
      for(int i = 0; i < SIZEOF(rowPins); i++){
      //for(int i = 0; i < 8; i++){
        digitalWrite(rowPins[i], LOW);
      }

      //sleep(1);

      if(k == 0 || 1)
        digitalWrite(colPins[0], LOW);
      else
        digitalWrite(colPins[0], HIGH);
     
      for(int i = 0; i < SIZEOF(rowPins); i++){
        if(k == 0 || 1){
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
