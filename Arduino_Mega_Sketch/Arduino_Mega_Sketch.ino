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

/*-------------------------------------------------------------------------------------
|                              Copiryght by vitandrea sorino                          |
|                                                                                     |
|                             Single IR Sender led configuration                      |
|               IRS Anodo = > AR GND        IRS Catodo = > AR PIN 3  with Res         |
|                                                                                     |
|                                                                                     |
|                          Multiple IR Sender led Configuration                       |
|  IRS Anodo = > AR PIN 3        IRS Catodo = > Related Arduino Digital pin with Res. |
|                                                                                     |
| NOTE : Use pin 9 on the Arduino Mega and pin 3 on Arduino Uno                       |
----------------------------------------------------------------------------------------*/


#include <IRremote.h>
#include <IRremoteInt.h>








/*-------------------------------------------------------------------------------------
|                           DEFINITION OF ALL THE CONSTANTS                           |
--------------------------------------------------------------------------------------*/

#define BUTTON_NUM 24
#define RAW_MESSAGES_LENGHT 68
#define SINGLE_MESSAGE_LENGTH 10
#define NUM_OPCODE 7
#define NUM_SETUP_OPCODE 5
#define NUM_CONTROL_OPCODE 3

//Pin of the IR led in quadrant order
const int IR_PINS[] = {30,31,32,33};

#define WALL_BUTTON_PIN 29
#define RECV_PIN 3


//Special button
#define ON 0
#define OFF 1
#define MORE_BRIGHT 10
#define LESS_BRIGHT 11
#define BABY_COLOR 14
#define READ_COLOR 5



//Pin for all the button on the wooden beam
#define OPEN_STAIR_PIN 43
#define CLOSE_STAIR_PIN 44
#define SECOND_BUTTON_PIN 41







/*-------------------------------------------------------------------------------------
|                           MATRIX WITH ALL THE BUTTON CODE                           |
--------------------------------------------------------------------------------------*/
unsigned int POSSIBLE_RAW_CODE[] = {9000, 4300, 600, 500, 650, 1600, 550, 1650, 4350, 4400, 9050, 9100, 1700, 8950};

