public class APTS_AssetLineItemTriggerHandler {
	 
    public static void beforeUpdate(List<Apttus_Config2__AssetLineItem__c> newList, Map<Id,Apttus_Config2__AssetLineItem__c> oldMap)
    {
    	APTS_AssetLineItemTriggerHelper.setGracePeriodFields(newList, oldMap);
    }
}