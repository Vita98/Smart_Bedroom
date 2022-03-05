#include "Arduino.h"
#include "Payloads.h"

/*
  Function that add N "0" character based on the maxLength of the message and 
  the actual lenght of the message to send (button).

  Parameters:
  - button: the button id to send to the App during the setup.
  - maxLength: the maximum length of the message.

  Return: a string of "maxLength" length with the first N (maxLength-len(button)) characters
  as "0" concatenated with the message to send (button).
*/
String addZeros(int button, int maxLength){
  String numberString = String(button);
  String finalString = "";
  for (int i=0;i<(maxLength-numberString.length());i++) { finalString += "0"; }
  return finalString + numberString;
}