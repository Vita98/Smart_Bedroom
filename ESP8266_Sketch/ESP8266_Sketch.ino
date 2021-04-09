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


//Wifi logIn information
const char* ssid = ""; /*INSERT HERE THE WIFI NETWORK SSID*/
const char* psw =  ""; /*INSERT HERE THE WIFI NETWORK PASSWORD*/


//Instantiating a server on port 80
WiFiServer wifiServer(1616);



//OpCode for the connection with the client
String ConnectionOPCode[2] = {"NEWCONNECT", "ENDCONNECT"};

//Timout for the connection
const int connectionDelay = 50;
const int connectionTimeout = 5000;





void setup() {
  //Inizializing the serial with a baud of 115200
  Serial.begin(115200);

  delay(1000);

  //Inizializing the connection with the WIFI
  WiFi.mode(WIFI_STA);
  WiFi.begin(ssid,psw);

  /*Since the connection with tha WIFI can take a couple of seconds,
    it's used a loop for check when the connectiuon is completed     */
  while( WiFi.status() != WL_CONNECTED) { Serial.println("Connection not enstrablished yet!");delay(1000); }

  //At this point the ESP8266 module is correctly connected to the WIFI
  Serial.println("Connection established!");  
  Serial.print("IP address:\t");
  Serial.println(WiFi.localIP());

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
  
}
