#include "Arduino.h"
#include "ESP8266HTTPClient.h"
#include "ArduinoJson.h"
#include "HttpRequestJson.h"
#include <WiFiClient.h>

#ifdef DEBUG_ESP_HTTP_CLIENT
#define DEBUG_HTTP_CLIENT(...) DEBUG_ESP_PORT.printf( __VA_ARGS__ )
#else
#define DEBUG_HTTP_CLIENT(...)
#endif

/*
	Class Constructor.
*/
HttpRequestJson::HttpRequestJson(){}

/*
	Function that do a GET request to the given URL and directly
	convert the JSON result into a JsonDocument buffer.

	Parameters:
	- url: the REST API endpoint.
	- docBuffer: pointer to a JsonDocument buffer of the correct size.
	- client: the connected client

	return: true if the GET request and the conversion are successful
			false otherwise. 

	Warning: the REST API must return a json object, otherwise the function
	will not work.
*/ 
bool HttpRequestJson::getRequest(String url, JsonDocument& docBuffer, WiFiClient client){
	HTTPClient http;
	http.setTimeout(2000);
  	http.begin(client,url);

  	int httpCode = http.GET();
  	
  	if(httpCode <= 0) return false;
  
  	String payload = "{}";
  	payload = http.getString();
  	http.end();

  	// Deserialize the JSON document
  	DeserializationError error = deserializeJson(docBuffer, payload);

  	// Test if parsing succeeds.
  	if (error) {
    	DEBUG_HTTP_CLIENT("deserializeJson() failed: ");
	    //Serial.println(error.f_str());
	    return false;
  	}else{
	    return true;
  	}
}