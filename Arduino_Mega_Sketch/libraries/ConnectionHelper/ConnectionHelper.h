/*
	Header file used as an Helper for the connection with the Arduino and the ESP.

	The following file contains all the functions declaration and the constant definition
	needed for the connection with the ESP8266 and the app client.

	In particular contains all the constant with the raw message code used by the ESP and the app
	to communicate with the arduino.
	It also contains the constant with the op code used for the setup.
*/
#ifndef ConnectionHelper_h
#define ConnectionHelper_h

#include "Arduino.h"

// Length of a single message received from the app or ESP
#define SINGLE_MESSAGE_LENGTH 10

// SetupStatusOPCode Array length
#define NUM_CONTROL_OPCODE 3

// NormalStatusOPCode array length
#define NUM_OPCODE 7

// SetupConfigurationOPCode array length
#define NUM_SETUP_OPCODE 5

// ConnectionOPCode array length
#define NUM_CONNECTION_OPCODE 3



/*
	CONSTANT ARRAY DECLARATION

	They contains all the OPCode for the bidirectional communication with the ESP and APP.
*/

// Array with all the op code used by the ESP to communicate with the Arduino
const String ConnectionOPCode[NUM_CONNECTION_OPCODE] = {"NEWCONNECT", "ENDCONNECT","CHANLIGH"};

// Array with all the op code used by the APP to communicate the setup status to the Arudino.
const String SetupStatusOPCode[NUM_CONTROL_OPCODE] = {"CHECKCONNE","ENDSETUP","NTRCVD"};

// Array with all the op code used by the APP to communicate the action to perform by the Arduino.
const String NormalStatusOPCode[NUM_OPCODE] = {"BUTTON","SECTIO","WBUTTO","1KWBUT","LONPRE","STAIRS","MOVSEN"};

// Array with alla the op code used by the Arduino to communicate to the APP the values status during the setup.
const String SetupConfigurationOPCode[NUM_SETUP_OPCODE] = {"SECTIO" , "WBUTTO" , "1KWBUT" , "LONPRE", "MOVSEN"};



/*
	Function that explode the incomingString in N commands of SINGLE_MESSAGE_LENGTH length and return the command at "index" position.
	
	Parameters:
	- index: index of the wanted command
	- incomingString: string received from the ESP which can contains more command.
	
	Return: the wanted command at the wanted index.

	Warning: the index must exist otherwise an error will be rised.
*/
String getString(int index, String incomingString);




/*
  Functions to check if the given command is one of the "ConnectionOPCode"
 */

/*
	Function that check if the command given is a Connection Ended command.
	
	Parameters:
	- command: the command string.
	
	Return: true if the command is the "Connection Ended" command, false otherwise.
*/
bool isConnectionEnded(String command);

/*
	Function that check if the command given is a New connection command.
	
	Parameters:
	- command: the command string.
	
	Return: true if the command is the "New Connection" command, false otherwise.
*/
bool isNewConnection(String command);

/*
	Function that check if the command given is a "Change light condition" command.
	It is used by the ESP to communicate when the sunrise or sunset time is reached.
	
	Parameters:
	- command: the command string.
	
	Return: true if the command is the "Change light condition" command, false otherwise.
*/
bool isChangeLightCommand(String command);




/*
  Functions to check if the given command is one of the "SetupStatusOPCode"
 */

/*
	Function that check if the command given is a "Command Not Received" command.
	It is used during the setup by the App to communicate that a data command is missing.
	
	Parameters:
	- command: the command string.
	
	Return: true if the command is the "Command Not Received"" command, false otherwise.
*/
bool isNotReceived(String command);

/*
	Function that check if the command given is a "End Setup" command.
	
	Parameters:
	- command: the command string.
	
	Return: true if the command is the "End Setup" command, false otherwise.
*/
bool isEndSetup(String command);

/*
	Function that check if the command given is a "Check Connection" command.
	It is used during the connection life-time by the App to check if the connection
	with the ESP is still alive.
	
	Parameters:
	- command: the command string.
	
	Return: true if the command is the "Check Connection" command, false otherwise.
*/
bool isCheckConnection(String command);




/*
  Functions to check if the given command is one of the "NormalStatusOPCode"
 */

