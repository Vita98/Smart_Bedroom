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
#include <StairManager.h>
#include <ConnectionHelper.h>
#include <SectionManager.h>
#include <WallButton.h>
#include <MovementSensor.h>









/*-------------------------------------------------------------------------------------
|                           DEFINITION OF ALL THE CONSTANTS                           |
--------------------------------------------------------------------------------------*/

#define BUTTON_NUM 24
#define RAW_MESSAGES_LENGHT 68

// CONSTANT FOR THE SECTIONS
#define SECTION_ONE_PIN 30
#define SECTION_TWO_PIN 31
#define SECTION_THREE_PIN 32
#define SECTION_FOUR_PIN 33

// CONSTANT FOR THE MOTOR
#define MOTOR_DIRECTION_PIN 10
#define MOTOR_CONNECTION_PIN 8

#define STAIR_OPEN_BUTTON_PIN 43
#define STAIR_CLOSE_BUTTON_PIN 41
#define STAIR_RELE_PIN 24

// WALL BUTTON
#define WALL_BUTTON_CONNECTION_PIN 29
#define WALL_BUTTON_SINGLE_CLICK_DELAY 2
#define WALL_BUTTON_LONG_PRESSION_DELAY 3

// MOVEMENT SENSOR
#define MOVEMENT_SENSOR_CONNECTION_PIN 26




/*-------------------------------------------------------------------------------------
|                           DEFINITION OF ALL THE ENUM                                |
--------------------------------------------------------------------------------------*/
enum SpecialButtons {
  ON = 0,
  OFF = 1,
  MORE_BRIGHT = 10,
  LESS_BRIGHT = 11,
  BABY_COLOR = 14,
  READ_COLOR = 5,
};





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










/*-------------------------------------------------------------------------------------
|                           DEFINITION OF ALL THE DATA                                |
--------------------------------------------------------------------------------------*/
//Status variables for the light
bool isLightOn = false;

//Variable with the color of the light
int lightButtonSelected = READ_COLOR;

//Flag to remember at every iteraction whether the setup mode is active or not
bool setupMode = false;

//Struct instance to send message with the IR Led
IRsend irsend;

// Section manager
SectionManager sectionManager;

// Stair manager
StairManager stairManager(STAIR_OPEN_BUTTON_PIN,STAIR_CLOSE_BUTTON_PIN);

// Wall button
WallButton wallButton(WALL_BUTTON_CONNECTION_PIN,READ_COLOR,BABY_COLOR);

// Movement sensor
MovementSensor movementSensor(MOVEMENT_SENSOR_CONNECTION_PIN,READ_COLOR);






void setup() {
  //Inizializing the serial to print something to the console
  Serial.begin(115200);

  //Inizializing Serial1 to receive the message from the ESP8266 Module
  Serial1.begin(115200);
  Serial1.setTimeout(50);

  //Setting all the 4 section
  int sectionsPin[] = {SECTION_ONE_PIN,SECTION_TWO_PIN,SECTION_THREE_PIN,SECTION_FOUR_PIN};
  sectionManager.setSectionsPin(sectionsPin);

  //Setting the motor for the stair manager
  stairManager.setMotor(MOTOR_DIRECTION_PIN,MOTOR_CONNECTION_PIN,STAIR_RELE_PIN);

  //Aligning the real lights status
  startUpLightsAlignment();

  delay(1000);
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
      String command = getString(index,incomingString);
      Serial.print("Single command: ");
      Serial.println(command);

      //Initializing the setup if the connection with the client is ended
      if (isConnectionEnded(command)){
        //If the command is the end connection, we have to reset the setupMode to false
        setupMode = false;
        continue; //Jump directly to the other command
      }else if (isNewConnection(command)){
        //If the command is the start connection, starting the setup procedure
        setupMode = true;
        Serial.println("SETUP ACTIVE");

        //Send to the client all the setup information
        sendSetupConfiguration("11111");

        continue;
      }


      if (setupMode == true){
        //Setup mode enabled

        if (isNotReceived(command)) {
          Serial.print("Missing command: ");
          Serial.println(command);
        
          //Not received message
          //Sending the missing configuration
          sendMissingConfiguration(command);
        
        } else if (isEndSetup(command)) {
          //End setup message
          setupMode = false;
        }
    
      }else{
        //Setup mode not enabled
        if (!isStairCommand(command)) stairManager.setStairAckWifi(false);
                
        if (isButtonCommand(command)) {
          //BUTTON command received
          BUTTONMessageProcedure(command.substring(NormalStatusOPCode[0].length(),command.length()));
        }else if (isSectionCommand(command)) {
          //SECTIOn command received
          SECTIOMessageProcedure(command.substring(NormalStatusOPCode[1].length(),command.length()));
        }else if (isWallButtonCommand(command)) {
          //WBUTTO command received
          WBUTTOMessageProcedure(command.substring(NormalStatusOPCode[2].length(),command.length()));
        }else if (isSingleClickWallButtonCommand(command)) {
          //1KWBUT command received
          SKWBUTMessageProcedure(command.substring(NormalStatusOPCode[3].length(),command.length()));
        }else if (isLongPressionWallButtonCommand(command)) {
          //LONPRE command received
          LONPREMessageProcedure(command.substring(NormalStatusOPCode[4].length(),command.length()));
        }else if (isStairCommand(command)) {
          //STAIR command received
          stairManager.setStairAckWifi(true);
          STAIRMessageProcedure(command.substring(NormalStatusOPCode[5].length(),command.length()));
        }else if (isMovementSensorCommand(command)){
          MOVSENMessageProcedure(command.substring(NormalStatusOPCode[6].length(),command.length()));
        }else if( isChangeLightCommand(command) ){
          //Message coming from the esp notifying a request to the api for the sunrise/sunset update
          CHANLIGHMessageProcedure(command.substring(ConnectionOPCode[2].length(),command.length()));
        } else if(isCheckConnection(command)){
          //CHECKCONNE command
          // Command to check if there is still connection
          //Answering with the same command
          //sendAcknowledgment();
          Serial.println("CHECKCOMMAND received!");
        } 
      }
    }
  }

  // Calling the method for the management of the movement sensor
  // only when the status is ENABLE or is AUTO and the actual hour is a dark hour.
  MovementSensorStatus msStatus = movementSensor.getStatus();
  if(msStatus == ENABLED || ( msStatus == AUTO && movementSensor.getHoursType() == DARK ) ) movementSensorManagement();

  //Calling the method for the management of the stairs button
  stairManager.runStairManager();

  //Callling the method for the managemet of the wall button
  if (wallButton.isWallButtonEnabled() == true && stairManager.getStairAck() == false && stairManager.getStairAckWifi() == false) wallButtonManager();
    
}




