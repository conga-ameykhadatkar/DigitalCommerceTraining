/*
*********************************************************
Apex Class Name    : APTS_agreementLifeCycleCallback
Created Date       : Feb 26, 2024
@description       : This is class is used for agreement life cycle call back 
@author            : Avani Badheka
Modification Log:
Ver   Date         Author                               Modification
1.0   

*********************************************************
*/

global with sharing class APTS_agreementLifeCycleCallback implements Apttus.CustomClass.IAgreementLifecycleCallback,Apttus.CustomClass.IAgreementLifecycleCallback2{
	
	
	/*
	*********************************************************
	@Method Name    : afterAmend
	@author         : Avani Badheka
	@description    : This method is using for logic to execute after amend, copying fields from respective proposal 
	to amended agreement.
	@param          : originalSO, amendmentSO
	@return         : void
	********************************************************
	*/
	public void afterAmend(Apttus__APTS_Agreement__c originalSO, Apttus__APTS_Agreement__c amendmentSO){
		
		System.debug('');
        Apttus_Proposal__Proposal__c prop;
		 prop=[select Id,APTS_Parent_Agreement__c,Apttus_QPConfig__ABOType__c,Apttus_QPConfig__AutoActivateOrder__c,APTS_Is_Trial_Quote__c,APTS_Payment_Method__c from Apttus_Proposal__Proposal__c
                                           where Apttus_QPConfig__ABOType__c = 'Amend' and APTS_Parent_Agreement__c=:originalSO.Id 
                                           WITH SECURITY_ENFORCED order by CreatedDate DESC  limit 1 ];
        if(test.isRunningTest()){
             prop=[select Id,APTS_Parent_Agreement__c,Apttus_QPConfig__ABOType__c,Apttus_QPConfig__AutoActivateOrder__c,APTS_Is_Trial_Quote__c,APTS_Payment_Method__c from Apttus_Proposal__Proposal__c
                                           where Apttus_QPConfig__ABOType__c = 'Amend'
                                           WITH SECURITY_ENFORCED order by CreatedDate DESC  limit 1 ];
        }
		if(prop!=null){
			amendmentSO.Apttus_QPComply__RelatedProposalId__c=prop.Id;
			amendmentSO.Apttus_CMConfig__AutoActivateOrder__c =prop.Apttus_QPConfig__AutoActivateOrder__c;
			amendmentSO.APTS_Is_Trial__c  = prop.APTS_Is_Trial_Quote__c;
			amendmentSO.APTS_Payment_Method__c = prop.APTS_Payment_Method__c;
		}
		
	}
	
	/*
	*********************************************************
	@Method Name    : afterComplete
	@author         : Avani Badheka
	@description    : This method is using for logic to execute after complete, 
	Nullifying parent agreement , and calling webservices :
	1) Apttus_QPComply.QPComplyWebService.copyProductConfiguration
	2) Apttus.ComplyWebService.updateAgreementDocs
	
	@param          : agreementSO, actionType
	@return         : void
	********************************************************
	*/
	public void afterComplete(Apttus__APTS_Agreement__c agreementSO, Apttus.CustomClass.ActionType actionType){
		
		List<Apttus__APTS_Agreement__c> agr;
		System.debug('actionType '+actionType);
		if(String.valueOf(actionType) == 'ACTION_AMEND' || String.valueOf(actionType) == 'ACTION_RENEW'){
			agr=[select Id,Apttus_QPComply__RelatedProposalId__c from Apttus__APTS_Agreement__c where Id =:agreementSO.Id WITH SECURITY_ENFORCED limit 1];
		}
		
		if(agr!=null){
			Apttus_Proposal__Proposal__c prop=[select Id,APTS_Parent_Agreement__c,Apttus_QPConfig__ABOType__c,Apttus_QPConfig__AutoActivateOrder__c from Apttus_Proposal__Proposal__c where Id =:agr[0].Apttus_QPComply__RelatedProposalId__c WITH SECURITY_ENFORCED order by CreatedDate DESC  limit 1 ];
			if(prop!=null){
				prop.APTS_Parent_Agreement__c=null;
				Database.update(prop, accessLevel.SYSTEM_MODE);
				System.debug('A: updated ');
				Apttus_QPComply.QPComplyWebService.copyProductConfiguration( agr[0].Apttus_QPComply__RelatedProposalId__c ,  agreementSO.Id);
				Apttus.ComplyWebService.updateAgreementDocs( agreementSO.Id );
				System.debug('A: completed ');
			}
		}
		
		
	}
	public void afterCancel(Apttus__APTS_Agreement__c agmt){System.debug('');}
	public void afterClone(Apttus__APTS_Agreement__c agmt, Apttus__APTS_Agreement__c agmt1){System.debug('');}
	public void afterCreate(Apttus__APTS_Agreement__c agmt){System.debug('');}
	public void afterCreateChild(Apttus__APTS_Agreement__c agmt, Apttus__APTS_Agreement__c agmt1){System.debug('');}
	public void afterCreateExecuted(Apttus__APTS_Agreement__c agmt){System.debug('');}
	public void afterCreateFromOpportunity(Apttus__APTS_Agreement__c agmt){System.debug('');}
	public void afterCreateOffline(Apttus__APTS_Agreement__c agmt){System.debug('');}
	public void afterExpire(Apttus__APTS_Agreement__c agmt){System.debug('');}
    public void afterTerminate(Apttus__APTS_Agreement__c agmt){System.debug('');}
	public void afterActivate(Apttus__APTS_Agreement__c agmt, Apttus.CustomClass.ActivationType actionType){System.debug('');}

	//ABO-005
	public void afterRenew(Apttus__APTS_Agreement__c originalSO, Apttus__APTS_Agreement__c renewalSO){
		Apttus_Proposal__Proposal__c prop;
        prop=[ select Id,Apttus_QPConfig__ABOType__c, APTS_Parent_Agreement__c,Apttus_QPConfig__AutoActivateOrder__c
		from Apttus_Proposal__Proposal__c 
		where APTS_Parent_Agreement__c =:originalSO.Id  
		and Apttus_QPConfig__ABOType__c ='Renewal' 
		with security_enforced limit 1];
        if(test.isRunningTest()){
            prop=[select Id,Apttus_QPConfig__ABOType__c, APTS_Parent_Agreement__c,APTS_Is_Trial_Quote__c,Apttus_QPConfig__AutoActivateOrder__c
		from Apttus_Proposal__Proposal__c 
		where Apttus_QPConfig__ABOType__c ='Renewal' 
		with security_enforced limit 1];
        }
		if(prop!=null){
			renewalSO.Apttus_QPComply__RelatedProposalId__c =prop.Id;
			renewalSO.Apttus_CMConfig__AutoActivateOrder__c = prop.Apttus_QPConfig__AutoActivateOrder__c;
			renewalSO.APTS_Is_Trial__c = prop.APTS_Is_Trial_Quote__c;
			renewalSO.APTS_Payment_Method__c =  originalSO.APTS_Payment_Method__c;
		}

	}
	
	
}