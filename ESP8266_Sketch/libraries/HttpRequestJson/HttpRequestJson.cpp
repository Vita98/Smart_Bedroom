#include "Arduino.h"
#include "ESP8266HTTPClient.h"
#include "ArduinoJson.h"
#include "HttpRequestJson.h"

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

	return: true if the GET request and the conversion are successful
			false otherwise. 

	Warning: the REST API must return a json object, otherwise the function
	will not work.
*/ 
bool HttpRequestJson::getRequest(String url, JsonDocument& docBuffer){
	HTTPClient http;
  	http.begin(url);

  	int httpCode = http.GET();

  	if(httpCode == 0) return false;
  
  	String payload = http.getString();
  	http.end();

  	// Deserialize the JSON document
  	DeserializationError error = deserializeJson(docBuffer, payload);

  	// Test if parsing succeeds.
  	if (error) {
    	Serial.print(F("deserializeJson() failed: "));
	    Serial.println(error.f_str());
	    return false;
  	}else{
	    return true;
  	}
}