char RAW_BUTTON_CODE[BUTTON_NUM][RAW_MESSAGES_LENGHT] = 
{
  {0,1,2,3,4,5,2,3,2,3,4,3,2,3,4,3,2,3,2,6,2,5,2,5,2,5,4,5,2,5,2,5,2,7,2,5,2,3,2,6,2,3,2,6,2,3,2,3,4,3,2,3,2,7,2,5,2,5,2,5,4,5,2,5,2,5,4,},
  {0,8,4,3,2,7,6,6,2,6,2,3,4,3,6,2,2,3,2,6,2,5,2,7,6,7,2,7,2,5,2,7,2,7,2,3,2,7,2,3,2,6,2,3,4,3,2,6,2,3,2,7,6,6,4,5,2,7,6,7,2,7,2,5,2,7,6,},
  {0,9,2,3,2,7,6,6,2,6,2,6,2,3,2,6,6,6,2,6,6,7,2,7,2,7,2,5,2,7,2,5,2,7,2,3,2,7,2,6,6,7,2,6,2,3,2,6,2,6,2,5,2,6,2,5,2,6,6,7,2,7,2,7,6,7,2,},
  {0,8,4,3,2,7,2,3,2,6,2,3,2,6,2,3,2,6,2,3,4,5,2,7,2,5,2,7,2,5,4,5,2,7,2,5,2,7,2,3,2,6,2,3,4,3,2,6,2,3,2,6,6,6,2,7,2,5,4,5,2,7,2,5,2,7,2,},
  {10,1,4,3,2,7,2,3,2,6,2,3,2,6,2,3,2,6,2,6,6,7,2,7,6,7,2,7,6,7,2,7,2,5,4,3,2,6,2,5,2,6,2,3,2,6,2,3,4,3,2,7,2,5,2,6,2,5,4,5,2,5,4,5,2,7,2,},
  {10,8,2,3,2,7,2,3,4,3,2,6,2,3,2,6,2,3,2,6,2,5,2,7,2,5,4,5,2,5,4,5,2,7,2,5,2,7,2,3,4,5,2,3,4,3,2,3,4,3,2,6,2,3,4,5,2,3,4,5,2,5,4,5,2,5,4,},
  {0,8,2,6,2,5,4,3,2,6,2,3,2,6,2,3,2,6,2,3,4,5,2,5,4,5,2,7,2,5,2,7,2,5,2,7,2,3,4,5,2,6,2,3,2,6,2,3,2,6,2,3,4,5,2,6,2,5,2,7,2,5,2,7,2,5,4,},
  {10,1,2,6,2,5,4,3,2,6,2,3,2,6,2,3,2,6,2,3,4,5,2,5,4,5,2,7,2,5,2,7,2,5,2,6,2,3,4,5,2,5,4,3,2,6,2,3,2,6,2,5,4,5,2,3,4,3,2,7,2,5,2,7,2,5,4,},
  {10,8,6,6,2,7,6,6,4,3,2,6,2,3,2,6,2,3,2,6,2,5,2,7,2,5,4,5,2,7,2,5,2,7,2,3,2,7,2,5,4,3,2,3,4,3,2,6,2,3,2,7,2,3,4,3,2,7,2,5,2,7,2,5,2,7,2,},
  {10,8,2,6,2,5,2,6,2,3,4,3,2,6,2,3,2,6,2,3,2,7,2,5,2,7,2,5,2,7,2,5,4,5,2,5,4,3,2,7,2,5,2,6,2,3,4,3,2,6,2,3,2,7,2,3,2,6,2,5,4,5,2,5,4,5,2,},
  {11,1,4,3,2,7,2,3,4,3,2,6,2,3,2,6,2,3,4,3,2,5,4,5,2,7,2,5,4,5,2,7,2,5,4,5,2,6,2,3,4,5,2,3,4,3,2,6,2,3,4,3,2,7,2,5,4,3,2,5,4,5,2,7,2,5,4,},
  {10,8,6,6,4,5,2,6,2,3,4,3,2,3,4,3,2,3,6,2,2,7,2,5,2,7,2,5,2,7,2,7,6,7,2,6,6,6,6,2,6,2,6,7,2,6,6,6,6,2,6,12,6,7,2,7,6,7,2,6,6,12,6,7,2,7,6,},
  {0,9,2,3,4,5,2,6,2,3,2,6,2,3,2,6,2,3,2,6,2,5,4,5,2,7,2,5,2,7,2,5,4,5,2,3,4,5,2,7,2,3,2,7,2,3,4,3,2,6,2,5,2,6,2,3,2,7,2,3,4,5,2,7,2,5,2,},
  {0,9,2,6,6,7,2,6,2,3,2,6,2,3,4,3,2,6,6,6,2,7,6,7,2,7,2,5,2,7,2,7,6,7,2,7,6,6,2,6,2,3,4,5,2,6,2,3,2,6,2,3,4,5,6,7,2,7,2,6,2,5,2,7,6,7,2,},
  {0,8,2,6,2,5,2,6,2,3,4,3,2,6,2,3,2,6,2,3,2,7,2,5,2,7,2,5,4,5,2,5,4,5,2,6,2,5,2,6,2,3,2,7,2,3,2,6,2,3,4,5,2,6,2,5,2,7,2,3,2,7,2,5,4,5,2,},
  {10,8,2,6,2,5,2,6,2,3,2,6,2,3,2,6,2,3,2,6,2,5,4,5,2,7,6,7,2,7,2,5,2,7,2,5,2,7,2,7,2,3,2,7,2,3,2,6,2,3,4,3,2,6,2,3,2,7,2,3,2,7,2,5,2,7,2,},
  {10,1,4,3,2,7,2,3,2,6,2,3,2,6,2,3,4,3,2,6,2,5,2,7,2,5,2,7,2,5,2,7,2,5,4,5,2,7,2,3,2,6,2,5,2,6,2,3,4,3,2,6,2,3,2,7,2,5,2,6,2,5,2,7,2,7,2,},
  {10,8,2,3,4,5,2,6,2,3,2,6,2,3,2,6,2,3,4,3,2,5,4,5,2,7,2,5,2,7,2,5,2,7,2,3,4,3,2,3,4,5,2,7,2,3,2,6,2,3,4,5,2,5,4,5,2,6,2,3,2,7,2,5,4,5,2,},
  {13,9,2,6,6,7,2,6,2,6,6,6,6,2,6,6,6,2,6,6,6,12,2,5,2,7,2,7,2,5,2,7,2,5,2,6,6,6,6,12,2,6,3,12,2,6,6,6,6,2,6,7,6,12,6,2,6,7,6,2,6,7,6,12,6,7,6,},
  {10,8,2,3,4,5,2,6,2,3,2,6,2,3,4,3,2,3,4,3,2,5,4,5,2,5,4,5,2,7,2,5,4,5,2,5,4,3,2,3,4,5,2,7,2,3,2,6,2,3,4,3,2,5,4,5,2,6,2,3,2,7,2,5,4,5,2,},
  {0,9,2,3,6,12,2,3,6,2,6,2,6,6,6,2,6,6,6,2,6,7,2,7,6,7,4,5,2,7,2,5,2,7,2,3,6,12,6,7,2,7,2,3,2,6,6,2,6,6,6,12,6,6,6,2,6,2,6,7,2,7,6,7,2,7,6,},
  {0,9,6,2,6,7,2,6,6,6,6,2,6,6,6,2,6,6,6,2,6,12,6,7,2,7,6,7,2,7,6,7,2,7,6,12,6,6,6,12,6,6,4,5,6,6,6,2,6,2,6,6,6,12,6,6,6,12,6,6,2,7,2,7,6,7,4,},
  {10,8,2,6,2,5,2,6,2,3,2,6,2,3,2,6,2,6,6,6,2,7,2,5,2,7,2,5,2,7,2,5,4,5,2,6,2,3,2,6,2,5,2,6,2,3,4,3,2,6,2,5,2,7,2,5,4,3,2,5,4,5,2,7,2,5,2,},
  {0,8,2,6,6,7,2,6,6,6,6,2,6,2,6,6,2,6,6,6,6,12,6,7,2,7,6,7,2,7,2,7,6,7,2,7,6,7,2,7,6,6,6,2,6,2,6,6,6,2,6,6,6,2,6,6,2,7,2,7,6,7,2,7,6,7,2,},
};



