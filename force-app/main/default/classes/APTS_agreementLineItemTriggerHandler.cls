/**
* @Name: APTS_agreementLineItemTriggerHandler 
* @Author(Creator): Avani Badheka (CONGA)
* @CreateDate: 13/Feb/2024
* @Description: Trigger handler on Agreement Line Item object.
-----------------------------------------------------------------------------------------------
**/
public class APTS_agreementLineItemTriggerHandler {
public static void afterInsert(List<Apttus__AgreementLineItem__c> newList,Map<Id,Apttus__AgreementLineItem__c> oldMap){
    APTS_agreementLineItemTriggerHelper.updateFieldsAfterInsert(newList,oldMap);
}
}