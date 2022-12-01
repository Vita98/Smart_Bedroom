/*  ***   ****  ***   ***   ******  ******  ***   ***     *       * ********  *     * ******* ********
    *  *  *     *  *  *  *  *    *  *    *  * *   * *     *       * *         *     *    *    *
    *  *  *     *   * * *   *    *  *    *  *  * *  *     *       * *         *     *    *    *
    ***   ****  *   * **    *    *  *    *  *   *   *     *       * * ******  *******    *    ********
    *  *  *     *   * * *   *    *  *    *  *       *     *       * *      *  *     *    *           *
    *  *  *     *  *  *  *  *    *  *    *  *       *     *       * *      *  *     *    *           *
    ***   ****  ***   *   * ******  ******  *       *     ******  * ********  *     *    *    ********
*/

/*  *      *  * *******   ***   *     * ***   ***   ****    ***
    *      *  *    *     *   *  **    * *  *  *  *  *      *   *
    *      *  *    *    *     * * *   * *   * * *   *     *     *
     *    *   *    *    ******* *  *  * *   * **    ****  *******  
     *    *   *    *    *     * *   * * *   * * *   *     *     *
      *  *    *    *    *     * *    ** *  *  *  *  *     *     *
       **     *    *    *     * *     * ***   *   * ****  *     *
*/

/*
    *       * *        ****** *     ***   *** ******  ***   *    *  *       ****
    *       * *        *      *     * *   * * *    *  *  *  *    *  *       *
    *       * *        *      *     *  * *  * *    *  *   * *    *  *       *
    *       * *  ****  ****   *     *   *   * *    *  *   * *    *  *       ****
    *   *   * *        *      *     *       * *    *  *   * *    *  *       *
     * * * *  *        *      *     *       * *    *  *  *  *    *  *       *
      *   *   *        *      *     *       * ******  ***   ******  ******  ****
*/

/*  Static DHCP for the wifi module with IP: 192.168.1.254  */




#include "ESP8266WiFi.h"
#include <HttpRequestJson.h>
#include <Times.h>



// All debug macro
#ifdef DEBUG_ESP_HTTP_CLIENT
#define DEBUG_HTTP_CLIENT(...) DEBUG_ESP_PORT.printf( __VA_ARGS__ )
#else
#define DEBUG_HTTP_CLIENT(...)
#endif

#ifdef DEBUG_ESP_WIFI
#define DEBUG_HTTP_WIFI(...) DEBUG_ESP_PORT.printf( __VA_ARGS__ )
#else
#define DEBUG_HTTP_WIFI(...)
#endif


//Wifi logIn information
const char* ssid = ""; /*INSERT HERE THE WIFI NETWORK SSID*/
const char* psw =  ""; /*INSERT HERE THE WIFI NETWORK PASSWORD*/


//Instantiating a server on port 80
WiFiServer wifiServer(1616);



//OpCode for the connection with the client
String ConnectionOPCode[3] = {"NEWCONNECT", "ENDCONNECT","CHANLIGH"};

//Timout for the connection
const int connectionDelay = 50;
const int connectionTimeout = 5000;



//Link to the request for the time in which the sun rises and sets
//loc = 41.010563, 17.005021
//All the time are in UTC
String lat = "41.010563";
String lng = "17.005021";
String sunriseSunsetApiLink = "http://api.sunrise-sunset.org/json?lat="+lat+"&lng="+lng+"&formatted=0";
//String sunriseSunsetApiLink = "http://www.google.it:";

//Link to the rest api to get the time in UTC
String timeApiLink = "http://worldtimeapi.org/api/timezone/Etc/UTC";

const int API_REQUEST_DELAY = 300000; //300k 5 min
const int API_REQUEST_DELAY_FAILURE = 5000; //5 seconds
bool failureOnLastRequest = false;
int lastRequest = 0;
HttpRequestJson httpRequestJson;





void setup() {
  //Inizializing the serial with a baud of 115200
  Serial.begin(115200);

  delay(1000);

  //Inizializing the connection with the WIFI
  WiFi.mode(WIFI_STA);
  WiFi.begin(ssid,psw);

  /*Since the connection with tha WIFI can take a couple of seconds,
    it's used a loop for check when the connectiuon is completed     */
  while( WiFi.status() != WL_CONNECTED) { DEBUG_HTTP_WIFI("Connection not enstrablished yet!\n");delay(1000); }

  //At this point the ESP8266 module is correctly connected to the WIFI
  DEBUG_HTTP_WIFI("Connection established!\n");  
  DEBUG_HTTP_WIFI("IP address:\t");
  DEBUG_HTTP_WIFI(WiFi.localIP().toString().c_str());

  //Inizializing the server
  wifiServer.begin();
}