enum StairDirection {
  Backward,
  Forward
};







/*-------------------------------------------------------------------------------------
|                           DEFINITION OF ALL THE VARIABLES                           |
--------------------------------------------------------------------------------------*/

//State variables for the enabled quadrant
bool EnabledIRQ[] = {true,true,true,true};

//Status variables for the light
bool isLightOn = false;

//Variable with the index of the command to be executed after the ON command
//from the Wall button
//Default value = READ command
int singleClickWbuttonButtonID = READ_COLOR;
bool isSingleClickEnabled = true;

//Variable with the index of the command to be executed after the ON command
//from the movement sensor
//Default value = READ command
int movementSensorClickButtonID = READ_COLOR;
bool isMovementSensorEnabled = true;

//Variable with the index of the command to be executed after the
//long pression of the wall button
//Default value = BABY command
int longPressionWbuttonButtonID = BABY_COLOR;
bool isLongPressionEnabled = true;

//Wall button status
bool isWallButtonEnabled = true;





//Variable with the color of the light
int lightButtonSelected = longPressionWbuttonButtonID;

//Flag to remember at every iteraction that we the setup mode is active or not
bool setupMode = false;

//Variable used uidentify the single Wall click or the long pression
int wallButtonNumberPression = 0;

//Struct instance to send message with the IR Led
IRsend irsend;

//Array with all the OPCode
String NormalStatusOPCode[NUM_OPCODE] = {"BUTTON","SECTIO","WBUTTO","1KWBUT","LONPRE","STAIRS","MOVSEN"};

String SetupStatusOPCode[NUM_CONTROL_OPCODE] = {"CHECKCONNE","ENDSETUP","NTRCVD"};

