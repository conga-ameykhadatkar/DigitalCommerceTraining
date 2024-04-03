/**
* @Name: APTS_QuoteProposalTriggerHelper
* @Author(Creator) : Avani Badheka (Conga)
* @CreateDate: 12/Feb/2024
* @Description: Triggerhelper for proposal Trigger.
-----------------------------------------------------------------------------------------------
**/
public with sharing class APTS_QuoteProposalTriggerHelper {
	/**
    * @Author(Creator) : Avani 
    * @CreateDate: 12/Feb/2024
    * @Description: This is for defaulting the fields for Auto Activate Order  and end date
    * @Event : Before Insert, Before Update
    -----------------------------------------------------------------------------------------------
    **/
	public static string currencyISOCodeValue;
	public static void defaultingFields(List<Apttus_Proposal__Proposal__c> newList, Map<Id, Apttus_Proposal__Proposal__c> oldMap, boolean isInsert) {
		try {
			//Logic for before insert
			if (isInsert == true) {
				System.debug('insert logic');
				for (Apttus_Proposal__Proposal__c proposal : newList) {
					if (proposal.APTS_Is_Trial_Quote__c == false) {
						proposalFieldUpdate(proposal, isInsert);
					}
				}
			}
			//Logic for before update
			if (isInsert == false) {
				system.debug('A: before Update');
				List<APTS_Nearmap_Subscription_Setting__c> nearMapCustomSetting = APTS_Nearmap_Subscription_Setting__c.getall().values();
				for (Apttus_Proposal__Proposal__c proposal : newList) {
					Apttus_Proposal__Proposal__c oldProposal = oldMap.get(proposal.Id);
					if (proposal.Apttus_Proposal__Approval_Stage__c == 'Accepted' && proposal.APTS_Auto_Convert_Trial__c != oldProposal.APTS_Auto_Convert_Trial__c) {
						proposal.addError('Cannot Modify Auto Convert Trial Flag after a Quote is Accepted');
					}

					// if(proposal.APTS_Is_Trial_Quote__c!=oldProposal.APTS_Is_Trial_Quote__c){
					system.debug('A: calling update for trial');
					proposalFieldUpdate(proposal, isInsert);
					// }
				}
			}
		} catch (Exception ex) {
			System.debug('Exception Occurred-->' + ex.getMessage() + 'at Line-->' + ex.getLineNumber());
		}
	}

	public static void proposalFieldUpdate(Apttus_Proposal__Proposal__c proposal, boolean isInsert) {
		APTS_Nearmap_Subscription_Setting__c subscriptionValue = new APTS_Nearmap_Subscription_Setting__c();
		if (proposal.APTS_Is_Trial_Quote__c == true) {
			currencyISOCodeValue = proposal.CurrencyIsoCode;
			subscriptionValue = APTS_Nearmap_Subscription_Setting__c.getValues(currencyISOCodeValue);
			system.debug('A: subscriptionValue' + subscriptionValue);
			system.debug('A: currencyISOCodeValue ' + currencyISOCodeValue + ' subscriptionValue ' + subscriptionValue);
			if (subscriptionValue != null) {
				proposal.Apttus_QPConfig__AutoActivateOrder__c = subscriptionValue.APTS_Auto_Activate_Free_Trial__c;
				if (proposal.Apttus_Proposal__ExpectedEndDate__c != proposal.Apttus_Proposal__ExpectedStartDate__c.addDays(Integer.valueOf(subscriptionValue.APTS_Free_Trial_Period__c)) && proposal.Apttus_Proposal__ExpectedEndDate__c != null) {
					proposal.Apttus_Proposal__ExpectedEndDate__c = proposal.Apttus_Proposal__ExpectedEndDate__c;
				} else {
					proposal.Apttus_Proposal__ExpectedEndDate__c = proposal.Apttus_Proposal__ExpectedStartDate__c != null ? proposal.Apttus_Proposal__ExpectedStartDate__c.addDays(Integer.valueOf(subscriptionValue.APTS_Free_Trial_Period__c)) : null;
				}

				system.debug('A: proposal.Apttus_Proposal__ExpectedEndDate__c ' + proposal.Apttus_Proposal__ExpectedEndDate__c);
				//GM: Confirm with Ankur as we already added below 2 lines of code for making it to Off
				//proposal.APTS_Auto_Renewal__c='No Change';
			}

			if (isInsert == false) {
				proposal.APTS_Auto_Renewal__c = 'Off';
			}
		} else if (proposal.APTS_Is_Trial_Quote__c == false) {
			if (isInsert == false && subscriptionValue != null) {
				proposal.Apttus_QPConfig__AutoActivateOrder__c = subscriptionValue.APTS_Auto_Activate_Free_Trial__c;
				proposal.APTS_Auto_Renewal__c = 'On';
			} else if (isInsert == true) {
				proposal.Apttus_Proposal__ExpectedStartDate__c = Date.today();

				if (subscriptionValue != null) {
					proposal.Apttus_QPConfig__AutoActivateOrder__c = subscriptionValue.APTS_Auto_Activate_Order__c;
				}
			}
			proposal.Apttus_Proposal__ExpectedEndDate__c = proposal.Apttus_Proposal__ExpectedStartDate__c != null ? (proposal.Apttus_Proposal__ExpectedStartDate__c.addMonths(12)) - 1 : null;
		}
	}

	/**
    * @Author(Creator) : Avani 
    * @CreateDate: 13/Feb/2024
    * @Description: This method is calling Apttus_CpqApi.CPQWebService.updatePriceForCart and Apttus_CPQApi.CPQWebService.finalizeCart when flag value is changing
    * @Event : After update
    -----------------------------------------------------------------------------------------------
    **/
	public static void updatePricingOnFlagChange(List<Apttus_Proposal__Proposal__c> newList, Map<Id, Apttus_Proposal__Proposal__c> oldMap) {
		// try{
		system.debug('A: calling 1');
		List<Id> proposalIds = new List<Id>();
		Apttus_Proposal__Proposal__c proposalToProcess;
		if (newList.size() == 1) {
			for (Apttus_Proposal__Proposal__c proposal : newList) {
				Apttus_Proposal__Proposal__c oldProposal = oldMap.get(proposal.Id);
				if (proposal.APTS_Is_Trial_Quote__c != oldProposal.APTS_Is_Trial_Quote__c || (proposal.APTS_Auto_Renewal__c != oldProposal.APTS_Auto_Renewal__c && proposal.APTS_Is_Trial_Quote__c == false)) {
					proposalToProcess = proposal;
				}
			}
			system.debug('A: proposal : ' + proposalToProcess);
			if (proposalToProcess != null) {
				getLineItemandProdConfig(proposalToProcess);
			}
		}

		// }
		// catch(Exception ex){
		//     System.debug('Exception Occurred-->'+ex.getMessage()+'at Line-->'+ex.getLineNumber());
		// }
	}
	//inline method calling from updatePricingOnFlagChange to fetch line item and product config
	public static void getLineItemandProdConfig(Apttus_Proposal__Proposal__c proposalToProcess) {
		system.debug('A: calling 2');
		List<Apttus_Config2__LineItem__c> lstLineItems = new List<Apttus_Config2__LineItem__c>();
		List<Apttus_Config2__ProductConfiguration__c> prodConfigList = new List<Apttus_Config2__ProductConfiguration__c>();
		List<Apttus_Config2__LineItem__c> lstLineItemsUpdate = new List<Apttus_Config2__LineItem__c>();
		try {
			if (proposalToProcess != null) {
				lstLineItems = [
					SELECT
						ID,
						name,
						Apttus_Config2__StartDate__c,
						Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c,
						Apttus_Config2__ConfigurationId__r.Apttus_Config2__Status__c,
						Apttus_Config2__PricingStatus__c,
						Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.name
					FROM Apttus_Config2__LineItem__c
					WHERE Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c = :proposalToProcess.Id AND Apttus_Config2__ConfigurationId__r.Apttus_Config2__Status__c = :APTS_Constants.FINALIZED
					WITH SECURITY_ENFORCED
				];

				prodConfigList = [
					SELECT Id, Apttus_QPConfig__Proposald__c, Apttus_QPConfig__Proposald__r.name, Apttus_Config2__Status__c, Apttus_QPConfig__Proposald__r.Apttus_QPConfig__UseType__c, Name
					FROM Apttus_Config2__ProductConfiguration__c
					WHERE Apttus_QPConfig__Proposald__c = :proposalToProcess.Id
					WITH SECURITY_ENFORCED
					ORDER BY CreatedDate DESC
				];

				if (!lstLineItems.isEmpty()) {
					system.debug('A: lstLineItems' + lstLineItems.size());
					for (Apttus_Config2__LineItem__c line : lstLineItems) {
						line.Apttus_Config2__PricingStatus__c = APTS_Constants.PENDING;
						lstLineItemsUpdate.add(line);
					}
				}

				if (!lstLineItemsUpdate.isEmpty()) {
					system.debug('A: lstLineItemsUpdate ' + lstLineItemsUpdate);
					//Database.SaveResult[] srList = Database.update(lstLineItemsUpdate, false);
					update lstLineItemsUpdate;
					/* for (Database.SaveResult sr : srList) {
                                if (sr.isSuccess()) {
                                    // Operation was successful, so get the ID of the record that was processed
                                    System.debug('Successfully updated line item. : ' + sr.getId());
                                }
                                else {
                                    // Operation failed, so get all errors                
                                    for(Database.Error err : sr.getErrors()) {
                                        System.debug('The following error has occurred.');                    
                                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                                        System.debug('Account fields that affected this error: ' + err.getFields());
                                    }
                                }
                                system.debug('A: line update');
                            }*/
					system.debug('A: prodConfigList ' + prodConfigList);
					system.debug('A: calling 3');
					for (Apttus_Config2__LineItem__c line : lstLineItemsUpdate) {
						system.debug('A: line status after update ' + line.Apttus_Config2__PricingStatus__c + ' for ' + line.Name);
					}
					if (!prodConfigList.isEmpty()) {
						//Update pricing cart logic start
						updatePricingAndFinalizeCart(prodConfigList[0].ID);
						//update pricing cart logic end
					}
				}
			}
		} catch (Exception ex) {
			System.debug('Exception Occurred-->' + ex.getMessage() + 'at Line-->' + ex.getLineNumber());
		}
	}
	//inline method calling from updatePricingOnFlagChange to call updatePricing and finalizeCart
	public static void updatePricingAndFinalizeCart(Id cartIdReference) {
		// try {
		system.debug('A: calling 4');
		boolean hasPendingItems = false;
		// create the update price request
		Apttus_CpqApi.CPQ.UpdatePriceRequestDO objUpdatePriceRequestDO = new Apttus_CpqApi.CPQ.UpdatePriceRequestDO();
		// add request parameters
		objUpdatePriceRequestDO.CartId = cartIdReference;
		system.debug('A: objUpdatePriceRequestDO.CartId' + objUpdatePriceRequestDO.CartId);
		// update price for the cart
		Apttus_CpqApi.CPQ.UpdatePriceResponseDO result = Apttus_CpqApi.CPQWebService.updatePriceForCart(objUpdatePriceRequestDO);
		hasPendingItems = result.IsPricePending;
		system.debug('A: hasPendingItems ' + hasPendingItems);
		if (hasPendingItems == false) {
			// create the finalize cart request
			Apttus_CpqApi.CPQ.FinalizeCartRequestDO request = new Apttus_CpqApi.CPQ.FinalizeCartRequestDO();
			// add request parameters
			request.CartId = cartIdReference;
			// finalize the cart
			Apttus_CpqApi.CPQ.FinalizeCartResponseDO response = Apttus_CpqApi.CPQWebService.finalizeCart(request);
		}
		//} catch (Exception ex) {
		//    System.debug('Exception Occurred pricing update -->'+ex.getMessage()+'at Line-->'+ex.getLineNumber());
		//}
	}

	/**
                    * @Author(Creator) : Avani Badheka
                    * @CreateDate: 15/Feb/2024
                    * @Description: QTE-010 This method is checking payment method validation
                    * @Event :  Before Update
                    -----------------------------------------------------------------------------------------------
                    **/
	public static void paymentMethodValidation(List<Apttus_Proposal__Proposal__c> newList, Map<Id, Apttus_Proposal__Proposal__c> oldMap) {
		try {
			List<Id> proposalList = new List<Id>();
			Map<Id, boolean> proposalOrderCheck = new Map<Id, Boolean>();
			Map<Id, string> proposalWithAgreementPaymentMethod = new Map<Id, string>();
			for (Apttus_Proposal__Proposal__c prop : newList) {
				Apttus_Proposal__Proposal__c oldProp = oldMap.get(prop.Id);
				if (oldProp.APTS_Payment_Method__c != prop.APTS_Payment_Method__c && prop.APTS_Payment_Method__c != null && prop.APTS_Is_Trial_Quote__c == true) {
					proposalList.add(prop.Id);
					proposalWithAgreementPaymentMethod.put(prop.Id, prop.APTS_Payment_Method__c);
				}
			}

			if (!proposalList.isEmpty()) {
				List<Apttus_Config2__Order__c> orderRecord = new List<Apttus_Config2__Order__c>();
				orderRecord = [
					SELECT Id, Apttus_QPConfig__ProposalId__c, Apttus_Config2__Source__c, Apttus_CMConfig__AgreementId__r.APTS_Payment_Method__c, Apttus_CMConfig__AgreementId__r.APTS_is_Trial__c
					FROM Apttus_Config2__Order__c
					WHERE Apttus_QPConfig__ProposalId__c IN :proposalList
					WITH SECURITY_ENFORCED
				];
				if (orderRecord.size() > 0) {
					for (Apttus_Config2__Order__c order : orderRecord) {
						if (
							order.Apttus_Config2__Source__c == 'Agreement' &&
							proposalWithAgreementPaymentMethod.get(order.Apttus_QPConfig__ProposalId__c) != null &&
							order.Apttus_CMConfig__AgreementId__r.APTS_Payment_Method__c == proposalWithAgreementPaymentMethod.get(order.Apttus_QPConfig__ProposalId__c) &&
							order.Apttus_CMConfig__AgreementId__r.APTS_is_Trial__c == true
						) {
							proposalOrderCheck.put(order.Apttus_QPConfig__ProposalId__c, true);
						}
					}
				}

				for (Apttus_Proposal__Proposal__c prop : newList) {
					if (proposalOrderCheck.containsKey(prop.id)) {
						prop.addError('There is a Trial Order or Trial Subscription using the same Payment Method. Please select a different Payment Method to proceed<TBC>');
					}
				}
			}
		} catch (Exception ex) {
			System.debug('Exception Occurred-->' + ex.getMessage() + 'at Line-->' + ex.getLineNumber());
		}
	}

	/**
                    * @Author(Creator) : Avani Badheka
                    * @CreateDate: 8/March/2024
                    * @Description: QTE-003 This method is used in logic to update the end date 
                    * @Event :  After Update
                    -----------------------------------------------------------------------------------------------
                    **/
	public static void autoConvertTrialCartFinalize(List<Apttus_Proposal__Proposal__c> newList, Map<Id, Apttus_Proposal__Proposal__c> oldMap) {
		try {
			Apttus_Proposal__Proposal__c proposal = new Apttus_Proposal__Proposal__c();
			Apttus_Config2__ProductConfiguration__c proConfig = new Apttus_Config2__ProductConfiguration__c();
			if (newList.size() == 1) {
				for (Apttus_Proposal__Proposal__c prop : newList) {
					if (prop.APTS_Auto_Convert_Trial__c != oldMap.get(prop.Id).APTS_Auto_Convert_Trial__c) {
						proposal = prop;
					}
				}
				if (proposal != null) {
					proConfig = [
						SELECT Id, Apttus_Config2__Status__c
						FROM Apttus_Config2__ProductConfiguration__c
						WHERE Apttus_QPConfig__Proposald__c = :proConfig.Id AND Apttus_Config2__Status__c = :APTS_Constants.FINALIZED
						WITH security_enforced
						ORDER BY CreatedDate DESC
						LIMIT 1
					];
				}
				if (proConfig != null) {
					// create the finalize cart request
					Apttus_CpqApi.CPQ.FinalizeCartRequestDO request = new Apttus_CpqApi.CPQ.FinalizeCartRequestDO();
					// add request parameters
					request.CartId = proConfig.Id;
					// finalize the cart
					Apttus_CpqApi.CPQ.FinalizeCartResponseDO response = Apttus_CpqApi.CPQWebService.finalizeCart(request);
				}
			}
		} catch (Exception e) {
			System.debug('Exception from auto convert trial proposal trigger ' + e.getMessage() + ' at ' + e.getLineNumber());
		}
	}

	public static void CreateAgreementForEcommerce(List<Apttus_Proposal__Proposal__c> newList, Map<Id, Apttus_Proposal__Proposal__c> oldMap) {
		List<Apttus_Proposal__Proposal__c> proposalsToProcess = new List<Apttus_Proposal__Proposal__c>();
		string productAgreementRecordTypeId = SObjectType.Apttus__APTS_Agreement__c.getRecordTypeInfosByDeveloperName().get(APTS_Constants.AGMT_RECTYPE_PRODUCTAGREEMENT).getRecordTypeId();
		List<Apttus__APTS_Agreement__c>  = new List<Apttus__APTS_Agreement__c>();
		for (Apttus_Proposal__Proposal__c proposal : newList) {
			if (oldMap.containsKey(proposal.Id)) {
				Apttus_Proposal__Proposal__c oldProposal = oldMap.get(proposal.Id);
				if (
					proposal.Apttus_QPConfig__SourceChannel__c == APTS_Constants.QUOTE_SRC_CHANNEL_DC &&
					oldProposal.Apttus_Proposal__Approval_Stage__c != proposal.Apttus_Proposal__Approval_Stage__c &&
					proposal.Apttus_Proposal__Approval_Stage__c == APTS_Constants.QUOTE_APSTG_ACCEPTED
				) {
					Apttus__APTS_Agreement__c agreement = Apttus_QPComply.QPComplyWebService.createAgreementFromProposal(proposal.Id, productAgreementRecordTypeId, true);
					Apttus_QPComply.QPComplyWebService.copyProductConfiguration(proposal.Id, agreement.Id);
					agreement.Apttus__Status_Category__c = 'In Effect';
					agreement.Apttus__Status__c = 'Activated';
					agreement.Apttus_CMConfig__AutoActivateOrder__c = true;
					agreementsToUpdate.add(agreementsToUpdate);
				}
			}
		}
		udpate agreementsToUpdate;
		for(Apttus__APTS_Agreement__c agr: agreementsToUpdate){
			CreateOrder(agreement);
		}
	}

	public static void CreateOrder(Apttus__APTS_Agreement__c agreement) {
		system.debug('>> Start:CreateOrder');
		Apttus_CPQApi.CPQ.CreateOrderRequestDO request = new Apttus_CPQApi.CPQ.CreateOrderRequestDO();

		// order item source
		request.OrderItemSource = Apttus_CPQApi.CPQ.ITEMSOURCE_AGREEMENT_LINEITEM;

		// create order input
		Apttus_Config2__Order__c inputSO = new Apttus_Config2__Order__c();

		inputSO.Apttus_Config2__SoldToAccountId__c = agreement.Apttus__Account__c;
		inputSO.Apttus_Config2__PriceListId__c = agreement.Apttus_CMConfig__PriceListId__c;
		inputSO.Apttus_Config2__PricingDate__c = Datetime.now();
		inputSO.Apttus_Config2__OrderDate__c = Datetime.now();
		inputSO.Apttus_Config2__AutoActivateOrder__c = true;
		inputSO.Apttus_Config2__ActivatedDate__c = Datetime.now();
		inputSO.Apttus_Config2__OrderStartDate__c = Date.today();
		inputSO.Apttus_Config2__OrderEndDate__c = Date.today().addMonths(12);
		inputSO.Apttus_CMConfig__AgreementId__c = agreement.Id;
		InputSO.Apttus_Config2__Source__c = 'Agreement';
		request.Properties.add(new Apttus_Config2.Property('isCopyMode', 'true'));
		request.OrderInput = inputSO;
		system.debug('>> Query:Get ALIs');
		List<Apttus__AgreementLineItem__c> alis = [
			SELECT
				Id,
				Name,
				Apttus__ProductId__c,
				Apttus_CMConfig__BillingPreferenceId__c,
				Apttus_CMConfig__SellingTerm__c,
				Apttus__Quantity__c,
				Apttus_CMConfig__StartDate__c,
				Apttus_CMConfig__EndDate__c,
				Apttus_CMConfig__AttributeValueId__r.APTS_Users__c,
				Apttus_CMConfig__AttributeValueId__r.APTS_Area__c,
				Apttus_CMConfig__AttributeValueId__r.APTS_Channel_Type__c,
				Apttus_CMConfig__AttributeValueId__r.APTS_DWP__c,
				Apttus_CMConfig__AttributeValueId__r.APTS_Structure__c,
				Apttus_CMConfig__AttributeValueId__r.APTS_Structure_Price__c,
				Apttus_CMConfig__AttributeValueId__r.APTS_Parcels__c,
				Apttus_CMConfig__AttributeValueId__r.APTS_Content_Type__c
			FROM Apttus__AgreementLineItem__c
			WHERE Apttus__AgreementId__c = :agreement.Id
		];

		system.debug('>> Query:ALIs fetchned:' + alis.size());
		for (Apttus__AgreementLineItem__c ali : alis) {
			Apttus_CPQApi.CPQ.SelectedProductDO productDO = new Apttus_CPQApi.CPQ.SelectedProductDO();
			// productDO.Comments = 'Test Create Order API';
			// productDO.StartDate = ali.Apttus_CMConfig__StartDate__c;
			// productDO.EndDate = ali.Apttus_CMConfig__EndDate__c;
			// productDO.SellingTerm = ali.Apttus_CMConfig__SellingTerm__c;
			// productDO.Quantity = ali.Apttus__Quantity__c;
			// productDO.ProductId = ali.Apttus__ProductId__c;
			productDO.SourceId = ali.Id;
			productDO.CopyBundleConfigurationFromSource = true;
			productDO.CustomData = new Apttus_Config2__LineItem__c();

			productDO.CustomData.Apttus_Config2__BillingPreferenceId__c = ali.Apttus_CMConfig__BillingPreferenceId__c;

			// List<Apttus_Config2__ProductAttributeValue__c> attibuteValues = new List<Apttus_Config2__ProductAttributeValue__c>();
			// Apttus_Config2__ProductAttributeValue__c attrValue = new Apttus_Config2__ProductAttributeValue__c();
			// attrValue.APTS_Channel_Type__c = ali.Apttus_CMConfig__AttributeValueId__r.APTS_Channel_Type__c;
			// attrValue.APTS_Select_Platform__c = ali.Apttus_CMConfig__AttributeValueId__r.APTS_Select_Platform__c;
			// attrValue.APTS_Users__c = ali.Apttus_CMConfig__AttributeValueId__r.APTS_Users__c;
			// attrValue.APTS_Area__c = ali.Apttus_CMConfig__AttributeValueId__r.APTS_Area__c;
			// // attrValue.APTS_Vertical__c = ali.Apttus_CMConfig__AttributeValueId__r.APTS_Vertical__c;
			// attrValue.APTS_Parcels__c = ali.Apttus_CMConfig__AttributeValueId__r.APTS_Parcels__c;
			// attrValue.APTS_DWP__c = ali.Apttus_CMConfig__AttributeValueId__r.APTS_DWP__c;

			// attibuteValues.add(attrValue);
			// productDO.AttributeValues = attibuteValues;

			request.OrderItems.add(productDO);
		}

		system.debug('>> API call:Create Order');
		// create order
		Apttus_CPQApi.CPQ.CreateOrderResponseDO result = Apttus_CPQApi.CPQWebService.createOrder(request);
		system.debug('>> END:CreateOrder');
	}
}