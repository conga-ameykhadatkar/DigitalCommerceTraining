/*
*********************************************************
Apex Class Name    : APTS_validationCallbackClass
Created Date       : Feb 26, 2024
@description       : This is class is used for best practice
@author            : Avani Badheka
Modification Log:
Ver   Date         Author              Modification
1.0   
2.0 		  Gunjan Mandaliya		Added ABO-002 changes
*********************************************************
*/ 
global with sharing class APTS_validationCallbackClass implements Apttus_Config2.CustomClass.IValidationCallback3{
    
    
    /*
    *********************************************************
    @Method Name    : validateCart
    @author         : Avani Badheka
    @description    : This method is used to check line status 
    and selling term of item item with selling term of asset line item....
    @param          : Apttus_Config2.CustomClass.ActionParams params, Apttus_Config2.ProductConfiguration cart
    @return         : Apttus_Config2.CustomClass.ValidationResult
    ********************************************************
    */
    global Apttus_Config2.CustomClass.ValidationResult validateCart(Apttus_Config2.CustomClass.ActionParams params, Apttus_Config2.ProductConfiguration cart) {
        
        system.debug('***ValidationCallBack***');
        
        Apttus_Config2.CustomClass.ValidationResult result = new Apttus_Config2.CustomClass.ValidationResult(true); 
        
        list<Apttus_Config2.LineItem> allLines = cart.getLineItems();
        list<Apttus_Config2__LineItem__c> allLineItems = getLineItems(allLines); 
        
        Id configurationId;
        if(allLineItems != null) {
            configurationId = allLineItems[0].Apttus_Config2__ConfigurationId__c;    
        }
        
        Integer i = 0; 
        
        System.debug('***ValidationCallBack > allLineItems: '+allLineItems.size() + ' <> ' + allLineItems);
        
        for(Apttus_Config2__LineItem__c lineItem : allLineItems) {
            
            system.debug('***ValidationCallBack > ' + (++i) + ' > lineItem : ' + lineItem);
            system.debug('GDM: lineitem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Apttus_QPConfig__ABOType__c ' + lineitem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Apttus_QPConfig__ABOType__c);
            if(lineItem.Apttus_Config2__LineType__c == 'Product/Service' && lineItem.Apttus_Config2__ParentBundleNumber__c == null && lineItem.Apttus_Config2__IsPrimaryLine__c == true)
            {
                if(lineitem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Apttus_QPConfig__ABOType__c == APTS_Constants.QUOTE_ABOTYPE_AMEND && lineItem.Apttus_Config2__LineStatus__c == APTS_Constants.LINEITEM_STATUS_RENEWED)
                {
                    result.Messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, 'Amend action is not allowed on this quote.'));
                    result.isSuccess =  false;
                }
                else if(lineitem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Apttus_QPConfig__ABOType__c == APTS_Constants.QUOTE_ABOTYPE_RENEWAL && lineItem.Apttus_Config2__LineStatus__c == APTS_Constants.LINEITEM_STATUS_AMENDED)
                {
                    result.Messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, 'Renewal action is not allowed on this quote.'));
                    result.isSuccess =  false;
                }
                else if(lineitem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Apttus_QPConfig__ABOType__c == APTS_Constants.QUOTE_ABOTYPE_TERMINATE && (lineItem.Apttus_Config2__LineStatus__c == APTS_Constants.LINEITEM_STATUS_RENEWED || lineItem.Apttus_Config2__LineStatus__c == APTS_Constants.LINEITEM_STATUS_AMENDED || lineItem.Apttus_Config2__LineStatus__c == APTS_Constants.LINEITEM_STATUS_NEW))
                {
                    result.Messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, 'This is a Terminate Quote and only Termination actions are allowed in this Quote.'));
                    result.isSuccess =  false;
                }
            }
 			//Avani :Commnted below due to new changes on ABO-003
            //if (lineItem.Apttus_Config2__LineStatus__c == APTS_Constants.LINEITEM_STATUS_AMEND && lineItem.Apttus_Config2__SellingTerm__c < lineItem.Apttus_Config2__AssetLineItemId__r.Apttus_Config2__SellingTerm__c) {
            //    result.Messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, 'Selling Term cannot be reduced for a subscription.'));
            //    result.isSuccess =  false;
            // }
            
        }
        return result;
    }
    global Apttus_Config2.CustomClass.ValidationResult validateRampLineItems(Apttus_Config2.CustomClass.ActionParams params, Apttus_Config2.ProductConfiguration cart,List<Apttus_Config2.LineItem> lstLI) {
        system.debug('***ValidationCallBack > validateRampLineItems() > Cart : ' + cart + ' <> lstTemp : ' + lstLI);
        Apttus_Config2.CustomClass.ValidationResult result;
        return result;
    }
    
    /* Gets the list of product line items associated with the Battery line
    * @param cart the cart object
    * @return the list of line item objects
    */
    private static List<Apttus_Config2__LineItem__c> getLineItems(List<Apttus_Config2.LineItem> allLines) {
        list<Apttus_Config2__LineItem__c> lineItems = new list<Apttus_Config2__LineItem__c>();
        // iterate through the cart and get the line items matching the battery code1 
        for (Apttus_Config2.LineItem lineItemMO : allLines) {
            lineItems.add(lineItemMO.getLineItemSO());
        }
        
        return lineItems;
    }  
}