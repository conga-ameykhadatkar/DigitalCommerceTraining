/**
* @Name: APTS_QuoteProposalLifecycleCallback
* @Author(Creator) : Avani Badheka (Conga)
* @CreateDate: 13/Feb/2024
* @Description: Life cycle callback for proposal and event used in it
-----------------------------------------------------------------------------------------------
**/
global class APTS_QuoteProposalLifecycleCallback implements Apttus_Proposal.CustomClass.IQuoteLifecycleCallback2  {
    
    /**
    * Callback invoked after an agreement is created from a quote/proposal
    * @param quoteSO the quote sobject 
    * @param agreementSO the new agreement sobject 
    */
    global void afterCreateAgreement(Apttus_Proposal__Proposal__c quoteSO, Apttus__APTS_Agreement__c agreementSO) {
        try{
            Apttus_Proposal__Proposal__c prop=[select Id,Apttus_QPConfig__AutoActivateOrder__c,APTS_Is_Trial_Quote__c from Apttus_Proposal__Proposal__c where Id =:quoteSO.Id limit 1];
            if (prop!=null) {
                System.debug('after agr create auto '+prop.Apttus_QPConfig__AutoActivateOrder__c);
                System.debug('after agr create trial '+prop.APTS_Is_Trial_Quote__c);
                agreementSO.Apttus_CMConfig__AutoActivateOrder__c=prop.Apttus_QPConfig__AutoActivateOrder__c;
                agreementSO.APTS_is_Trial__c=prop.APTS_Is_Trial_Quote__c;
            }
            
        }catch(Exception ex){
            System.debug('Exception Occurred-->'+ex.getMessage()+'at Line-->'+ex.getLineNumber());
        }
    }
    /**
    * Callback invoked after a quote/proposal is created from an account
    * @param quoteSO the new quote sobject 
    */
    global void afterCreateFromAccount(Apttus_Proposal__Proposal__c quoteSO) {
    }
    /**
    * Callback invoked after a quote/proposal is created from an opportunity
    * @param quoteSO the new quote sobject 
    */
    global void afterCreateFromOpportunity(Apttus_Proposal__Proposal__c quoteSO) { 
        
    }
    /**
    * Callback invoked after a quote/proposal is cloned
    * @param originalSO the original quote sobject 
    * @param cloneSO the clone quote sobject
    */
    global void afterClone(Apttus_Proposal__Proposal__c originalSO, Apttus_Proposal__Proposal__c cloneSO) {
    }
    
    /**
    * Callback invoked after the completion of a lifecycle action
    * @param quoteSO the quote sobject 
    * @PARAM actionType the lifecycle action type
    */
    global void afterComplete(Apttus_Proposal__Proposal__c quoteSO, Apttus_Proposal.CustomClass.ActionType actionType) {
    }
    
    /**
    * Callback invoked after the completion of a lifecycle action
    * @param agreementSO the agreement sobject 
    * @PARAM actionType the lifecycle action type
    */
    global void afterComplete(Apttus__APTS_Agreement__c agreementSO, Apttus_Proposal.CustomClass.ActionType actionType) {
    }   
}