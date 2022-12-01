/*
  Header file for the HttpRequestJson library.
  
  The following file contains function to do GET request to REST API
  and directly convert the JSON result in a JsonDocument buffer.
*/
#ifndef HttpRequestJson_h
#define HttpRequestJson_h

#include "Arduino.h"
#include "ArduinoJson.h"
#include <WiFiClient.h>


class HttpRequestJson
{
  public:
    HttpRequestJson();

    bool getRequest(String url, JsonDocument& docBuffer, WiFiClient client);
  private:
};

#endif