String SetupConfigurationOPCode[NUM_SETUP_OPCODE] = {"SECTIO" , "WBUTTO" , "1KWBUT" , "LONPRE", "MOVSEN"};

String ConnectionOPCode[2] = {"NEWCONNECT", "ENDCONNECT"};








/*-------------------------------------------------------------------------------------
|                      SECTION FOR THE STAIR STEPPER MOTOR                            |
--------------------------------------------------------------------------------------*/
const int MOTOR_STEP_PIN = 8;
const int MOTOR_DIRECTION_PIN = 10;
const int MOTOR_ENABLER_RELE_PIN = 24;
const int MOVEMENT_SENSOR_PIN = 26;


bool isMovementDetected = false;
bool stairAck = false;
bool stairAckWifi = false;
StairDirection wifiStairCurrentDirection = Forward;
int wifiStairCurrentSpeed = 0;
int cyclesWithoutStairAck = 0;

int minDelayRotation = 500;
int maxDelayRotation = 1000;
bool isMotorEnabled = false;















void setup() {

  //Inizializing the serial to print something to the console
  Serial.begin(115200);

  //Inizializing Serial1 to receive the message from the ESP8266 Module
  Serial1.begin(115200);
  Serial1.setTimeout(50);

  //Setting the pinMode of the IRSender LED
  pinMode(IR_PINS[0], OUTPUT);
  pinMode(IR_PINS[1], OUTPUT);
  pinMode(IR_PINS[2], OUTPUT);
  pinMode(IR_PINS[3], OUTPUT);

  //Setting enabled all the quadrant
  digitalWrite(IR_PINS[0],HIGH);
  digitalWrite(IR_PINS[1],HIGH);
  digitalWrite(IR_PINS[2],HIGH);
  digitalWrite(IR_PINS[3],HIGH);
  
  //Setting the pinMode for the Wall button pin
  pinMode(WALL_BUTTON_PIN,INPUT);

  //Setting the pinMode for the wooden beam buttons
  pinMode(OPEN_STAIR_PIN, INPUT);
  pinMode(CLOSE_STAIR_PIN, INPUT);
  pinMode(SECOND_BUTTON_PIN, INPUT);

  //Setting the pinMode for the stepper motor
  pinMode(MOTOR_STEP_PIN,OUTPUT);
  pinMode(MOTOR_DIRECTION_PIN,OUTPUT);
  pinMode(MOTOR_ENABLER_RELE_PIN,OUTPUT);

  //Setting the pinMode for the movement sensor
  pinMode(MOVEMENT_SENSOR_PIN, INPUT);

  digitalWrite(MOTOR_ENABLER_RELE_PIN, LOW);


  delay(2000);
}







