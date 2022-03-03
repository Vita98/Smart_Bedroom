#include "Arduino.h"
#include "ConnectionHelper.h"


String getString(int index, String incomingString){
	return incomingString.substring(index * SINGLE_MESSAGE_LENGTH, index * SINGLE_MESSAGE_LENGTH + SINGLE_MESSAGE_LENGTH);
}


bool isConnectionEnded(String command){
	return command.startsWith(ConnectionOPCode[1]);
}

bool isNewConnection(String command){
	return command.startsWith(ConnectionOPCode[0]);
}

bool isChangeLightCommand(String command){
	return command.startsWith(ConnectionOPCode[2]);
}




/*
	Private function that check if the command given is the one at the "index" position in the "SetupStatusOPCode" array.
	It will be used from all the functions that check if the given command is one of the "SetupStatusOPCode".

	Parameters:
	- command: the command string.
	
	Return: true if the command is the one indicated by the index, false otherwise.
*/
bool checkSetupStatusOpCode(String command, int index){
	return command.startsWith(SetupStatusOPCode[index]);
}

bool isNotReceived(String command){
	return checkSetupStatusOpCode(command,2);
}

bool isEndSetup(String command){
	return checkSetupStatusOpCode(command,1);
}

bool isCheckConnection(String command){
	return checkSetupStatusOpCode(command,0);
}




/*
	Private function that check if the command given is the one at the "index" position in the "NormalStatusOPCode" array.
	It will be used from all the functions that check if the given command is one of the "NormalStatusOPCode".

	Parameters:
	- command: the command string.
	
	Return: true if the command is the one indicated by the index, false otherwise.
*/
bool checkNormalStatusOPCode(String command, int index){
	return command.startsWith(NormalStatusOPCode[index]);
}

bool isButtonCommand(String command){
	return checkNormalStatusOPCode(command,0);
}

bool isSectionCommand(String command){
	return checkNormalStatusOPCode(command,1);
}

bool isWallButtonCommand(String command){
	return checkNormalStatusOPCode(command,2);
}

bool isSingleClickWallButtonCommand(String command){
	return checkNormalStatusOPCode(command,3);
}

bool isLongPressionWallButtonCommand(String command){
	return checkNormalStatusOPCode(command,4);
}

bool isStairCommand(String command){
	return checkNormalStatusOPCode(command,5);
}

bool isMovementSensorCommand(String command){
	return checkNormalStatusOPCode(command,6);
}




/*
	Private function that check if the command given is the one at the "index" position in the "NormalStatusOPCode" array.
	It will be used from all the functions that check if the given command is one of the "NormalStatusOPCode" DURING THE SETUP.

	Parameters:
	- command: the command string.
	
	Return: true if the command is the one indicated by the index, false otherwise.
*/
bool checkSetupConfigurationOPCode(String command, int index){
	return command.startsWith(NormalStatusOPCode[index]);
}

bool isMissingSectionCommand(String command){
	return checkSetupConfigurationOPCode(command,0);
}

bool isMissingWallButtonCommand(String command){
	return checkSetupConfigurationOPCode(command,1);
}

bool isMissingSingleClickCommand(String command){
	return checkSetupConfigurationOPCode(command,2);
}

bool isMissingLongPressionCommand(String command){
	return checkSetupConfigurationOPCode(command,3);
}

bool isMissingMovementSensorCommand(String command){
	return checkSetupConfigurationOPCode(command,4);
}


