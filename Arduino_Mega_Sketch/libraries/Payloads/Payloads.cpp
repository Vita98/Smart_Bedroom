#include "Arduino.h"
#include "Payloads.h"

String addZeros(int button, int maxLength){
  String numberString = String(button);
  String finalString = "";
  for (int i=0;i<(maxLength-numberString.length());i++) { finalString += "0"; }
  return finalString + numberString;
}