public class APTS_OrderTriggerHandler {

    public static void afterUpdate(List<Apttus_Config2__Order__c> newList, Map<Id,Apttus_Config2__Order__c> oldMap)
    {
    	APTS_OrderTriggerHelper.updateParentAgreement(newList, oldMap);   
        APTS_OrderTriggerHelper.updateEndDate(newList, oldMap); 
    }
    
}