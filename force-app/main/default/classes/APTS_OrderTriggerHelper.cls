public class APTS_OrderTriggerHelper {
	
	public static void updateParentAgreement(List<Apttus_Config2__Order__c> newList, Map<Id,Apttus_Config2__Order__c> oldMap)
	{
		List<Id> orderIdsList=new List<Id>();
		List<Apttus_Config2__AssetLineItem__c> listToBeUpdated = new List<Apttus_Config2__AssetLineItem__c>();
		List<Id> agreementListIds = new List<Id>();
		Map<Id,date> parentagreementEndDateupdateFromOLI=new Map<Id,date>();
		try{
			for(Apttus_Config2__Order__c order : newList)
			{
				orderIdsList.add(order.Id);
				agreementListIds.add(order.Apttus_CMConfig__AgreementId__c);
			}
			
			Map<Id,Apttus__APTS_Agreement__c> agreementIdVsRecordMap = new Map<Id,Apttus__APTS_Agreement__c>([Select Id, APTS_is_Trial__c from Apttus__APTS_Agreement__c where Id in :agreementListIds]);
			List<Apttus__APTS_Agreement__c> agrList=new List<Apttus__APTS_Agreement__c>();
			Map<Id,Apttus_Config2__OrderLineItem__c> orderLineItemList = new Map<Id,Apttus_Config2__OrderLineItem__c> ([Select Id, Apttus_Config2__AssetLineItemId__c,
			Apttus_Config2__LineType__c,Apttus_Config2__AssetLineItemId__r.APTS_Trial__c,
			Apttus_Config2__AssetLineItemId__r.APTS_Manual_Renewal__c,Apttus_Config2__ParentBundleNumber__c,
			Apttus_Config2__LineStatus__c
			from Apttus_Config2__OrderLineItem__c where Apttus_Config2__OrderId__c in :orderIdsList]);
			//Map<Id,Apttus_Config2__AssetLineItem__c> assetLineItemList = new Map<Id,Apttus_Config2__AssetLineItem__c> ([Select Id, APTS_Parent_Agreement__c from Apttus_Config2__AssetLineItem__c where Id in :orderLineItemList.keySet()]);
			
			for(Apttus_Config2__Order__c orderRecord: newList)
			{
				if(orderRecord.Apttus_Config2__Status__c != oldMap.get(orderRecord.Id).Apttus_Config2__Status__c && orderRecord.Apttus_Config2__Status__c == 'Activated' && orderRecord.Apttus_Config2__Source__c == 'Agreement' && orderRecord.Apttus_CMConfig__AgreementId__r.Apttus_CMConfig__ABOType__c == null)
				{
					for(Apttus_Config2__OrderLineItem__c oli : orderLineItemList.values())
					{
						if(oli.Apttus_Config2__OrderId__c == orderRecord.Id)
						{
							Apttus_Config2__AssetLineItem__c ali = new Apttus_Config2__AssetLineItem__c();
							ali.Id = oli.Apttus_Config2__AssetLineItemId__c;
							ali.APTS_Parent_Agreement__c = orderRecord.Apttus_CMConfig__AgreementId__c;
							
							Apttus__APTS_Agreement__c agr = agreementIdVsRecordMap.get(orderRecord.Apttus_CMConfig__AgreementId__c);
							
							if(agr.APTS_is_Trial__c == false)
							{
								ali.APTS_Trial__c = false;
								//ali.APTS_Manual_Renewal__c = false;
							}
							
							listToBeUpdated.add(ali);
						}
					}
				}//QTE-002
				//orderRecord.Apttus_Config2__Status__c != oldMap.get(orderRecord.Id).Apttus_Config2__Status__c 
				Apttus_Proposal__Proposal__c prop=[select Id,Apttus_QPConfig__ABOType__c, APTS_Is_Trial_Quote__c
				from Apttus_Proposal__Proposal__c where Id =: orderRecord.Apttus_QPConfig__ProposalId__c];
				
				Apttus_Config2__AssetLineItem__c assetLineItem=[select Id,Name,APTS_Trial__c, APTS_Manual_Renewal__c,Apttus_QPConfig__ProposalId__c,APTS_Parent_Agreement__c
				from Apttus_Config2__AssetLineItem__c 
				where Apttus_QPConfig__ProposalId__c=:orderRecord.Apttus_QPConfig__ProposalId__c and Apttus_Config2__ParentBundleNumber__c=null];
				system.debug('orderRecord.Apttus_Config2__Status__c '+orderRecord.Apttus_Config2__Status__c);
				system.debug('orderRecord.Apttus_Config2__Source__c '+orderRecord.Apttus_Config2__Source__c);
				system.debug('orderRecord.Apttus_QPConfig__ProposalId__r.Apttus_QPConfig__ABOType__c '+orderRecord.Apttus_QPConfig__ProposalId__r.Apttus_QPConfig__ABOType__c);
				system.debug('orderRecord.Apttus_QPConfig__ProposalId__r.APTS_Is_Trial_Quote__c '+orderRecord.Apttus_QPConfig__ProposalId__r.APTS_Is_Trial_Quote__c);
				if (
				orderRecord.Apttus_Config2__Status__c == 'Activated' 
				&& orderRecord.Apttus_Config2__Source__c == 'Quote' 
				&&  prop.Apttus_QPConfig__ABOType__c == 'Renewal' 
				&& prop.APTS_Is_Trial_Quote__c==true) {
					System.debug('A: initial condition');
					if (orderLineItemList.size()>0) {
						for(Apttus_Config2__OrderLineItem__c oli : orderLineItemList.values()){
							system.debug('oli.Apttus_Config2__LineType__c '+oli.Apttus_Config2__LineType__c);
							system.debug('oli.Apttus_Config2__ParentBundleNumber__c '+oli.Apttus_Config2__ParentBundleNumber__c);
							system.debug('oli.Apttus_Config2__LineStatus__c '+oli.Apttus_Config2__LineStatus__c);
							system.debug('assetLineItem.APTS_Trial__c '+assetLineItem.APTS_Trial__c);
							system.debug('assetLineItem.APTS_Manual_Renewal__c '+assetLineItem.APTS_Manual_Renewal__c);
							
							if (oli.Apttus_Config2__LineType__c=='Product/Services'
							&& oli.Apttus_Config2__ParentBundleNumber__c== null 
							&& oli.Apttus_Config2__LineStatus__c=='Renewed'
							&& assetLineItem!=null 
							&& assetLineItem.APTS_Trial__c == true 
							&& assetLineItem.APTS_Manual_Renewal__c== true 
							) {
								System.debug('A: here condition match');
								parentagreementEndDateupdateFromOLI.put(assetLineItem.APTS_Parent_Agreement__c,oli.Apttus_Config2__EndDate__c);
								break;
							}
						}
						
						
						
					}
					System.debug('here ');
				}
				system.debug('parentagreementEndDateupdateFromOLI '+parentagreementEndDateupdateFromOLI.size());
				if (parentagreementEndDateupdateFromOLI.keySet()!=null) {
					agrList=[select Id,Apttus__Contract_End_Date__c
					from Apttus__APTS_Agreement__c where id in :parentagreementEndDateupdateFromOLI.keySet() WITH SECURITY_ENFORCED];
					if (!agrList.isEmpty()) {
						for(Apttus__APTS_Agreement__c agr:agrList){
							System.debug('A: here condition match end date');
							agr.Apttus__Contract_End_Date__c= parentagreementEndDateupdateFromOLI.get(agr.Id);
						}
					}                                        
				}
				
				if(agrList.size()>0){
					// Database.update(agrList, false, accessLevel.SYSTEM_MODE);
					System.debug('A: here condition match update');
				} 
			}
			
			
			
			
		}catch(Exception e){
			System.debug('Exception from order '+e.getLineNumber()+' error '+e.getMessage());
		}
		
		
	}  
	
	public static void updateEndDate(List<Apttus_Config2__Order__c> newList, Map<Id,Apttus_Config2__Order__c> oldMap){
		List<Id> orderIdsList=new List<Id>();
		List<Apttus_Config2__AssetLineItem__c> listToBeUpdated = new List<Apttus_Config2__AssetLineItem__c>();
		List<Id> proposalListId = new List<Id>();
		List<Id> agreementListIds=new List<Id>();
		List<Id> assetLineIdList=new List<Id>();
		Map<Id,Apttus_Config2__Order__c> orderRecord=new Map<Id,Apttus_Config2__Order__c>();
		List<Apttus__APTS_Agreement__c> agrList=new List<Apttus__APTS_Agreement__c>();
		Map<Id,Id> orderLineAssetLineMap=new Map<Id,Id>();
		Map<Id,List<Apttus_Config2__OrderLineItem__c>> ordeAndLineItemMap=new Map<Id,List<Apttus_Config2__OrderLineItem__c>>();
		Map<Id,Apttus_Config2__AssetLineItem__c> assetLineItemMap=new Map<Id,Apttus_Config2__AssetLineItem__c>();
		Map<Id,date> oliEnddateAgreementMap=new Map<Id,date>();
		try{
			for(Apttus_Config2__Order__c order : newList)
			{
				//order.Apttus_Config2__Status__c != oldMap.get(order.Id).Apttus_Config2__Status__c &&
				if( order.Apttus_Config2__Status__c == 'Activated' && order.Apttus_Config2__Source__c == 'Quote'){
					orderIdsList.add(order.Id);
					proposalListId.add(order.Apttus_QPConfig__ProposalId__c);
					agreementListIds.add(order.Apttus_CMConfig__AgreementId__c);
				}
			}
			
			List<Apttus_Proposal__Proposal__c> prop=[select Id,Apttus_QPConfig__ABOType__c, APTS_Is_Trial_Quote__c
			from Apttus_Proposal__Proposal__c where Id in: proposalListId and Apttus_QPConfig__ABOType__c ='Renewal' and  APTS_Is_Trial_Quote__c=true with security_enforced];
			system.debug('A: prop '+prop.size());
			if(prop.size()>0){
				
			}
			List<Apttus_Config2__AssetLineItem__c> assetLineItem=[select Id,Name,APTS_Trial__c, APTS_Manual_Renewal__c,Apttus_QPConfig__ProposalId__c,APTS_Parent_Agreement__c
			from Apttus_Config2__AssetLineItem__c 
			where Apttus_QPConfig__ProposalId__c in:proposalListId 
			and Apttus_Config2__ParentBundleNumber__c=null];
			
			List<Apttus_Config2__OrderLineItem__c> orderLineItemList = new List<Apttus_Config2__OrderLineItem__c> ([Select Id, Apttus_Config2__AssetLineItemId__c,Apttus_Config2__OrderId__c,
			Apttus_Config2__LineType__c,Apttus_Config2__AssetLineItemId__r.APTS_Trial__c,
			Apttus_Config2__AssetLineItemId__r.APTS_Manual_Renewal__c,Apttus_Config2__ParentBundleNumber__c,
			Apttus_Config2__LineStatus__c,Apttus_Config2__EndDate__c
			from Apttus_Config2__OrderLineItem__c 
			where Apttus_Config2__OrderId__c in :orderIdsList
			and Apttus_Config2__LineType__c='Product/Service'
			and Apttus_Config2__ParentBundleNumber__c=null
			and Apttus_Config2__LineStatus__c='Renewed'
			and Apttus_Config2__AssetLineItemId__c!=null]);
			system.debug('A: orderLineItemList '+orderLineItemList.size()); 
			if(orderLineItemList.size()>0){
				for(Apttus_Config2__OrderLineItem__c orderLine:orderLineItemList){
					assetLineIdList.add(orderLine.Apttus_Config2__AssetLineItemId__c);
					orderLineAssetLineMap.put(orderLine.Id,orderLine.Apttus_Config2__AssetLineItemId__c);
				}  
			}
			system.debug('A: assetLineItem '+assetLineItem.size());             
			if(assetLineItem.size()>0){
				for(Apttus_Config2__AssetLineItem__c asset:assetLineItem){
					if(assetLineIdList.contains(asset.Id)){
						assetLineItemMap.put(asset.Id,asset);
					}
				}
			}
			system.debug('A: orderLineItemList.size() '+orderLineItemList.size());
			if(orderLineItemList.size()>0){
				for(Apttus_Config2__OrderLineItem__c oli:orderLineItemList){
					Apttus_Config2__AssetLineItem__c aliRecord=orderLineAssetLineMap.get(oli.Id)!=null?assetLineItemMap.get(orderLineAssetLineMap.get(oli.Id)):null;
					system.debug('A: aliRecord '+aliRecord);
					if(aliRecord!=null && aliRecord.APTS_Manual_Renewal__c==true && aliRecord.APTS_Trial__c==true){
						oliEnddateAgreementMap.put(aliRecord.APTS_Parent_Agreement__c,oli.Apttus_Config2__EndDate__c);
					}
				}
			}
			system.debug('A: oliEnddateAgreementMap.Keyset().size() '+oliEnddateAgreementMap.Keyset().size());
			if(oliEnddateAgreementMap.Keyset().size()>0){
				agrList=[select Id,Apttus__Contract_End_Date__c from Apttus__APTS_Agreement__c where id in :oliEnddateAgreementMap.Keyset() with security_enforced];
			}
			
			if(agrList.size()>0){
				for(Apttus__APTS_Agreement__c agr:agrList){
					system.debug('A: updtae '+oliEnddateAgreementMap.get(agr.Id));
					agr.Apttus__Contract_End_Date__c=oliEnddateAgreementMap.get(agr.Id);
				}
				
				database.update(agrList);
			}
		}catch(Exception e){
			system.debug('Exception from order updateEndDate '+e.getMessage()+ ' at '+e.getLineNumber());
		}
	}
	
	public static void autoConvertTrialUseCase(List<Apttus_Config2__Order__c> newList, Map<Id,Apttus_Config2__Order__c> oldMap){
		try {
			List<Id> orderIdsList=new List<Id>();
			List<Id> agreementListIds=new List<Id>();
			List<Apttus__APTS_Agreement__c> agreementList=new List<Apttus__APTS_Agreement__c>();
			List<Apttus_Config2__OrderLineItem__c> orderLineItemList;
			List<Apttus__APTS_Agreement__c> agrList=new List<Apttus__APTS_Agreement__c>();
			List<Id> trialAgreementList=new List<Id>();
			Map<Id,date> agrIdList=new Map<Id,date>();
			List<Id> agrIdRenewManualRenewalList=new List<Id>();
			List<Apttus__APTS_Agreement__c> agreementListoUpdate=new List<Apttus__APTS_Agreement__c>();
			for(Apttus_Config2__Order__c order : newList)
			{
				//order.Apttus_Config2__Status__c != oldMap.get(order.Id).Apttus_Config2__Status__c &&
				if( order.Apttus_Config2__Status__c == 'Activated' && order.Apttus_Config2__Source__c == 'Agreement'){
					orderIdsList.add(order.Id);
					agreementListIds.add(order.Apttus_CMConfig__AgreementId__c);
				}
				
			}
			if(!agreementListIds.isEmpty()){
				agreementList=[select Id,Apttus_CMConfig__ABOType__c, Apttus_CMConfig__IsSystemGenerated__c,APTS_is_Trial__c from Apttus__APTS_Agreement__c 
				where Id in: agreementListIds and Apttus_CMConfig__IsSystemGenerated__c = true and (Apttus_CMConfig__ABOType__c = 'Renewal' OR Apttus_CMConfig__ABOType__c = 'Manual Renewal')
				WITH SECURITY_ENFORCED]; 
			}
			
			if(!agreementList.isEmpty()){
				for(Apttus__APTS_Agreement__c agr:agreementList){
					agrIdRenewManualRenewalList.add(agr.Id);
				}
				if(!agrIdRenewManualRenewalList.isEmpty()){
					orderLineItemList = new List<Apttus_Config2__OrderLineItem__c> ([Select Id, Apttus_Config2__AssetLineItemId__c,Apttus_Config2__OrderId__c,
					Apttus_Config2__LineType__c,Apttus_Config2__AssetLineItemId__r.APTS_Trial__c,
					Apttus_Config2__AssetLineItemId__r.APTS_Manual_Renewal__c,Apttus_Config2__ParentBundleNumber__c,
					Apttus_Config2__LineStatus__c,Apttus_Config2__EndDate__c
					from Apttus_Config2__OrderLineItem__c 
					where Apttus_Config2__OrderId__c in :orderIdsList
					and Apttus_Config2__LineType__c='Product/Service'
					and Apttus_Config2__ParentBundleNumber__c=null
					and Apttus_CMConfig__AgreementId__c in :agrIdRenewManualRenewalList
					with security_enforced]);
				}
				
				
				for(Apttus__APTS_Agreement__c agr :agreementList){
					if(agr.Apttus_CMConfig__ABOType__c == 'Manual Renewal' && agr.APTS_is_Trial__c ==True){
						trialAgreementList.add(agr.Id);
					}
				}
				
				
			}
			if(!orderLineItemList.isEmpty()){
				for(Apttus_Config2__OrderLineItem__c oli:orderLineItemList){
					agrIdList.put(oli.Apttus_Config2__AssetLineItemId__r.APTS_Parent_Agreement__c,oli.Apttus_Config2__EndDate__c);
				}
			}
			
			if(!agrIdList.isEmpty()){
				agreementListoUpdate=[select Id,APTS_is_Trial__c,Apttus__Contract_End_Date__c from Apttus__APTS_Agreement__c where id in:agrIdList.keySet() with security_enforced];
			}
			
			if(!agreementListoUpdate.isEmpty()){
				for(Apttus__APTS_Agreement__c agr:agreementListoUpdate){
					if(trialAgreementList.contains(agr.Id)){
						agr.APTS_is_Trial__c=False;
					}
					agr.Apttus__Contract_End_Date__c=agrIdList.get(agr.Id);
				}
			}
			
			Database.update(agreementListoUpdate, accessLevel.SYSTEM_MODE);
			
		} catch (Exception e) {
			System.debug('Exception from auto convrt trial '+e.getMessage()+' at '+e.getLineNumber());
		}
	}
	
	
}