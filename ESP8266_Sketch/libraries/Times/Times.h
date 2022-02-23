/*
  Header file for the Times library.

  The following file with functions to convert a dateTime string (2015-05-21T19:22:59+00:00)
  into an object containing only hours and minutes values.

  It also allows to compare two values of the same class.
*/
#ifndef Times_h
#define Times_h

#include "Arduino.h"


class Times
{
  public:
    Times(String dateTime);
    Times();

    void inflate(String dateTime);
    int compareTo(Times t);

    int hours = -1;
    int minutes = -1;
  private:
    void fromString(String dateTime);
};

#endif