// Method that manage the light alignment after the start up
void startUpLightsAlignment(){
  //turning on if off
  sendIRMessage(RAW_BUTTON_CODE[ON]);
  delay(200);

  //Sending the default effect
  sendIRMessage(RAW_BUTTON_CODE[lightButtonSelected]);
  delay(200);

  //Turnign off
  sendIRMessage(RAW_BUTTON_CODE[OFF]);
  isLightOn = false;

  delay(500);
}

// Method that manage everything about the movement sensor
void movementSensorManagement(){
  if(movementSensor.detectMovement()){
    if(isLightOn == false){
      Serial.println("Turning on the light!");
      //Turning on the light and then the correct effect
      sendIRMessage(RAW_BUTTON_CODE[ON]);
      sendIRMessage(RAW_BUTTON_CODE[movementSensor.getEffect()]);
      lightButtonSelected = movementSensor.getEffect();
      isLightOn = true;
    }
  }
}

// Method that manage everything about the wall button
void wallButtonManager(){
  int numberOfPression = wallButton.readWallButtonPression();

  //Check if the pression is ended
  if(wallButton.isPressionEnded()){
    
    if(wallButton.isSingleClickEnabled() && (numberOfPression > 0 && numberOfPression <= WALL_BUTTON_SINGLE_CLICK_DELAY)){
      //Single click
      if (isLightOn == true) sendIRMessage(RAW_BUTTON_CODE[OFF]);
      else{
        //Send first the command associated and then the ON command
        sendIRMessage(RAW_BUTTON_CODE[ON]);
        sendIRMessage(RAW_BUTTON_CODE[wallButton.getSingleClickEffect()]);
        lightButtonSelected = wallButton.getSingleClickEffect();
      }
      isLightOn = !isLightOn;
      
    }else if(wallButton.isLongPressionEnabled() && numberOfPression >= WALL_BUTTON_LONG_PRESSION_DELAY){
      //Long click 
      int longPressionEffect = wallButton.getLongPressionEffect();
      
      if (isLightOn == true) sendIRMessage(RAW_BUTTON_CODE[longPressionEffect]);
      else{
        //Send first the command associated and then the ON command
        sendIRMessage(RAW_BUTTON_CODE[ON]);
        sendIRMessage(RAW_BUTTON_CODE[longPressionEffect]);
        isLightOn = true;
        lightButtonSelected = longPressionEffect;
      }
    }
  }
  delay(100);
}

