public class APTS_AssetLineItemTriggerHelper {

/*
*********************************************************
@Method Name    : setGracePeriodFields
@author         : Gunjan Mandaliya
@description    : This method is used for setting the Grace Period fields on Asset Line Items
@param          : List<Apttus_Config2__AssetLineItem__c> newList, Map<Id,Apttus_Config2__AssetLineItem__c> oldMap
@return         : void
@event 			: Before Update
********************************************************
*/    
    public static void setGracePeriodFields(List<Apttus_Config2__AssetLineItem__c> newList, Map<Id,Apttus_Config2__AssetLineItem__c> oldMap){
        
        for(Apttus_Config2__AssetLineItem__c asset : newList)
        {
            if(asset.Approval_Status__c != oldMap.get(asset.Id).Approval_Status__c)
            {
                if(asset.Approval_Status__c == 'Approved')
                {
                 	asset.APTS_GracePeriodDays__c = 0;
                
                	if(asset.APTS_GracePeriodEndDate__c == null || asset.Apttus_Config2__EndDate__c >= asset.APTS_GracePeriodEndDate__c){
                    	Date endDate = asset.Apttus_Config2__EndDate__c;
                    
                    	asset.APTS_GracePeriodEndDate__c = endDate.addDays(asset.APTS_GracePeriodDays__c.intValue());
                	}
                	else if(asset.Apttus_Config2__EndDate__c < asset.APTS_GracePeriodEndDate__c){
                    	Date gracePeriodEndDate = asset.APTS_GracePeriodEndDate__c;
                    
                    	asset.APTS_GracePeriodEndDate__c = gracePeriodEndDate.addDays(asset.APTS_GracePeriodDays__c.intValue());
                	}
                
                	asset.APTS_SubscriptionStatus__c = 'In Grace';   
                }
                else if(asset.APTS_Trial__c == true && asset.Apttus_Config2__LineType__c == 'Option' && asset.Approval_Status__c == 'Cancelled')
                {
                    break;
                }
                else
                {
                    asset.APTS_SubscriptionStatus__c = asset.Apttus_Config2__AssetStatus__c;
                }
            }
            //Avani : QTE -002
            if(asset.Apttus_Config2__AssetStatus__c != oldMap.get(asset.Id).Apttus_Config2__AssetStatus__c){
                if(asset.Apttus_Config2__AssetStatus__c=='Activated' 
                && asset.APTS_Trial__c == true 
                && asset.Apttus_Config2__LineType__c == 'Option'){
                    asset.Apttus_Config2__AssetStatus__c ='Cancelled';
                }
            }
        }
    }
    
}