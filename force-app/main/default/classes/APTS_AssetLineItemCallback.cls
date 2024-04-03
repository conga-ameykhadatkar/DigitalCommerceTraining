/**
* @Name: APTS_AssetLineItemCallback
* @Author(Creator) : Avani Badheka (Conga)
* @CreateDate: 13/Feb/2024
* @Description: Life cycle callback for proposal and event used in it
-----------------------------------------------------------------------------------------------
**/
global with sharing class APTS_AssetLineItemCallback implements Apttus_Config2.CustomClass.IAssetLineItemCallback4 {
	private String assetSearchFilter = null;
	private List<String> assetSearchScope = null;
	private Apttus_Config2__ProductConfiguration__c prodConfig;
	
	private ID userId = null;
	
	private List<Apttus_Proposal__Proposal__c> props = null;
	
	/**
	* Callback at the beginning of the asset selection call.
	* Use the start method to initialize state
	* @param cart the cart object or null if there is no cart context
	* @param assetSearchFilter the preset static filter used in the asset search or null if there is no preset filter
	* @param assetSearchScope the list of asset fields to match the search text or empty to use the default list of fields
	*/
	global void start(Apttus_Config2.ProductConfiguration cart, String assetSearchFilter, List<String> assetSearchScope) {
		this.assetSearchFilter = assetSearchFilter;
		this.assetSearchScope = assetSearchScope;
		
		if (cart == null)
		return;
		this.prodConfig = cart.getConfigSO();
		
		
		if(prodConfig != null && prodConfig.Apttus_QPConfig__Proposald__c != null){
			if(Apttus_Proposal__Proposal__c.SObjectType.getDescribe().isAccessible() 
			&& Schema.SObjectType.Apttus_Proposal__Proposal__c.fields.APTS_Is_Trial_Quote__c.isAccessible() 
			&& Schema.SObjectType.Apttus_Proposal__Proposal__c.fields.Apttus_QPConfig__ABOType__c.isAccessible()){
				props = [
				SELECT 
				Id,APTS_Is_Trial_Quote__c, Apttus_QPConfig__ABOType__c
				from Apttus_Proposal__Proposal__c
				WHERE Id = :prodConfig.Apttus_QPConfig__Proposald__c and 
				((APTS_Is_Trial_Quote__c=true and Apttus_QPConfig__ABOType__c='Renewal') OR Apttus_QPConfig__ABOType__c='Trial Conversion')
				Limit 1];
			}
			
		}
		
	}
	
	/**
	* Callback to return part of SOQL filter clause
	* This filter is used in listing installed products
	* @param accountId is the context account id 
	* @return The query filter is like the following.
	*         Name LIKE 'A%' AND Quantity__c > 100
	*         Id IN ('000123', '000124') 
	*/
	global String getQueryFilter(ID accountId) {
		// all Asset Lines created by the current user
		// return 'CreatedById = \'' + userId + '\' AND CreatedDate > LAST_MONTH';
		return assetSearchFilter;
	}
	
	global Boolean validateAssetTermination(Set<ID> assetIds, Set<ID> accountIds, Date eDate) {
		return true;
	}
	
	global Date getAssetTerminationDate() {
		return Date.newInstance(2018,01,01);
	}
	
	/**
	* Callback to return the filter expression for the asset query where clause
	* This filter is used in listing installed products
	* @param params the parameters for the method
	* @return the filter expression or null to use the default filter.
	* e.g. Name LIKE 'A%' AND Quantity__c > 100
	*         Id IN ('000123', '000124') 
	*/
	global String getFilterExpr(Apttus_Config2.CustomClass.ActionParams params) {
		return APTS_AssetLineItemCallback.getAssetsFilterExpression(this.prodConfig.Apttus_QPConfig__Proposald__c,params);
	}
	
	public static String getAssetsFilterExpression(Id proposalId,Apttus_Config2.CustomClass.ActionParams params) {
		String whereClause = null;
		List<Apttus__APTS_Agreement__c> agreementList=new List<Apttus__APTS_Agreement__c>();
		List<Id> agrIdList=new List<Id>();
		
		Apttus_Proposal__Proposal__c proposal = [SELECT Apttus_Proposal__Account__c,Apttus_Proposal__Opportunity__c, APTS_Is_Trial_Quote__c, Apttus_QPConfig__ABOType__c 
		FROM Apttus_Proposal__Proposal__c WHERE Id = :proposalId];
		
		
		List<Apttus_Config2__AssetLineItem__c> assetLineItemList = new List<Apttus_Config2__AssetLineItem__c>();
		
		if (proposal.APTS_Is_Trial_Quote__c == true && proposal.Apttus_QPConfig__ABOType__c=='Renewal') {
			if(params.AccountId != null) {
				whereClause = 'Apttus_Config2__AccountId__c = \'' + params.AccountId + '\'';
			}
			whereClause += 'AND APTS_Manual_Renewal__c = true and APTS_Trial__c=true and Apttus_Config2__IsInactive__c =false';
		}
		else if(proposal.APTS_Is_Trial_Quote__c == false 
		&& (proposal.Apttus_QPConfig__ABOType__c=='Renewal' || proposal.Apttus_QPConfig__ABOType__c=='Amend' || proposal.Apttus_QPConfig__ABOType__c=='Terminate')){
			List<Apttus__APTS_Agreement__c> agr=[select Id,Apttus__Agreement_Number__c from Apttus__APTS_Agreement__c where Id =: proposal.APTS_Parent_Agreement__c WITH SECURITY_ENFORCED limit 1];
			
			if(agr.size()>0){
				
				agreementList = [select Id,Apttus__Agreement_Number__c from Apttus__APTS_Agreement__c where Apttus__Agreement_Number__c=:agr[0].Apttus__Agreement_Number__c WITH SECURITY_ENFORCED];
				if(agreementList.size()>0){
					for(Apttus__APTS_Agreement__c agrRecord:agreementList){
						agrIdList.add(agrRecord.Id);
					}
					
				}
			}
			
			whereClause = '((APTS_Parent_Agreement__c IN (\'' + String.join(new List<ID>(agrIdList), '\',\'') +
			'\') AND Apttus_Config2__IsInactive__c =false AND proposal.Apttus_QPConfig__ABOType__c != \'Renewal\')  OR  (proposal.Apttus_QPConfig__ABOType__c = \'Renewal\' AND APTS_Is_Renewal_Allowed__c = True))';
		}
		
		
		System.debug('@@@WhereClause' + whereClause);
		return whereClause;
	}
	
	/**
	* Gets the asset search scope
	* @return the asset search scope or null to use the default asset search scope
	*/
	global List<String> getAssetSearchScope(){
		return this.assetSearchScope;
	}
	
	/**
	* Callback after the filter is used
	* Use the finish method to release state
	*/
	global void finish() {
		System.debug('finish method calling '); 
	}
}