void loop() {

  //Cheching if there is someone trying to connect to the server
  WiFiClient client = wifiServer.available();

  //Clearing the buffers
  Serial.flush();
  client.flush();

  if (client){

    bool ackConnection = false;
    int noOPConnectionTime = 0;
    bool isNoOp;

    //Cheching if there is connection with the client
    while (client.connected()){

      isNoOp = true;
      
      //Informing the arduino about the new connection
      if (!ackConnection){
        Serial.print(ConnectionOPCode[0]);
        //Serial.print("New connection with client enstablished with IP:");
        //Serial.print(client.remoteIP()); 
        ackConnection = true;
        delay(connectionDelay);
      }
      
      String message = "";
      String message1 = "";

      //Read until client send message
      while (client.available() > 0){
        char c = client.read();
        message += c;
        isNoOp = false;
      }

      if (message != ""){
        //Forwording the message to the Arduino on the serial Port
        Serial.print(message);
      }

      

      //Read until arduino send message
      while (Serial.available() > 0){
        char c = Serial.read();
        message1 += c;
        isNoOp = false;
      }

      if (message1 != ""){
        //Forwording the message to the client
        client.print(message1);
      }

      delay(connectionDelay);
      if (isNoOp == true ) noOPConnectionTime += connectionDelay;
      else noOPConnectionTime = 0;

      //Forcing to close the connection if none message is received for a certain 
      //number of seconds defined in the constant "connectionTimeout"
      if (noOPConnectionTime >= connectionTimeout){
        client.stop();
        break;
      }
      
    }

    //Client is not anymore connected
    client.stop();

    //Informing the arduino about the disconnection of the client
    Serial.print(ConnectionOPCode[1]);
  }

  manageSunriseSunsetRequests(client);
}





/*
 * ALL THE FUNCTION WITH THE API REQUEST FOR THE MOVEMENT SENSOR
 */

void manageSunriseSunsetRequests(WiFiClient client){

  if(!failureOnLastRequest){
    if(lastRequest != 0  && (millis() - lastRequest) < API_REQUEST_DELAY) return;
  }else{
    if(lastRequest != 0  && (millis() - lastRequest) < API_REQUEST_DELAY_FAILURE) return;
  }

  //Actual Time
  Times actualTime;
  if(!getActualTimeFromApi(actualTime,client)){
    DEBUG_HTTP_CLIENT("Someting went wrong during the download of the current time from the API!");
    lastRequest = millis();
    failureOnLastRequest = true;
    return;
  }

  //Sunrise and sunset
  Times sunrise;
  Times sunset;
  if( !getSunriseSunsetFromApi(sunrise,sunset,client) ){
    DEBUG_HTTP_CLIENT("Someting went wrong during the download of the sunrise and sunset times from the API!");
    lastRequest = millis();
    failureOnLastRequest = true;
    return;
  }

  String msgToSend = ConnectionOPCode[2];
  if(actualTime.compareTo(sunrise) >= 0 && actualTime.compareTo(sunset) < 0 ) msgToSend += "00";
  else msgToSend += "11";

  Serial.print(msgToSend);
  
  lastRequest = millis();
  failureOnLastRequest = false;
}

bool getActualTimeFromApi(Times& actualTime,WiFiClient client){
  StaticJsonDocument<768> doc;
  bool request = httpRequestJson.getRequest(timeApiLink,doc,client);

  if(request){
    const char* currentDateTime = doc["datetime"];
    actualTime.inflate(currentDateTime);
  }
  return request;
}

bool getSunriseSunsetFromApi(Times& sunrise, Times& sunset,WiFiClient client){
  StaticJsonDocument<768> doc;
  bool request = httpRequestJson.getRequest(sunriseSunsetApiLink,doc,client);

  if(request){
    String statu = doc["status"];

    if(statu == "OK"){
      const char* sunriseS = doc["results"]["sunrise"];
      const char* sunsetS = doc["results"]["sunset"]; 

      sunrise.inflate(sunriseS);
      sunset.inflate(sunsetS);
      return true;
    }
  }
  return false;
}
