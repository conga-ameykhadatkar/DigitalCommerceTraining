/*
*********************************************************
Apex Class Name    : APTS_bestPractice
Created Date       : Feb 26, 2024
@description       : This is class is used for best practice
@author            : Avani Badheka
Modification Log:
Ver   Date         Author                               Modification
1.0   

*********************************************************
*/
public with sharing class APTS_bestPractice {
   

/************************** CLASS LEVEL COMMENT **********************/
	/*
*********************************************************
Apex Class Name    : MyController
Created Date       : July 12, 2020
@description       : This is class is used for....
@author            : Full Name
Modification Log:
Ver   Date         Author             Modification
1.0   
1.1 (if minor change)
2.0 (if major change)
*********************************************************
*/

 /************************** METHOD LEVEL COMMENT **********************/

/*
*********************************************************
@Method Name    : Method Name
@author         : Full Name
@description    : This method is used for....
@param          :
@return         : Output
@event          : in case of trigger helper 
********************************************************
*/

/**********************CONSTANTS IN CLASSES********************************/
/********************************************************
The constans should be in capital letter 
Every constants used in integration , coding must not be hardcoded.
 e.g. public static final String AGMT_STATUS_FULLY_SIGNED
 ********************************************************/

 /**********************TEST CLASS********************************/
/********************************************************
Data should be generated from APTS_TestDataFactory
Coverage for each class should be ~85%
********************************************************/

/**********************TRIGGER FRAMEWORK********************************/
/********************************************************
Must define the events in trigger followed by Handler and Helper apex class
Handler should have common method i.e. AferUpdate, AfterInsert, BeforeInsert etc.
********************************************************/

/**********************CALLBACK CLASSES********************************/
/********************************************************
Must followed the practice of adding detail description in methods
Each Interface and Extensions used in callback should have been added against respective callbacks.
Constants should be used from APTS_Constants class.
********************************************************/

}