void loop() {

  //Read the message from the ESP module
  String incomingString = "";
  while(Serial1.available() > 0){
     incomingString = Serial1.readString();
  }

  //Check if the EPS module sent something
  if (incomingString != ""){

    Serial.print("Commands received: ");
    Serial.println(incomingString);

    //Used to prevent loss of command sent at the same time
    for (int index = 0; index < (int) incomingString.length() / SINGLE_MESSAGE_LENGTH; index++){
      String command = incomingString.substring(index * SINGLE_MESSAGE_LENGTH, index * SINGLE_MESSAGE_LENGTH + SINGLE_MESSAGE_LENGTH);

      //Initializing the setup if the connection with the client is ended
      if (command.startsWith(ConnectionOPCode[1]) ){
        //If the command is the end connection, we have to reset the setupMode to false
        setupMode = false;
        continue; //Jump directly to the other command
      }else if (command.startsWith(ConnectionOPCode[0])){
        //If the command is the start connection, starting the setup procedure
        setupMode = true;
        
        Serial.println("SETUP ACTIVE");

        //Send to the client all the setup information
        sendSetupConfiguration("11111");

        continue;
      }

      
      
      if (setupMode == true){
        //Setup mode enabled

        if ( command.startsWith(SetupStatusOPCode[2]) ) {
        
          //Not received message
          //Sending the missing configuration
          sendMissingConfiguration(command);
        
        } else if ( command.startsWith(SetupStatusOPCode[1]) ) {
          //End setup message
          setupMode = false;
        } else {
          //Send the rejection command
        }
    
      }else{
        //Setup mode not enabled
        if (!command.startsWith(NormalStatusOPCode[5]) ){
          stairAckWifi=false;
        }
                
        if ( command.startsWith(NormalStatusOPCode[0]) ) {
          //BUTTON command received
          BUTTONMessageProcedure(command.substring(NormalStatusOPCode[0].length(),command.length()));
        }else if (command.startsWith(NormalStatusOPCode[1]) ) {
          //SECTIOn command received
          SECTIOMessageProcedure(command.substring(NormalStatusOPCode[1].length(),command.length()));
        }else if (command.startsWith(NormalStatusOPCode[2]) ) {
          //WBUTTO command received
          WBUTTOMessageProcedure(command.substring(NormalStatusOPCode[2].length(),command.length()));
        }else if (command.startsWith(NormalStatusOPCode[3]) ) {
          //1KWBUT command received
          SKWBUTMessageProcedure(command.substring(NormalStatusOPCode[3].length(),command.length()));
        }else if (command.startsWith(NormalStatusOPCode[4]) ) {
          //LONPRE command received
          LONPREMessageProcedure(command.substring(NormalStatusOPCode[4].length(),command.length()));
        }else if (command.startsWith(NormalStatusOPCode[5]) ) {
          //STAIR command received
          stairAckWifi = true;
          STAIRMessageProcedure(command.substring(NormalStatusOPCode[5].length(),command.length()));
        }else if (command.startsWith(NormalStatusOPCode[6]) ){
          MOVSENMessageProcedure(command.substring(NormalStatusOPCode[6].length(),command.length()));
        }else if (command.startsWith(SetupStatusOPCode[0]) ){
          //CHECKCONNE command
          // Command to check if there is still connection
          //Answering with the same command
          //sendAcknowledgment();
          Serial.println("CHECKCOMMAND received!");
        } 
      }
    }    
  }

  //Calling the method for the management of the movement sensor
  if(isMovementSensorEnabled == true ) movementSensorManagement();

  //Calling the method for the management of the stairs button
  stairAck = stairManager();
  
  //Callling the method for the managemet of the wall button
  if (isWallButtonEnabled == true && stairAck == false) wallButtonManager();

  if(isMotorEnabled){
    if(!stairAck && !stairAckWifi) cyclesWithoutStairAck++;
    else cyclesWithoutStairAck = 0;
  
    //Closing the motor relè after 10 cycles without a movement command
    if(cyclesWithoutStairAck == 10){
      digitalWrite(MOTOR_ENABLER_RELE_PIN, LOW);
      isMotorEnabled = false;
      Serial.println("Disabling the motor!");
    }
    stairAck=false;
  }
}





// Method that manage everything about the movement sensor
void movementSensorManagement(){
  if (digitalRead(MOVEMENT_SENSOR_PIN) == HIGH){
    if (isMovementDetected == false){
      Serial.println("MOVEMENT DETECTED!");
      isMovementDetected = true;
      if(isLightOn == false){
        Serial.println("Turning on the light!");
        //Turning on the light and then the correct effect
        sendIRMessage(RAW_BUTTON_CODE[ON]);
        sendIRMessage(RAW_BUTTON_CODE[movementSensorClickButtonID]);
        lightButtonSelected = movementSensorClickButtonID;
        isLightOn = true;
      }
    }
  }else{
    if (isMovementDetected == true){
      Serial.println("MOVEMENT NOT DETECTED ANYMORE!");
      isMovementDetected = false;
    }
  }
}

//Function used to send the acknoledgment message
//It is used to answere to the check command
void sendAcknowledgment(){
  Serial1.print(SetupStatusOPCode[0]);
}