/*
	Function that check if the command given is a "Normal Button Pressed" command.
	It is used during the connection life-time by the App to notify that the user
	has pressed a button.
	
	Parameters:
	- command: the command string.
	
	Return: true if the command is the "Normal Button Pressed" command, false otherwise.
*/
bool isButtonCommand(String command);

/*
	Function that check if the command given is a "Sections status changed" command.
	It is used during the connection life-time by the App to notify that the user
	has changed the status of a bedroom section
	
	Parameters:
	- command: the command string.
	
	Return: true if the command is the "Sections status changed" command, false otherwise.
*/
bool isSectionCommand(String command);

/*
	Function that check if the command given is a "Wall Button status changed" command.
	It is used during the connection life-time by the App to notify that the user
	has changed the status of a wall button.
	
	Parameters:
	- command: the command string.
	
	Return: true if the command is the "Wall Button status changed" command, false otherwise.
*/
bool isWallButtonCommand(String command);

/*
	Function that check if the command given is a "Wall Button Single Click status changed" command.
	It is used during the connection life-time by the App to notify that the user
	has changed the status the wall button single click event.
	
	Parameters:
	- command: the command string.
	
	Return: true if the command is the "Wall Button Single Click status changed" command, false otherwise.
*/
bool isSingleClickWallButtonCommand(String command);

/*
	Function that check if the command given is a "Wall Button long pression status changed" command.
	It is used during the connection life-time by the App to notify that the user
	has changed the status the wall button long pression event.
	
	Parameters:
	- command: the command string.
	
	Return: true if the command is the "Wall Button long pression status changed" command, false otherwise.
*/
bool isLongPressionWallButtonCommand(String command);

/*
	Function that check if the command given is a "Stair" command.
	It is used during the connection life-time by the App to notify that the user
	has changed the status of the stair linear actuator.
	
	Parameters:
	- command: the command string.
	
	Return: true if the command is the "Stair" command, false otherwise.
*/
bool isStairCommand(String command);

/*
	Function that check if the command given is a "Movement Sensor status changed" command.
	It is used during the connection life-time by the App to notify that the user
	has changed the status of Movement sensor.
	
	Parameters:
	- command: the command string.
	
	Return: true if the command is the "Movement Sensor status changed" command, false otherwise.
*/
bool isMovementSensorCommand(String command);




/*
  Functions to check if the given command is one of the "NormalStatusOPCode" for the setup mode
 */

/*
	Function that check if the command given is a "Missing Section Setup Value" command.
	It is used during the SETUP by the App to notify that the "Section Setup" command is missing.
	
	Parameters:
	- command: the command string.
	
	Return: true if the command is the "Missing Section Setup Value" command, false otherwise.
*/
bool isMissingSectionCommand(String command);

/*
	Function that check if the command given is a "Missing Wall Button Setup Value" command.
	It is used during the SETUP by the App to notify that the "Wall Button Setup" command is missing.
	
	Parameters:
	- command: the command string.
	
	Return: true if the command is the "Missing Wall Button Setup Value" command, false otherwise.
*/
bool isMissingWallButtonCommand(String command);

/*
	Function that check if the command given is a "Missing Wall Button Single click Setup Value" command.
	It is used during the SETUP by the App to notify that the "Wall Button single click Setup" command is missing.
	
	Parameters:
	- command: the command string.
	
	Return: true if the command is the "Missing Wall Button single click Setup Value" command, false otherwise.
*/
bool isMissingSingleClickCommand(String command);

/*
	Function that check if the command given is a "Missing Wall Button long pression Setup Value" command.
	It is used during the SETUP by the App to notify that the "Wall Button long pression Setup" command is missing.
	
	Parameters:
	- command: the command string.
	
	Return: true if the command is the "Missing Wall Button long pression Setup Value" command, false otherwise.
*/
bool isMissingLongPressionCommand(String command);

/*
	Function that check if the command given is a "Missing Movement Sensor Setup Value" command.
	It is used during the SETUP by the App to notify that the "Wall Button Setup" command is missing.
	
	Parameters:
	- command: the command string.
	
	Return: true if the command is the "Missing Movement Sensor Setup Value" command, false otherwise.
*/
bool isMissingMovementSensorCommand(String command);


#endif