//Function used to send the setup 
void sendSetupConfiguration(String configuration){

  if ( configuration.length() != NUM_SETUP_OPCODE ) { return; }
  String finalCommand = "";
  
  if ( configuration.charAt(0) == '1' ) {
    //Sending the SECTI Command
    finalCommand = SetupConfigurationOPCode[0] + sectionManager.getSectionsString();
    Serial1.print(finalCommand); 
  }

  if ( configuration.charAt(1) == '1' ){
    //Sending the wall button status
    finalCommand = SetupConfigurationOPCode[1];
    finalCommand += ( wallButton.isWallButtonEnabled() == true ) ? "1111" : "0000";
    Serial1.print(finalCommand);
  }

  if ( configuration.charAt(2) == '1' ){
    //Sending the command associated to the single click
    finalCommand = "";
    finalCommand = SetupConfigurationOPCode[2] + wallButton.getPayloadSingleClick();
    Serial1.print(finalCommand);
  }

  if ( configuration.charAt(3) == '1'){
    //Sending the command associated to the long pression
    finalCommand = "";
    finalCommand = SetupConfigurationOPCode[3] + wallButton.getPayloadLongPression();
    Serial1.print(finalCommand);
  }

  if ( configuration.charAt(4) == '1'){
    //Sending the command associated to the movement sensor
    finalCommand = "";
    finalCommand = SetupConfigurationOPCode[4] + movementSensor.getPayloadMovementSensor();
    Serial1.print(finalCommand);
  }
}

//Functionn used to send the missing setup configuration based on the incomingCommand parameter
// @parameter incomingCommand is the commmand with the NTRCVD command as head and the code of the missing command right after
void sendMissingConfiguration(String incomingCommand){

  String missingCommand = incomingCommand.substring(SetupStatusOPCode[2].length(),incomingCommand.length() - 2);

  //Check among all the command which one is missing
  if ( isMissingSectionCommand(missingCommand) ) {
    //Missing the SECTI Command
    sendSetupConfiguration("10000");
  }
  if ( isMissingWallButtonCommand(missingCommand) ) {
    //Missing the Wall button status command
    sendSetupConfiguration("01000");
  }
  if ( isMissingSingleClickCommand(missingCommand) ) {
    //Missing the single click command
    sendSetupConfiguration("00100");
  }
  if ( isMissingLongPressionCommand(missingCommand) ) {
    //Missing the longA pression command
    sendSetupConfiguration("00010");
  }
  if ( isMissingMovementSensorCommand(missingCommand) ) {
    //Missing the movement sensor command
    sendSetupConfiguration("00001");
  }
}

//Function that send the message using the irsend.sendRow method
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

//Function called when is received a section command
//Function that set the the status of the IRSender pins based on the received sections status
void SECTIOMessageProcedure(String payload){
  Serial.println("SECTIO Body message: "+ payload);
  sectionManager.updateSectionsStatus(payload);
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

//Function called when is received a wall button (WBUTTO) command
//Function that enable or disable all the functionalities of the wall button based on the payload of the received command
void WBUTTOMessageProcedure(String payload){
  Serial.println("WBUTTO Body message: "+ payload);

  //If the payload received is 1111 means to enable the wall button
  wallButton.enableWallButton( (payload == "1111") );
}

void SKWBUTMessageProcedure(String payload){
  Serial.println("SKWBU Body message: "+ payload);

  if (payload.length() != 4) return;

  //if the first 2 characters are 1 means that the single pression command is enabled
  wallButton.enableSingleClick( (payload.charAt(0) == '1' && payload.charAt(1) == '1') );

  //Getting the substring of the payload with the code of the button
  int buttonCode = (payload.substring(2)).toInt();

  if (buttonCode > 0 && buttonCode <= BUTTON_NUM){
    wallButton.setSingleClickEffect(buttonCode - 1);
  }
}

//Function called when is received a long pression (LONPRE) command
void LONPREMessageProcedure(String payload){
  Serial.println("LONPRE Body message: "+ payload);

  if (payload.length() != 4) return;

  //if the first 2 characters are 1 means that the Long pression command is enabled
  wallButton.enableLongPression( (payload.charAt(0) == '1' && payload.charAt(1) == '1') );

  int buttonCode = (payload.substring(2)).toInt();

  if (buttonCode > 0 && buttonCode <= BUTTON_NUM){
    wallButton.setLongPressionEffect(buttonCode - 1);
  }
}

void STAIRMessageProcedure(String payload){
  Serial.println("STAIR Body message: "+ payload);

  String dire = payload.substring(0,1);
  String rotationSpeed = payload.substring(1);

  stairManager.setWifiCurrentSpeed(rotationSpeed.toInt());
  
  if(dire == "1") stairManager.setWifiDirection(stairManager.FORWARD);
  else if(dire == "0") stairManager.setWifiDirection(stairManager.BACKWARD);
}

//Function called when is received a movement sensor (MOVSEN) command
void MOVSENMessageProcedure(String payload){
  Serial.println("MOVSEN Body message: "+ payload);

  if (payload.length() != 4) return;
  
  movementSensor.setStausByPayload(payload.substring(0,2));

  int buttonCode = (payload.substring(2)).toInt();
  if (buttonCode > 0 && buttonCode <= BUTTON_NUM) movementSensor.setEffect(buttonCode - 1);
}

//Function called when is received a change light command from the ESP8266
void CHANLIGHMessageProcedure(String payload){
  Serial.println("CHANLIG Body message: "+ payload);
  if(payload.length() != 2) return;
  
  movementSensor.setHoursType( (payload == "11") ? DARK : LIGHT);
}
