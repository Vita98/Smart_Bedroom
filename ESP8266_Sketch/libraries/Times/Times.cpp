#include "Arduino.h"
#include "Times.h"

/*
	Empty constructor
*/
Times::Times(){}

/*
	Constructor that inflate the object with tha values into the given string.

	Parameters:
	- dateTime: String of the kind 2015-05-21T19:22:59+00:00.

	Warning: if the string is not in the format "2015-05-21T19:22:59+00:00" the inflate may not work.
*/
Times::Times(String dateTime){
	fromString(dateTime);
}



/*
	Function that execute the inflate of the object at runtime.

	Parameters:
	- dateTime: String of the kind 2015-05-21T19:22:59+00:00.

	Warning: if the string is not in the format "2015-05-21T19:22:59+00:00" the inflate may not work.
*/
void Times::inflate(String dateTime){
	fromString(dateTime);
}

/*
	Function that compare the actual object to another one.

	Parameters:
	- t: Times object to compare the actual object with.

	Return: 0 if the two object are equals, 1 if the actual object is cronologically greater
	-1 if the actual object is cronologically lesser.
*/
int Times::compareTo(Times t){
	if(hours == t.hours){
		if(minutes == t.minutes) return 0;
		else if(minutes > t.minutes) return 1;
		else return -1;
	}else if(hours > t.hours) return 1;
	else return -1;
}

/*
	Function that execute the conversion of the string into the object.
*/
void Times::fromString(String dateTime){
	int tCharIndex = -1;
	tCharIndex = dateTime.indexOf('T');

	if(tCharIndex == -1) return;

	//TIME
	String time = dateTime.substring(tCharIndex+1);

	String hoursS = time.substring(0,2);
	String minutesS = time.substring(3,5);

	hours = hoursS.toInt();
	minutes = minutesS.toInt();
}