//Functionn used to send the missing setup configuration based on the incomingCommand parameter
// @parameter incomingCommand is the commmand with the NTRCVD command as head and the code of the missing command right after
void sendMissingConfiguration(String incomingCommand){

  String missingCommand = incomingCommand.substring(SetupStatusOPCode[2].length(),incomingCommand.length() - 2);

  //Check among all the command which one is missing
  if ( SetupConfigurationOPCode[0].startsWith(missingCommand) ) {
    //Missing the SECTI Command
    sendSetupConfiguration("10000");
  }
  if ( SetupConfigurationOPCode[1].startsWith(missingCommand) ) {
    //Missing the Wall button status command
    sendSetupConfiguration("01000");
  }
  if ( SetupConfigurationOPCode[2].startsWith(missingCommand) ) {
    //Missing the single click command
    sendSetupConfiguration("00100");
  }
  if ( SetupConfigurationOPCode[3].startsWith(missingCommand) ) {
    //Missing the long pression command
    sendSetupConfiguration("00010");
  }
  if ( SetupConfigurationOPCode[4].startsWith(missingCommand) ) {
    //Missing the movement sensor command
    sendSetupConfiguration("00001");
  }
}







//Function used to send the setup 
void sendSetupConfiguration(String configuration){

  if ( configuration.length() != NUM_SETUP_OPCODE ) { return; }
  String finalCommand = "";
  
  if ( configuration.charAt(0) == '1' ) {
    //Sending the SECTI Command
    finalCommand = SetupConfigurationOPCode[0] + getSectionsString();
    Serial1.print(finalCommand); 
  }

  if ( configuration.charAt(1) == '1' ){
    //Sending the wall button status
    finalCommand = SetupConfigurationOPCode[1];
    finalCommand += ( isWallButtonEnabled == true ) ? "1111" : "0000";
    Serial1.print(finalCommand);
  }

  if ( configuration.charAt(2) == '1' ){
    //Sending the command associated to the single click
    finalCommand = "";
    finalCommand = SetupConfigurationOPCode[2] + getPayloadSingleClick();
    Serial1.print(finalCommand);
  }

  if ( configuration.charAt(3) == '1'){
    //Sending the command associated to the long pression
    finalCommand = "";
    finalCommand = SetupConfigurationOPCode[3] + getPayloadLongPression();
    Serial1.print(finalCommand);
  }

  if ( configuration.charAt(4) == '1'){
    //Sending the command associated to the movement sensor
    finalCommand = "";
    finalCommand = SetupConfigurationOPCode[4] + getPayloadMovementSensor();
    Serial1.print(finalCommand);
  }
}



String getPayloadMovementSensor(){
  String payload = ( isMovementSensorEnabled ) ? "11" : "00";
  payload += addZeros(movementSensorClickButtonID,2);
  return payload;
}

String getPayloadSingleClick(){
  String payload = ( isSingleClickEnabled ) ? "11" : "00";
  payload += addZeros(singleClickWbuttonButtonID,2);
  return payload;
}

String getPayloadLongPression(){
  String payload = ( isLongPressionEnabled ) ? "11" : "00";
  payload += addZeros(longPressionWbuttonButtonID,2);
  return payload;
}

String addZeros(int button, int maxLength){
  String numberString = String(button);
  String finalString = "";
  for (int i=0;i<(maxLength-numberString.length());i++) { finalString += "0"; }
  return finalString + numberString;
}




//Method that return the status of the IR sender
//as a String in quadrant order
String getSectionsString(){
  String sections = "";
  for (int i=0;i<4;i++){ sections += (EnabledIRQ[i] == true) ? "1" : "0"; }
  return sections;
}




// Method that manage everything about the wall button
void wallButtonManager(){

  //Reading the pression of the wall button
  if (digitalRead(WALL_BUTTON_PIN) == HIGH){
    wallButtonNumberPression++;
    Serial.write("Pressed");
  }else{

    //Wall button pression ended
    if (wallButtonNumberPression == 1) {
      
      //Single click
      if (isSingleClickEnabled == true){
        if (isLightOn == true) sendIRMessage(RAW_BUTTON_CODE[OFF]);
        else{
          //Send first the command associated and then the ON command
          sendIRMessage(RAW_BUTTON_CODE[ON]);
          sendIRMessage(RAW_BUTTON_CODE[singleClickWbuttonButtonID]);
          lightButtonSelected = singleClickWbuttonButtonID;
        }
      }
      
      isLightOn = !isLightOn;
      
    }else if (wallButtonNumberPression > 2){
      //Long pression

      if (isLongPressionEnabled == true){
        if (isLightOn == true) sendIRMessage(RAW_BUTTON_CODE[longPressionWbuttonButtonID]);
        else{
          //Send first the command associated and then the ON command
          sendIRMessage(RAW_BUTTON_CODE[ON]);
          sendIRMessage(RAW_BUTTON_CODE[longPressionWbuttonButtonID]);
          isLightOn = true;
          lightButtonSelected = longPressionWbuttonButtonID;
        }
      }

    }

    wallButtonNumberPression = 0;
  }
  delay(150);
}

