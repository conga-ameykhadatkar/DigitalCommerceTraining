/**
* @Name: APTS_DCProposalToOrderLifecycleBatch
* @Author (Creator): Amey Khadatkar (CONGA)
* @CreateDate: 15-3-24
* @Description: Batch for proposal to asset lifecycle for Digital Commerce implementation
-----------------------------------------------------------------------------------------------
**/

public with sharing class APTS_DCProposalToOrderLifecycleBatch implements Queueable {
	public List<Apttus_Proposal__Proposal__c> proposals;
	public string productAgreementRecordTypeId;

	public APTS_DCProposalToOrderLifecycleBatch(List<Apttus_Proposal__Proposal__c> proposalsToProcess) {
		this.proposals = proposalsToProcess;
		this.productAgreementRecordTypeId = SObjectType.Apttus__APTS_Agreement__c.getRecordTypeInfosByDeveloperName().get(APTS_Constants.AGMT_RECTYPE_PRODUCTAGREEMENT).getRecordTypeId();
	}

	// public List<Apttus_Proposal__Proposal__c> start(Database.BatchableContext context) {
	// 	return proposals;
	// }
	// public void execute(Database.BatchableContext context, List<Apttus_Proposal__Proposal__c> proposals) {
	public void execute(QueueableContext context) {
		try {
			for (Apttus_Proposal__Proposal__c proposal : proposals) {
				// Create Agreement
				Apttus__APTS_Agreement__c agreement = CreateAgreementWithLineItems(proposal);
				// Update Agreement Status Category and Status
				// Create Order
				CreateOrder(agreement);
				// Activate Order
			}
		} catch (Exception e) {
			System.debug('Exception while calling Contract Item Creation' + e.getStackTraceString());
		}
	}

	private Apttus__APTS_Agreement__c CreateAgreementWithLineItems(Apttus_Proposal__Proposal__c proposal) {
		
		return agreement;
	}

	private void ActivateAgreement(Apttus__APTS_Agreement__c agreement) {
		agreement.Apttus__Status_Category__c = 'In Effect';
		agreement.Apttus__Status__c = 'Activated';
		update agreement;
	}

	private void CreateOrder(Apttus__APTS_Agreement__c agreement) {
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

		List<Apttus__AgreementLineItem__c> alis = [
			SELECT Id, Name, Apttus__ProductId__c, Apttus_CMConfig__SellingTerm__c, Apttus__Quantity__c, Apttus_CMConfig__StartDate__c, Apttus_CMConfig__EndDate__c
			FROM Apttus__AgreementLineItem__c
			WHERE Apttus__AgreementId__c = :agreement.Id
		];

		for (Apttus__AgreementLineItem__c ali : alis) {
			Apttus_CPQApi.CPQ.SelectedProductDO productDO = new Apttus_CPQApi.CPQ.SelectedProductDO();
			// productDO.Comments = 'Test Create Order API';
			productDO.StartDate = ali.Apttus_CMConfig__StartDate__c;
			productDO.EndDate = ali.Apttus_CMConfig__EndDate__c;
			productDO.SellingTerm = ali.Apttus_CMConfig__SellingTerm__c;
			productDO.Quantity = ali.Apttus__Quantity__c;
			productDO.ProductId = ali.Apttus__ProductId__c;
			productDO.SourceId = ali.Id;
			productDO.CopyBundleConfigurationFromSource = true;

			request.OrderItems.add(productDO);
		}

		// create order
		Apttus_CPQApi.CPQ.CreateOrderResponseDO result = Apttus_CPQApi.CPQWebService.createOrder(request);
	}
}
