/**
* @Name: APTS_QuoteProposalTriggerHandler
* @Author (Creator): Avani Badheka (CONGA)
* @CreateDate: 12/Feb/2024
* @Description: Triggerhandler for proposal Trigger.
-----------------------------------------------------------------------------------------------
**/
public class APTS_QuoteProposalTriggerHandler {
	//ON BEFORE ON INSERT
	public static void onBeforeInsert(List<Apttus_Proposal__Proposal__c> newList) {
		APTS_QuoteProposalTriggerHelper.defaultingFields(newList, null, true);
	}

	//ON BEFORE ON UPDATE
	public static void onBeforeUpdate(List<Apttus_Proposal__Proposal__c> newList, Map<Id, Apttus_Proposal__Proposal__c> oldMap, Map<Id, Apttus_Proposal__Proposal__c> newMap) {
		APTS_QuoteProposalTriggerHelper.defaultingFields(newList, oldMap, false);
		APTS_QuoteProposalTriggerHelper.paymentMethodValidation(newList, oldMap);
	}

	//ON AFTER ON UPDATE
	public static void onAfterUpdate(List<Apttus_Proposal__Proposal__c> newList, Map<Id, Apttus_Proposal__Proposal__c> oldMap) {
		APTS_QuoteProposalTriggerHelper.updatePricingOnFlagChange(newList, oldMap);
		APTS_QuoteProposalTriggerHelper.CreateAgreementForEcommerce(newList, oldMap);
	}
}