void sendIRMessage(char* message){
    int i;

    unsigned int finalMessage[RAW_MESSAGES_LENGHT] = {};

    //Decompressing the indexCode into raw code
    for (int i=0;i<RAW_MESSAGES_LENGHT;i++){
      finalMessage[i] = POSSIBLE_RAW_CODE[int(message[i])];
    }
    
    for (i=0;i<10;i++){
        irsend.sendRaw(finalMessage,RAW_MESSAGES_LENGHT,38);
    }
}






//Procedure called when is received a normal button command
void BUTTONMessageProcedure(String payload){
  Serial.println("BUTTON Body message: "+ payload);

  int buttonCode = payload.toInt();

  //If the result of the convertion is 0 means that the payload is not valid
  if (buttonCode > 0 && buttonCode <= BUTTON_NUM){

    buttonCode -= 1;

    //Sending the message to the IRSender
    sendIRMessage(RAW_BUTTON_CODE[buttonCode]);

    //Checking that the command received is not one of the special button commands
    if (buttonCode != ON && buttonCode != OFF && buttonCode != LESS_BRIGHT && buttonCode != MORE_BRIGHT){
      
      //Saving the status of the lights
      lightButtonSelected = buttonCode;
    }else if (buttonCode == ON){
      
      //ON Command received
      isLightOn = true;
    }else if (buttonCode == OFF){

      //OFF command received
      isLightOn = false;
    }
  }
}

//Function called when is received a section command
//Function that set the the status of the IRSender pins based on the received sections status
void SECTIOMessageProcedure(String payload){
  Serial.println("SECTIO Body message: "+ payload);

  //Setting the selected section
  for (int i = 0; i < 4; i++){

    //Saving the status
    EnabledIRQ[i] = payload.charAt(i) == '1' ? true : false;

    //Setting the pin of the section
    digitalWrite(IR_PINS[i], EnabledIRQ[i] == true ? HIGH : LOW );
  }
}

//Function called when is received a wall button (WBUTTO) command
//Function that enable or disable all the functionalities of the wall button based on the payload of the received command
void WBUTTOMessageProcedure(String payload){
  Serial.println("WBUTTO Body message: "+ payload);

  //If the payload received is 1111 means to enable the wall button
  if (payload == "1111") isWallButtonEnabled = true;
  else isWallButtonEnabled = false; 
}

//Function called when is received a long pression (LONPRE) command
void LONPREMessageProcedure(String payload){
  Serial.println("LONPRE Body message: "+ payload);

  if (payload.length() != 4) return;

  //if the first 2 characters are 1 means that the Long pression command is enabled
  if (payload.charAt(0) == '1' && payload.charAt(1) == '1') isLongPressionEnabled = true;
  else isLongPressionEnabled = false;

  int buttonCode = (payload.substring(2)).toInt();

  if (buttonCode > 0 && buttonCode <= BUTTON_NUM){
    longPressionWbuttonButtonID = buttonCode - 1;
  }
}

//Function called when is received a movement sensor (MOVSEN) command
void MOVSENMessageProcedure(String payload){
  Serial.println("MOVSEN Body message: "+ payload);

  if (payload.length() != 4) return;

  //if the first 2 characters are 1 means that the movment sensor is enabled
  if (payload.charAt(0) == '1' && payload.charAt(1) == '1') isMovementSensorEnabled = true;
  else isMovementSensorEnabled = false;

  int buttonCode = (payload.substring(2)).toInt();

  if (buttonCode > 0 && buttonCode <= BUTTON_NUM){
    movementSensorClickButtonID = buttonCode - 1;
  }
}

void SKWBUTMessageProcedure(String payload){
  Serial.println("SKWBU Body message: "+ payload);

  if (payload.length() != 4) return;

  //if the first 2 characters are 1 means that the single pression command is enabled
  if (payload.charAt(0) == '1' && payload.charAt(1) == '1') isSingleClickEnabled = true;
  else isSingleClickEnabled = false;

  //Getting the substring of the payload with the code of the button
  int buttonCode = (payload.substring(2)).toInt();

  if (buttonCode > 0 && buttonCode <= BUTTON_NUM){
    singleClickWbuttonButtonID = buttonCode - 1;
  }
}

void STAIRMessageProcedure(String payload){
  Serial.println("STAIR Body message: "+ payload);

  String dire = payload.substring(0,1);
  String rotationSpeed = payload.substring(1);
  wifiStairCurrentSpeed = rotationSpeed.toInt();
  
  if(dire == "1"){
    wifiStairCurrentDirection = Forward;
  }else if(dire == "0"){
    wifiStairCurrentDirection = Backward;
  }
}














/*-------------------------------------------------------------------------------------
|                      FUNCTIONS FOR THE STEPPER MOTOR                                |
--------------------------------------------------------------------------------------*/

bool stairManager(){

  int currentSpeed = wifiStairCurrentSpeed > 0 ? wifiStairCurrentSpeed : 100;
  if (wifiStairCurrentSpeed == 0) stairAckWifi = false;

  if(digitalRead(OPEN_STAIR_PIN) == HIGH || (wifiStairCurrentSpeed > 0 && wifiStairCurrentDirection == Forward && stairAckWifi == true)){
    goForwards(currentSpeed);
    return true;
  }
  if(digitalRead(SECOND_BUTTON_PIN) == HIGH || (wifiStairCurrentSpeed > 0 && wifiStairCurrentDirection == Backward && stairAckWifi == true)){
    goBackwards(currentSpeed);
    return true;
  }

  //Serial.println(digitalRead(SECOND_BUTTON_PIN));
  return false;
}

void goForwards(int rotationSpeed){
  if(!isMotorEnabled){
    digitalWrite(MOTOR_ENABLER_RELE_PIN, HIGH);
    isMotorEnabled = true;
  }

  Serial.print("\nRotation speed: ");
  Serial.println(rotationSpeed);
  
  Serial.println("Going forward");
  digitalWrite(MOTOR_DIRECTION_PIN,LOW); // Enables the motor to move in a particular direction

  int i;
  int del = (float(rotationSpeed)/100)*(minDelayRotation - maxDelayRotation) + maxDelayRotation;

  Serial.print("Rotation speed in del: ");
  Serial.println(del);
  
  if(del == maxDelayRotation) return;
  
  for(i=0;i<100;i++){
    // Makes 200 pulses for making one full cycle rotation
    digitalWrite(MOTOR_STEP_PIN,HIGH); 
    delayMicroseconds(del); 
    digitalWrite(MOTOR_STEP_PIN,LOW); 
    delayMicroseconds(del); 
  }
}

void goBackwards(int rotationSpeed){
  if(!isMotorEnabled){
    digitalWrite(MOTOR_ENABLER_RELE_PIN, HIGH);
    isMotorEnabled = true;
  }
  
  Serial.println("Going Backwards");
  digitalWrite(MOTOR_DIRECTION_PIN,HIGH); // Enables the motor to move in a particular direction
  
  int i;
  int del = (float(rotationSpeed)/100)*(minDelayRotation - maxDelayRotation) + maxDelayRotation;
  if(del == maxDelayRotation) return;

  for(i=0;i<100;i++){
    // Makes 200 pulses for making one full cycle rotation
    digitalWrite(MOTOR_STEP_PIN,HIGH); 
    delayMicroseconds(del); 
    digitalWrite(MOTOR_STEP_PIN,LOW); 
    delayMicroseconds(del); 
  }
}
