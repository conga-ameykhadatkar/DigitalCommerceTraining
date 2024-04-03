/*
*********************************************************
Apex Class Name    : APTS_TestDataFactory
Created Date       : Feb 26, 2024
@description       : This is class is used for generating test data
@author            : Avani Badheka
Modification Log:
Ver   Date         Author                               Modification
1.0   

*********************************************************
*/
@isTest
public with sharing class APTS_TestDataFactory {
public static final String STREET = 'street name';
    public static final String CITY = 'City';
    public static final String STATE = 'State';
    public static final String COUNTRY = 'Australia';
    public static final String POSTALCODE = 'Postal';
    public static final String CURRENCYISOCODE = 'USD';
    public static final String SYS_PRO_LABEL = 'System Properties';
    public static final String PRICING_CALLBACK_LABEL = 'APTS_PricingCallBack';
    public static final String instanceurl = Url.getOrgDomainUrl().toExternalForm();
    public static Apttus_Proposal__ProposalSystemProperties__c objProposalSystemProperty;
    public static Apttus_Config2__ConfigLineItemCustomFields__c objConfigLineItemCustomField1;
    public static Apttus_Config2__ConfigCustomClasses__c objConfigCustomClass;
    private static Integer primaryLineNumber = 1;
    public static ID cartID;
    public static List < string > listLineItemCustomFields = new List < string > {
        'APTS_NetTransferPrice__c','APTS_LeaseContractPrice__c','APTS_DiscountedPriceBasedOnCompass__c','Apttus_Config2__NetPrice__c','Apttus_Config2__Cost__c','APTS_InterfaceAllowance__c','APTS_CumulativeInterest__c','APTS_IsEbola__c','APTS_TestPerDay__c','APTS_DaysPerWeek__c','APTS_CustomDescription__c','APTS_Country__c','APTS_InstrumentTrainingSeats__c','Apttus_Config2__ProductId__r.APTS_RestrictDiscount__c','APTS_Product_Name__c','Apttus_Config2__OptionId__r.APTS_RestrictDiscount__c','Apttus_CQApprov__Approval_Status__c','Apttus_Config2__ConfigurationId__r.APTS_OPEX_Completed__c',
        'APTS_OpexModel__c','Apttus_Config2__AttributeValueId__r.APTS_NoChargeWarranty__c','Apttus_Config2__AttributeValueId__r.APTS_IsCustomerOwnEquipment__c','Apttus_Config2__AttributeValueId__r.APTS_ReplacementProductsXTSeries__c','Apttus_Config2__ProductId__r.Apttus_Config2__ProductType__c','Apttus_Config2__ProductId__r.Family','Apttus_Config2__OptionId__r.Apttus_Config2__ProductType__c','APTS_InstrumentWarrantyPeriod__c','APTS_NoChargeService__c','Apttus_Config2__ParentBundleNumber__c','Apttus_Config2__OptionId__r.Family','Apttus_Config2__ProductId__r.APTS_LeaseInterestCalculation__c',
        'Apttus_Config2__ProductId__r.APTS_LeaseResidual__c','Apttus_Config2__ProductId__r.Description','Apttus_Config2__OptionId__r.Description    APTS_TransferPrice__c','APTS_DistributorMargin__c','APTS_LeaseResidualRate__c','APTS_LeasePaymentByTerm__c','APTS_CumulativeInterest__c','APTS_AnnualInterestRate__c','APTS_LeaseContractPrice__c','APTS_GrossProfitPercentInstrument__c','APTS_GrossProfitPercentReagents__c','APTS_GrossProfitPercentServices__c','APTS_IsCompassEligibleLine__c','APTS_DiscountedPriceBasedOnCompass__c','APTS_CustomAdjustmentPrice__c','APTS_TermAmount__c',
        'Apttus_Config2__ProductId__r.APTS_OpexModelStr__c','Apttus_Config2__OptionId__r.APTS_OpexModelStr__c','Apttus_Config2__AttributeValueId__r.APTS_ReplacementProductsSysmex__c','Apttus_Config2__AttributeValueId__r.APTS_DaysWeek__c','Apttus_Config2__AttributeValueId__r.APTS_HemeTestPerDay__c','Apttus_Config2__PriceListItemId__r.Apttus_Config2__ListPrice__c','Apttus_Config2__ProductId__r.APTS_Training__c','Apttus_Config2__OptionId__r.APTS_Training__c','Apttus_Config2__ProductId__r.APTS_CompassEligibleInstruments__c','Apttus_Config2__OptionId__r.APTS_CompassEligibleInstruments__c',
        'Apttus_Config2__ProductId__r.Apttus_Config2__ConfigurationType__c','Apttus_Config2__OptionId__r.Apttus_Config2__ConfigurationType__c','Apttus_Config2__OptionId__r.APTS_Warranty__c','Apttus_Config2__OptionId__r.APTS_TrainingSeats__c','Apttus_Config2__OptionId__r.Name','Apttus_Config2__OptionId__r.APTS_LeaseInterestCalculation__c','Apttus_Config2__OptionId__r.APTS_LeaseResidual__c','Apttus_Config2__OptionId__r.APTS_TrainingSeats__c','Apttus_Config2__ProductId__r.APTS_TrainingSeats__c','Apttus_Config2__ProductId__r.Name','Apttus_Config2__OptionId__r.Name',
        'Apttus_Config2__ProductId__r.APTS_LegalTerms__c','Apttus_Config2__OptionId__r.APTS_LegalTerms__c','Apttus_Config2__PriceListItemId__r.APTS_FloorPrice__c','Apttus_Config2__AttributeValueId__r.APTS_ModelManufacturer__c','APTS_LocationAlias__c','APTS_LastPrice__c','APTS_AutoApplyPromotions__c','APTS_ListPrice__c','Apttus_Config2__ProductId__r.APTS_ProductPartNumber__c','Apttus_Config2__OptionId__r.APTS_ProductPartNumber__c','APTS_ProductType__c','Apttus_Config2__ProductId__r.APTS_ProductWeightage__c','Apttus_Config2__OptionId__r.APTS_ProductWeightage__c'};
    public static User getUser(){
    User u = new User(Alias = 'tuser', 
                          Email='tuser@sysmextestuser.com.test', 
                          FirstName = 'TestUser', 
                          EmailEncodingKey='UTF-8', 
                          LastName='Testing', 
                          LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', 
                          TimeZoneSidKey='America/Los_Angeles', 
                         // UserName='standarduser1234fg@testorg.com'
                          username=Math.random()+'@'+UserInfo.getOrganizationid()+'.test' );
        return u;
    }
       
    public static Apttus__APTS_Agreement__c getAgreement(){
          Apttus__APTS_Agreement__c agreement = new Apttus__APTS_Agreement__c();  
          agreement.Apttus__Contract_Start_Date__c = Date.today();
          agreement.Apttus__Contract_End_Date__c = Date.today().addDays(365);
          return agreement;
    }
    public static Apttus_Config2__ConfigLineItemCustomFields__c getConfigLineItemCustomFields(string name, string field, string field2, string field3, string field4, string field5) {
        Apttus_Config2__ConfigLineItemCustomFields__c objConfigLineItemCustomFields = new Apttus_Config2__ConfigLineItemCustomFields__c();
        objConfigLineItemCustomFields.Name = name;
        objConfigLineItemCustomFields.Apttus_Config2__CustomFieldNames__c = field;
        objConfigLineItemCustomFields.Apttus_Config2__CustomFieldNames2__c = field2;
        objConfigLineItemCustomFields.Apttus_Config2__CustomFieldNames3__c = field3;
        objConfigLineItemCustomFields.Apttus_Config2__CustomFieldNames4__c = field4;
        objConfigLineItemCustomFields.Apttus_Config2__CustomFieldNames5__c = field5;
        return objConfigLineItemCustomFields;
    }
    public static List < Apttus_Config2__ConfigLineItemCustomFields__c > getConfigLineItemCustomFieldsFinal() {
        List < Apttus_Config2__ConfigLineItemCustomFields__c > listConfigLineItemCustomFields = new List < Apttus_Config2__ConfigLineItemCustomFields__c > ();
        Integer counter = 0;
        for (string strCustonFieldName: listLineItemCustomFields) {
            listConfigLineItemCustomFields.add(getConfigLineItemCustomFields('Field' + String.valueOf(counter++), strCustonFieldName, null, null, null, null));
        }
        return listConfigLineItemCustomFields;
    }
    public static Apttus_Proposal__ProposalSystemProperties__c getProposalSystemProperty() {
        objProposalSystemProperty = new Apttus_Proposal__ProposalSystemProperties__c();
        objProposalSystemProperty.Name = SYS_PRO_LABEL;
        return objProposalSystemProperty;
    }
    public static Apttus_Config2__ConfigSystemProperties__c getConfigSystemProperties(){
        Apttus_Config2__ConfigSystemProperties__c objconfigsystemproperties = new Apttus_Config2__ConfigSystemProperties__c(
            Name = 'System Properties',
            Apttus_Config2__AdminUser__c = '',
            Apttus_Config2__AutoFinalizeOnCartApproval__c = false,
            Apttus_Config2__AutoSyncOnCartApproval__c = false,
            Apttus_Config2__CartTheme__c = 'Classic',
            Apttus_Config2__CascadeSharedAttributeUpdates__c = false,
            Apttus_Config2__ConstraintRuleExecutionMode__c = 'Client',
            Apttus_Config2__CurrencyFieldPrecision__c = 2.0,
            Apttus_Config2__CustomPricingFields__c = 'APTS_Tier__c',
            Apttus_Config2__DefaultAssetPricingIndicator__c = false,
            Apttus_Config2__DefaultProductsPage__c = 'Apttus_Config2__SelectConfigProducts',
            Apttus_Config2__DeferPricingUntilCart__c = false,
            Apttus_Config2__DeferValidationCheckInBundles__c = true,
            Apttus_Config2__DisableChargeTypeTotaling__c = true,
            Apttus_Config2__DisableConstraintRules__c = false,
            Apttus_Config2__DisableExistingAssetPricing__c = false,
            Apttus_Config2__DisablePricingQueryOptimization__c = false,
            Apttus_Config2__EnableBasePriceAdjustment__c = false,
            Apttus_Config2__EnableCartLockingForConcurrentAccess__c = false,
            Apttus_Config2__EnableContextualTotals__c = false,
            Apttus_Config2__ExpandBundleLinesByDefault__c = false,
            Apttus_Config2__FieldExpressionsExecutionMode__c = 'Client',
            Apttus_Config2__HideSubtotalsInCart__c = true,
            Apttus_Config2__InstanceUrl__c = instanceurl,
            Apttus_Config2__KeepAbandonedCarts__c = false,
            Apttus_Config2__MaxAdjustmentLines__c = 1.0,
            Apttus_Config2__MaxAllowedLinesForMassActions__c = 10.0,
            Apttus_Config2__MaxConstraintRulesRoundTrip__c = 3.0,
            Apttus_Config2__OptionPricingChunkSize__c = 100.0,
            Apttus_Config2__OptionsPageDefault__c = 'Apttus_Config2__SelectConfigOptionsDetailView',
            Apttus_Config2__PerformMassActionsInParallel__c = false,
            Apttus_Config2__PreventErrorExcludeSelection__c = false,
            Apttus_Config2__PreventErrorTypeExcludeSelection__c = false,
            Apttus_Config2__PricingBatchSize__c = 75.0,
            Apttus_Config2__PricingProfile__c = 'Advanced',
            Apttus_Config2__ProductDisplayMaxLength__c = 21.0,
            Apttus_Config2__ProductOptionPriceOrder__c = 'Last',
            Apttus_Config2__ResolveConfigurationPageDefault__c = 'Apttus_Config2__ResolveConfig',
            Apttus_Config2__RunFinalizationTaskInAsyncMode__c = false,
            Apttus_Config2__RunSecondaryFinalizationTaskInAsyncMode__c = false,
            Apttus_Config2__SaveOnAllActions__c = false,
            Apttus_Config2__SearchAttributeValuePage__c = 'Cart',
            Apttus_Config2__SearchCategoryDefault__c = 'AllCategories',
            Apttus_Config2__TotalingGroupType__c = 'Category',
            Apttus_Config2__UseButtonToSaveSelection__c = false,
            Apttus_Config2__UseEnhancedCSS__c = false,
            Apttus_Config2__ViewCartCustomFields__c = 'Apttus_Config2__ProductVersion__c,Apttus_Config2__ClassificationId__c,Apttus_Config2__ClassificationId__r.Apttus_Config2__AncestorId__r.Name');
        return objconfigsystemproperties;
    }
    public static Apttus_Config2__ConfigCustomClasses__c getConfigCustomClasses() {
        objConfigCustomClass = new Apttus_Config2__ConfigCustomClasses__c();
        objConfigCustomClass.Name = SYS_PRO_LABEL;
        objConfigCustomClass.Apttus_Config2__PricingCallbackClass__c = PRICING_CALLBACK_LABEL;
        return objConfigCustomClass;
    }
    public static Account getAccount(String name) {
        Account objAccount = new Account();
        objAccount.Name = name;
        objAccount.AccountSource='Sales';
        //objAccount.BillingStreet = STREET;
        //objAccount.BillingCity = CITY;
        //objAccount.BillingState = STATE;
        //objAccount.BillingCountry = COUNTRY;
        //objAccount.BillingPostalCode = POSTALCODE;
        //objAccount.ShippingStreet = STREET;
        //objAccount.ShippingCity = CITY;
        //objAccount.ShippingState = STATE;
        //objAccount.ShippingCountry = COUNTRY;
        //objAccount.ShippingPostalCode = POSTALCODE;
        return objAccount;
    }
    public static Opportunity getOpportunity(String Name, ID accountID) {
        Opportunity objOpportunity = new Opportunity();
        objOpportunity.Name = name;
        objOpportunity.AccountID = accountID;
        objOpportunity.StageName = 'Prospecting';
        objOpportunity.CloseDate = System.today().addMonths(1);
        objOpportunity.LeadSource='Sales';
        return objOpportunity;
    }
    
    public static Apttus_Config2__PriceList__c getPriceList(String name) {
        Apttus_Config2__PriceList__c objPriceList = new Apttus_Config2__PriceList__c();
        objPriceList.Name = name;
        objPriceList.Apttus_Config2__Active__c = TRUE;
        objPriceList.Apttus_Config2__EffectiveDate__c = System.now().addDays(-2);
        objPriceList.Apttus_Config2__ExpirationDate__c = System.now().addYears(2);
        objPriceList.CurrencyISOCode = 'USD';
        return objPriceList;
    }
    public static Apttus_Proposal__Proposal__c getProposal(Account objAccount, ID priceListID, ID opportunityID) {
        Apttus_Proposal__Proposal__c objProposal = new Apttus_Proposal__Proposal__c();
        objProposal.Apttus_Proposal__Account__c = objAccount.ID;
        objProposal.Apttus_QPConfig__BillToAccountId__c = objAccount.ID;
        objProposal.Apttus_QPConfig__ShipToAccountId__c = objAccount.ID;
        objProposal.Apttus_QPConfig__PriceListId__c = priceListID;
        //objProposal.Apttus_QPComply__MasterAgreementId__c     = agreementID;
        //objProposal.Apttus_Proposal__RelatedProposalId__c     = proposalID;
        objProposal.Apttus_Proposal__Approval_Stage__c = 'Draft';
        objProposal.Apttus_Proposal__Payment_Term__c = 'Net 30 Days';
        objProposal.Apttus_QPConfig__AutoActivateOrder__c = TRUE;
        objProposal.Apttus_QPConfig__AutoCreateBill__c = TRUE;
        objProposal.Apttus_QPConfig__AutoCreateRevenue__c = TRUE;
        objProposal.Apttus_QPConfig__IsAutoAccepted__c = TRUE;
        objProposal.Apttus_Proposal__Primary__c = TRUE;
        objProposal.Apttus_QPConfig__IsSystemGenerated__c = FALSE;
        objProposal.Apttus_QPConfig__IsTaskPending__c = FALSE;
        objProposal.Apttus_Proposal__ExpectedEndDate__c = System.today().addYears(1).addDays(-2);
        objProposal.Apttus_Proposal__ExpectedStartDate__c = System.today().addDays(-1);
        objProposal.Apttus_Proposal__Proposal_Expiration_Date__c = System.today().addDays(30);
        objProposal.Apttus_Proposal__Valid_Until_Date__c = System.today().addDays(30);
        objProposal.Apttus_QPConfig__PONumber__c = 'XYZ123';
        objProposal.Apttus_Proposal__Presented_Date__c = System.today();
        objProposal.Apttus_QPConfig__PricingDate__c = System.today();
        objProposal.Apttus_QPConfig__ConfigurationFinalizedDate__c = System.today();
        objProposal.Apttus_QPConfig__ConfigurationSyncDate__c = System.today();
        objProposal.Apttus_Proposal__Proposal_Approval_Date__c = System.today();
        objProposal.Apttus_QPConfig__ReadyForActivationDate__c = System.today();
        objProposal.Apttus_QPConfig__ReadyForBillingDate__c = System.today();
        objProposal.Apttus_QPConfig__ReadyForFulfillmentDate__c = System.today();
        objProposal.Apttus_QPConfig__ReadyForRevRecDate__c = System.today();
      
        objProposal.CurrencyIsoCode = 'USD';
        return objProposal;
    }
    
    public static Apttus_Proposal__Proposal__c getProposal(Account objAccount, ID priceListID, ID opportunityID,ID locationId) {
        Apttus_Proposal__Proposal__c objProposal = new Apttus_Proposal__Proposal__c();
        objProposal.Apttus_Proposal__Account__c = objAccount.ID;
        objProposal.Apttus_QPConfig__BillToAccountId__c = objAccount.ID;
        objProposal.Apttus_QPConfig__ShipToAccountId__c = objAccount.ID;
        objProposal.Apttus_QPConfig__PriceListId__c = priceListID;
        //objProposal.APTS_Oppty__c = opportunityID;
        //objProposal.Apttus_QPComply__MasterAgreementId__c     = agreementID;
        //objProposal.Apttus_Proposal__RelatedProposalId__c     = proposalID;
        objProposal.Apttus_Proposal__Approval_Stage__c = 'Draft';
        objProposal.Apttus_Proposal__Payment_Term__c = 'Net 30 Days';
        objProposal.Apttus_QPConfig__AutoActivateOrder__c = TRUE;
        objProposal.Apttus_QPConfig__AutoCreateBill__c = TRUE;
        objProposal.Apttus_QPConfig__AutoCreateRevenue__c = TRUE;
        objProposal.Apttus_QPConfig__IsAutoAccepted__c = TRUE;
        objProposal.Apttus_Proposal__Primary__c = TRUE;
        objProposal.Apttus_QPConfig__IsSystemGenerated__c = FALSE;
        objProposal.Apttus_QPConfig__IsTaskPending__c = FALSE;
        objProposal.Apttus_Proposal__ExpectedEndDate__c = System.today().addYears(1).addDays(-2);
        objProposal.Apttus_Proposal__ExpectedStartDate__c = System.today().addDays(-1);
        objProposal.Apttus_Proposal__Proposal_Expiration_Date__c = System.today().addDays(30);
        objProposal.Apttus_Proposal__Valid_Until_Date__c = System.today().addDays(30);
        objProposal.Apttus_QPConfig__PONumber__c = 'XYZ123';
        objProposal.Apttus_Proposal__Presented_Date__c = System.today();
        objProposal.Apttus_QPConfig__PricingDate__c = System.today();
        objProposal.Apttus_QPConfig__ConfigurationFinalizedDate__c = System.today();
        objProposal.Apttus_QPConfig__ConfigurationSyncDate__c = System.today();
        objProposal.Apttus_Proposal__Proposal_Approval_Date__c = System.today();
        objProposal.Apttus_QPConfig__ReadyForActivationDate__c = System.today();
        objProposal.Apttus_QPConfig__ReadyForBillingDate__c = System.today();
        objProposal.Apttus_QPConfig__ReadyForFulfillmentDate__c = System.today();
        objProposal.Apttus_QPConfig__ReadyForRevRecDate__c = System.today();
       
        objProposal.CurrencyIsoCode = 'USD';
        objProposal.Apttus_QPConfig__QTCProfile__c = 'Regular';
        objProposal.Apttus_QPConfig__LocationId__c = locationId;
        return objProposal;
    }
    public static ID getCartID(ID proposalID) {
        Apttus_CPQApi.CPQ.CreateCartRequestDO objCreateCartRequestDO = new Apttus_CPQApi.CPQ.CreateCartRequestDO();
        objCreateCartRequestDO.QuoteId = proposalID;
        Apttus_CPQApi.CPQ.CreateCartResponseDO objCreateCartResponseDO = Apttus_CPQApi.CPQWebService.createCart(objCreateCartRequestDO);
        cartID = objCreateCartResponseDO.CartId;
        return objCreateCartResponseDO.CartId;
    }
    
    public static Apttus_Config2__AccountLocation__c getAccountLocation(Id accountId){
        Apttus_Config2__AccountLocation__c  aLocation = new Apttus_Config2__AccountLocation__c ();
        aLocation.Apttus_Config2__AccountId__c = accountId;
        aLocation.Name = 'Test Location';
        return aLocation;
    }

    public static Product2 getProduct(String productCode, String productFamily, String configurationType,String productType) {
        Product2 objProduct = new Product2();
        objProduct.Name = productCode;
        objProduct.ProductCode = productCode;
        objProduct.Family = productFamily;
        objProduct.Apttus_Config2__ConfigurationType__c = configurationType; // 'Bundle','Standalone','Option'
        objProduct.Apttus_Config2__BundleInvoiceLevel__c = 'Detail';
        objProduct.Apttus_Config2__ProductType__c = productType;
        objProduct.Apttus_Config2__Uom__c = 'Each';
        objProduct.Apttus_Config2__HasAttributes__c = TRUE;
        objProduct.Apttus_Config2__HasDefaults__c = TRUE;
        objProduct.Apttus_Config2__HasOptions__c = TRUE;
        objProduct.Apttus_Config2__HasSearchAttributes__c = TRUE;
        objProduct.Apttus_Config2__Customizable__c = TRUE;
     
        return objProduct;
    }
    public static Product2 getProductSimple(String productCode) {
        Product2 objProduct = new Product2();
        objProduct.Name                                 = productCode;
        objProduct.ProductCode                          = productCode;
        objProduct.Apttus_Config2__ConfigurationType__c = 'Standalone';// 'Bundle','Standalone','Option'
        objProduct.Apttus_Config2__Uom__c               = 'Each';
        objProduct.Apttus_Config2__HasAttributes__c     = TRUE;
        objProduct.Apttus_Config2__HasDefaults__c       = FALSE;
        objProduct.Apttus_Config2__HasOptions__c            = FALSE;
        objProduct.Apttus_Config2__HasSearchAttributes__c   = FALSE;
        return objProduct;
    }
    
    public static Apttus_Config2__PriceListItem__c getPriceListItem(ID priceListID, Product2 objProduct, String chargeType, String priceType, String priceMethod, String frequency, decimal price) {

        Apttus_Config2__PriceListItem__c objPriceListItem = new Apttus_Config2__PriceListItem__c();
        objPriceListItem.Apttus_Config2__PriceListId__c = priceListID;
        objPriceListItem.Apttus_Config2__ProductId__c = objProduct.ID;
        objPriceListItem.Apttus_Config2__PriceUom__c = objProduct.Apttus_Config2__Uom__c;
        objPriceListItem.Apttus_Config2__ChargeType__c = chargeType; //'Standard Price','License Fee','Subscription Fee','Maintenance Fee'
        objPriceListItem.Apttus_Config2__PriceType__c = priceType; //'One Time','Recurring','Usage','Overage'
        objPriceListItem.Apttus_Config2__PriceMethod__c = priceMethod; //'Per Unit','Flat Price','Percentage','Related Price','Tiered Rate'
        objPriceListItem.Apttus_Config2__Frequency__c = frequency; //'One Time','Yearly','Half Yearly','Quarterly','Monthly';
        objPriceListItem.Apttus_Config2__BillingFrequency__c = frequency; //'One Time','Yearly','Half Yearly','Quarterly','Monthly';
        objPriceListItem.Apttus_Config2__BillingRule__c = 'Bill In Advance'; //'Bill In Arrears'
        objPriceListItem.Apttus_Config2__Sequence__c = 1;
        objPriceListItem.Apttus_Config2__ContractPrice__c = 10;
        objPriceListItem.Apttus_Config2__Cost__c = 10;
        objPriceListItem.Apttus_Config2__ListPrice__c = price;
        objPriceListItem.Apttus_Config2__MaxPrice__c = 9999999999999.99999;
        objPriceListItem.Apttus_Config2__MaxUsageQuantity__c = 9999999999999.99999;
        objPriceListItem.Apttus_Config2__MinPrice__c = 0;
        objPriceListItem.Apttus_Config2__MinUsageQuantity__c = 0;
        objPriceListItem.Apttus_Config2__MinMaxPriceAppliesTo__c = 'Base Price'; //'Base Extended Price'
        objPriceListItem.Apttus_Config2__Active__c = TRUE;
        objPriceListItem.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        objPriceListItem.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        objPriceListItem.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        objPriceListItem.Apttus_Config2__AllowPriceRampOverlap__c = TRUE;
        objPriceListItem.Apttus_Config2__AllowProration__c = TRUE;
        objPriceListItem.Apttus_Config2__AutoCascadeQuantity__c = TRUE;
        objPriceListItem.Apttus_Config2__AutoCascadeSellingTerm__c = TRUE;

        objPriceListItem.Apttus_Config2__DisableAssetIntegration__c = TRUE;
        objPriceListItem.Apttus_Config2__DisableSyncWithOpportunity__c = TRUE;
        objPriceListItem.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        objPriceListItem.Apttus_Config2__EnableAutoRampCreation__c = TRUE;
        objPriceListItem.Apttus_Config2__EnableCommitment__c = TRUE;
        objPriceListItem.Apttus_Config2__EnablePriceRamp__c = TRUE;
        objPriceListItem.Apttus_Config2__HasCriteria__c = FALSE;
        objPriceListItem.Apttus_Config2__IsQuantityReadOnly__c = FALSE;
        objPriceListItem.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        objPriceListItem.Apttus_Config2__IsUsageTierModifiable__c = TRUE;
        objPriceListItem.Apttus_Config2__EffectiveDate__c = System.now().addDays(-2);
        objPriceListItem.Apttus_Config2__ExpirationDate__c = System.now().addYears(2);

        //defaults
        objPriceListItem.Apttus_Config2__DefaultPriceDatasource__c = null; //text
        objPriceListItem.Apttus_Config2__DefaultPriceFrom__c = null; //'Product Attribute','Advanced Formula'
        objPriceListItem.Apttus_Config2__DefaultQuantity__c = 1;
        objPriceListItem.Apttus_Config2__DefaultQuantityDatasource__c = null; //text
        objPriceListItem.Apttus_Config2__DefaultQuantityFrom__c = null; //'Product Configuration','Product Attribute','Advanced Formula'
        objPriceListItem.Apttus_Config2__DefaultSellingTerm__c = 12;
        
        objPriceListItem.CurrencyIsoCode = 'USD';
       
        return objPriceListItem;
    }
    public static Apttus_Config2__LineItem__c getLineItem(ID cartID2, Apttus_Proposal__Proposal__c objProposal, Apttus_Config2__PriceListItem__c objPriceListItem, Product2 objProduct, ID productID, ID optionID, String lineType, Integer lineNumber, Integer itemSequence, Integer quantity,Integer primarylinenumber) {
        Apttus_Config2__LineItem__c objLineItem = new Apttus_Config2__LineItem__c();
        objLineItem.Apttus_Config2__ConfigurationId__c = cartID2;
        objLineItem.Apttus_Config2__ProductId__c = productID;
        objLineItem.Apttus_Config2__BaseProductId__c = productID;
        objLineItem.Apttus_Config2__OptionId__c = optionID;
        objLineItem.Apttus_Config2__LineType__c = lineType;
        objLineItem.Apttus_Config2__ItemSequence__c = itemSequence;
        objLineItem.Apttus_Config2__LineNumber__c = lineNumber;
        objLineItem.Apttus_Config2__LineSequence__c = itemSequence;
        objLineItem.Apttus_Config2__PrimaryLineNumber__c = primarylinenumber;
        objLineItem.Apttus_Config2__OptionSequence__c = 1;
        objLineItem.Apttus_Config2__Quantity__c = quantity;
        objLineItem.Apttus_Config2__LineStatus__c = 'New';

        objLineItem.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        objLineItem.Apttus_Config2__IsPrimaryLine__c = TRUE;
        objLineItem.Apttus_Config2__IsPrimaryRampLine__c = FALSE;

        //Proposal
        objLineItem.Apttus_Config2__BillToAccountId__c = objProposal.Apttus_QPConfig__BillToAccountId__c;
        objLineItem.Apttus_Config2__ShipToAccountId__c = objProposal.Apttus_QPConfig__ShipToAccountId__c;
        objLineItem.Apttus_Config2__LocationId__c = objProposal.Apttus_QPConfig__LocationId__c;
        objLineItem.Apttus_Config2__StartDate__c = objProposal.Apttus_Proposal__ExpectedStartDate__c;
        objLineItem.Apttus_Config2__EndDate__c = objProposal.Apttus_Proposal__ExpectedEndDate__c;
        objLineItem.Apttus_Config2__PricingDate__c = objProposal.Apttus_QPConfig__PricingDate__c;
        objLineItem.Apttus_Config2__PaymentTermId__c = objProposal.Apttus_QPConfig__PaymentTermId__c;
        objLineItem.Apttus_Config2__BillingPreferenceId__c = objProposal.Apttus_QPConfig__BillingPreferenceId__c;

        //PLI
        objLineItem.Apttus_Config2__PriceListItemId__c = objPriceListItem.ID;
        objLineItem.Apttus_Config2__PriceListId__c = objPriceListItem.Apttus_Config2__PriceListId__c;
        objLineItem.Apttus_Config2__ChargeType__c = objPriceListItem.Apttus_Config2__ChargeType__c;
        objLineItem.Apttus_Config2__PriceType__c = objPriceListItem.Apttus_Config2__PriceType__c;
        objLineItem.Apttus_Config2__Frequency__c = objPriceListItem.Apttus_Config2__Frequency__c;
        objLineItem.Apttus_Config2__SellingFrequency__c = objPriceListItem.Apttus_Config2__Frequency__c;
        objLineItem.Apttus_Config2__PriceMethod__c = objPriceListItem.Apttus_Config2__PriceMethod__c;
        objLineItem.Apttus_Config2__BasePriceMethod__c = objPriceListItem.Apttus_Config2__PriceMethod__c;
        objLineItem.Apttus_Config2__RollupPriceMethod__c = objPriceListItem.Apttus_Config2__PriceMethod__c;
        objLineItem.Apttus_Config2__BillingFrequency__c = objPriceListItem.Apttus_Config2__BillingFrequency__c;
        objLineItem.Apttus_Config2__BillingRule__c = objPriceListItem.Apttus_Config2__BillingRule__c;
        objLineItem.Apttus_Config2__PriceUom__c = objPriceListItem.Apttus_Config2__PriceUom__c;
        objLineItem.Apttus_Config2__Uom__c = objPriceListItem.Apttus_Config2__PriceUom__c;
        objLineItem.Apttus_Config2__SellingTerm__c = objPriceListItem.Apttus_Config2__DefaultSellingTerm__c;
        objLineItem.Apttus_Config2__Term__c = objPriceListItem.Apttus_Config2__DefaultSellingTerm__c;

        //Price
        objLineItem.Apttus_Config2__TotalQuantity__c = quantity;
        objLineItem.Apttus_Config2__ExtendedQuantity__c = quantity;
        objLineItem.Apttus_Config2__ListPrice__c = objPriceListItem.Apttus_Config2__ListPrice__c;
        objLineItem.Apttus_Config2__BasePrice__c = objPriceListItem.Apttus_Config2__ListPrice__c;
        objLineItem.Apttus_Config2__BasePriceOverride__c = objPriceListItem.Apttus_Config2__ListPrice__c;
        objLineItem.Apttus_Config2__BaseExtendedPrice__c = objPriceListItem.Apttus_Config2__ListPrice__c * quantity;
        objLineItem.Apttus_Config2__OptionCost__c = 0;
        objLineItem.Apttus_Config2__OptionPrice__c = 0;
        objLineItem.Apttus_Config2__ExtendedPrice__c = objPriceListItem.Apttus_Config2__ListPrice__c * quantity;
        objLineItem.Apttus_Config2__NetUnitPrice__c = objPriceListItem.Apttus_Config2__ListPrice__c;
        objLineItem.Apttus_Config2__NetPrice__c = objPriceListItem.Apttus_Config2__ListPrice__c * quantity;
        objLineItem.Apttus_Config2__NetAdjustmentPercent__c = null;
        objLineItem.Apttus_Config2__ParentBundleNumber__c = null;
        objLineItem.Apttus_Config2__PriceAdjustment__c = 0;
        objLineItem.Apttus_Config2__PriceAdjustmentAmount__c = objPriceListItem.Apttus_Config2__RelatedAdjustmentAmount__c;
        objLineItem.Apttus_Config2__PriceAdjustmentAppliesTo__c = objPriceListItem.Apttus_Config2__RelatedPercentAppliesTo__c;
        objLineItem.Apttus_Config2__PriceAdjustmentType__c = objPriceListItem.Apttus_Config2__RelatedAdjustmentType__c;
        objLineItem.Apttus_Config2__PriceGroup__c = 'Price Ramp';
        objLineItem.Apttus_Config2__FlatOptionPrice__c = 0;

        //Adjustment
        objLineItem.Apttus_Config2__AdjustedPrice__c = objPriceListItem.Apttus_Config2__ListPrice__c;
        objLineItem.Apttus_Config2__AdjustmentAmount__c = objPriceListItem.Apttus_Config2__RelatedAdjustmentAmount__c;
        objLineItem.Apttus_Config2__AdjustmentType__c = objPriceListItem.Apttus_Config2__RelatedAdjustmentType__c;

        //incentives
        //objLineItem.Apttus_Config2__CouponCode__c                 = 'Coupon';
        objLineItem.Apttus_Config2__HasIncentives__c = FALSE;
        //objLineItem.Apttus_Config2__IncentiveId__c                    = incentiveID;
        objLineItem.Apttus_Config2__IncentiveAdjustmentAmount__c = 0;
        objLineItem.Apttus_Config2__IncentiveBasePrice__c = objPriceListItem.Apttus_Config2__ListPrice__c;
        objLineItem.Apttus_Config2__IncentiveCode__c = null;
        objLineItem.Apttus_Config2__IncentiveExtendedPrice__c = objPriceListItem.Apttus_Config2__ListPrice__c * quantity;
        objLineItem.Apttus_Config2__IncentiveType__c = null;

        //Delta
        objLineItem.Apttus_Config2__DeltaPrice__c = null;
        objLineItem.Apttus_Config2__DeltaQuantity__c = null;
        objLineItem.Apttus_Config2__AssetQuantity__c = 2;

        //Group
        objLineItem.Apttus_Config2__AllocateGroupAdjustment__c = objPriceListItem.Apttus_Config2__AllocateGroupAdjustment__c;
        objLineItem.Apttus_Config2__GroupAdjustmentPercent__c = 0;

        //Renew
        objLineItem.Apttus_Config2__AutoRenew__c = objPriceListItem.Apttus_Config2__AutoRenew__c;
        objLineItem.Apttus_Config2__AutoRenewalTerm__c = objPriceListItem.Apttus_Config2__AutoRenewalTerm__c;
        objLineItem.Apttus_Config2__AutoRenewalType__c = objPriceListItem.Apttus_Config2__AutoRenewalType__c;

        //Cost
        objLineItem.Apttus_Config2__Cost__c = objPriceListItem.Apttus_Config2__Cost__c;
        objLineItem.Apttus_Config2__BaseCost__c = objPriceListItem.Apttus_Config2__Cost__c;
        objLineItem.Apttus_Config2__BaseCostOverride__c = objPriceListItem.Apttus_Config2__Cost__c;
        objLineItem.Apttus_Config2__BaseExtendedCost__c = objPriceListItem.Apttus_Config2__Cost__c * quantity;
        objLineItem.Apttus_Config2__ExtendedCost__c = objPriceListItem.Apttus_Config2__Cost__c * quantity;
        objLineItem.Apttus_Config2__UnitCostAdjustment__c = null;
        objLineItem.Apttus_Config2__UnitPriceAdjustmentAuto__c = null;
        objLineItem.Apttus_Config2__UnitPriceAdjustmentManual__c = null;

        objLineItem.Apttus_Config2__RelatedPercent__c = objPriceListItem.Apttus_Config2__RelatedPercent__c;
        objLineItem.Apttus_Config2__RelatedPercentAppliesTo__c = objPriceListItem.Apttus_Config2__RelatedPercentAppliesTo__c;
        objLineItem.Apttus_Config2__RelatedAdjustmentAmount__c = objPriceListItem.Apttus_Config2__RelatedAdjustmentAmount__c;
        objLineItem.Apttus_Config2__RelatedAdjustmentAppliesTo__c = objPriceListItem.Apttus_Config2__RelatedAdjustmentAppliesTo__c;
        objLineItem.Apttus_Config2__RelatedAdjustmentType__c = objPriceListItem.Apttus_Config2__RelatedAdjustmentType__c;
        objLineItem.Apttus_Config2__RelatedItemId__c = objPriceListItem.Apttus_Config2__RelatedItemId__c;

        objLineItem.Apttus_Config2__AllowManualAdjustment__c = objPriceListItem.Apttus_Config2__AllowManualAdjustment__c;
        objLineItem.Apttus_Config2__AllowProration__c = objPriceListItem.Apttus_Config2__AllowProration__c;
        objLineItem.Apttus_Config2__Description__c = objPriceListItem.Apttus_Config2__Description__c;
        objLineItem.Apttus_Config2__MaxPrice__c = objPriceListItem.Apttus_Config2__MaxPrice__c;
        objLineItem.Apttus_Config2__MaxUsageQuantity__c = objPriceListItem.Apttus_Config2__MaxUsageQuantity__c;
        objLineItem.Apttus_Config2__MinMaxPriceAppliesTo__c = objPriceListItem.Apttus_Config2__MinMaxPriceAppliesTo__c;
        objLineItem.Apttus_Config2__MinPrice__c = objPriceListItem.Apttus_Config2__MinPrice__c;
        objLineItem.Apttus_Config2__MinUsageQuantity__c = objPriceListItem.Apttus_Config2__MinUsageQuantity__c;
        objLineItem.Apttus_Config2__IsSellingTermReadOnly__c = objPriceListItem.Apttus_Config2__IsSellingTermReadOnly__c;
        objLineItem.Apttus_Config2__IsUsageTierModifiable__c = objPriceListItem.Apttus_Config2__IsUsageTierModifiable__c;
        objLineItem.Apttus_Config2__PriceIncludedInBundle__c = objPriceListItem.Apttus_Config2__PriceIncludedInBundle__c;
        objLineItem.Apttus_Config2__RollupPriceToBundle__c = objPriceListItem.Apttus_Config2__RollupPriceToBundle__c;
        objLineItem.Apttus_Config2__IsQuantityModifiable__c = !objPriceListItem.Apttus_Config2__IsQuantityReadOnly__c;


        objLineItem.Apttus_Config2__ConfigStatus__c = 'Complete'; //'Pending','Default Pending','NA'
        objLineItem.Apttus_Config2__ConstraintCheckStatus__c = 'Complete'; //'Pending','Auto Added','NA'
        objLineItem.Apttus_Config2__PricingStatus__c = 'Pending'; //Complete
        objLineItem.Apttus_Config2__SyncStatus__c = 'Synchronized'; //Pending
        objLineItem.Apttus_Config2__ExtendedDescription__c = 'description';
        objLineItem.Apttus_Config2__Guidance__c = 'Green'; //'Yellow','Red'

        //Product
        objLineItem.Apttus_Config2__ProductVersion__c = objProduct.Apttus_Config2__Version__c;
        objLineItem.Apttus_Config2__HasAttributes__c = objProduct.Apttus_Config2__HasAttributes__c;
        objLineItem.Apttus_Config2__HasOptions__c = objProduct.Apttus_Config2__HasOptions__c;
        objLineItem.Apttus_Config2__HasDefaults__c = objProduct.Apttus_Config2__HasDefaults__c;
       
        return objLineItem;
    }
  
    
    public static Apttus_Config2__PriceDimension__c getPriceDimension(String name,String businessobject,String contexttype,String fieldname) {
        Apttus_Config2__PriceDimension__c objPriceDimension = new Apttus_Config2__PriceDimension__c();
        objPriceDimension.Name = name;
        objPriceDimension.Apttus_Config2__BusinessObject__c = businessobject;
        objPriceDimension.Apttus_Config2__ContextType__c = contexttype;
        objPriceDimension.Apttus_Config2__Datasource__c = fieldname;
        return objPriceDimension;
    }
    public static Apttus_Config2__PriceMatrix__c getihnPriceMatrix(String description,Id pricedimension1,String dimension1type,Id pli) {
        Apttus_Config2__PriceMatrix__c objPriceMatrix = new Apttus_Config2__PriceMatrix__c();
        objPriceMatrix.Apttus_Config2__Description__c = description;
        objPriceMatrix.Apttus_Config2__Dimension1Id__c = pricedimension1;
        objPriceMatrix.Apttus_Config2__Dimension1ValueType__c = dimension1type;
        objPriceMatrix.Apttus_Config2__PriceListItemId__c = pli;
        objPriceMatrix.Apttus_Config2__Sequence__c = 1;      
        return objPriceMatrix;
    }
    public static Apttus_Config2__PriceMatrix__c getPriceMatrix(String description,Id pricedimension1,String dimension1type,Id pricedimension2,String dimension2type,Id pli) {
        Apttus_Config2__PriceMatrix__c objPriceMatrix = new Apttus_Config2__PriceMatrix__c();
        objPriceMatrix.Apttus_Config2__Description__c = description;
        objPriceMatrix.Apttus_Config2__Dimension1Id__c = pricedimension1;
        objPriceMatrix.Apttus_Config2__Dimension1ValueType__c = dimension1type;
        objPriceMatrix.Apttus_Config2__Dimension2Id__c = pricedimension2;
        objPriceMatrix.Apttus_Config2__Dimension2ValueType__c = dimension2type;
        objPriceMatrix.Apttus_Config2__PriceListItemId__c = pli;  
        objPriceMatrix.Apttus_Config2__Sequence__c = 1;
        return objPriceMatrix;
    }
    public static Apttus_Config2__PriceMatrixEntry__c getPriceMatrixEntry(String dimension1value,String dimension2value,Integer amount,Id pricematrix) {
        Apttus_Config2__PriceMatrixEntry__c objPriceMatrixEntry = new Apttus_Config2__PriceMatrixEntry__c();
        objPriceMatrixEntry.Apttus_Config2__Dimension1Value__c = dimension1value;
        objPriceMatrixEntry.Apttus_Config2__Dimension2Value__c = dimension2value;
        objPriceMatrixEntry.Apttus_Config2__AdjustmentAmount__c = amount;
        objPriceMatrixEntry.Apttus_Config2__AdjustmentType__c = 'List Price Override';
        objPriceMatrixEntry.Apttus_Config2__PriceMatrixId__c = pricematrix;
        objPriceMatrixEntry.Apttus_Config2__Sequence__c = 1;
        objPriceMatrixEntry.Apttus_Config2__PeriodStartDate__c = date.today().addYears(-1);
        objPriceMatrixEntry.Apttus_Config2__PeriodEndDate__c = date.today().addYears(1);
        return objPriceMatrixEntry;
    }

    
    public static List < SObject > getObjects(String strObjectname, String strWhereCondition) {
        return getObjectsWithExtraFields(strObjectname, '', strWhereCondition);
    }


    public static String getQuery(String strObjectname, String strWhereCondition) {
        return getQueryWithWithExtraFields(strObjectname, '', strWhereCondition);
    }


    public static List < SObject > getObjectsWithExtraFields(String strObjectname, String extraFields, String strWhereCondition) {
        return getObjectsWithParent(strObjectname, extraFields, null, strWhereCondition);
    }


    public static String getQueryWithWithExtraFields(String strObjectname, String extraFields, String strWhereCondition) {
        return getQueryWithParentObject(strObjectname, extraFields, null, strWhereCondition);
    }


    public static List < SObject > getObjectsWithParent(String strObjectname, String extraFields, Map < String, String > mapParentObjectToPrefix, String strWhereCondition) {
        return getObjectsWithChildAndParent(strObjectname, extraFields, mapParentObjectToPrefix, null, strWhereCondition);
    }


    public static String getQueryWithParentObject(String strObjectname, String extraFields, Map < String, String > mapParentObjectToPrefix, String strWhereCondition) {
        return getQueryWithChildAndParent(strObjectname, extraFields, mapParentObjectToPrefix, null, strWhereCondition);
    }


    public static List < SObject > getObjectsWithChild(String strObjectname, String extraFields, Map < String, String > mapChildObjectToRelationName, String strWhereCondition) {
        return getObjectsWithChildAndParent(strObjectname, extraFields, null, mapChildObjectToRelationName, strWhereCondition);
    }


    public static String getQueryWithChildObjects(String strObjectname, String extraFields, Map < String, String > mapChildObjectToRelationName, String strWhereCondition) {
        return getQueryWithChildAndParent(strObjectname, extraFields, null, mapChildObjectToRelationName, strWhereCondition);
    }


    public static List < SObject > getObjectsWithChildAndParent(String strObjectname, String extraFields, Map < String, String > mapParentRealtion, Map < String, String > mapChildObjectToRelationName, String strWhereCondition) {
        return Database.query(getQueryWithChildAndParent(strObjectname, extraFields, mapParentRealtion, mapChildObjectToRelationName, strWhereCondition));
    }


    public static String getQueryWithChildAndParent(String strObjectname, String extraFields, Map < String, String > mapParentRealtion, Map < String, String > mapChildObjectToRelationName, String strWhereCondition) {
        String strQuery = 'SELECT ' +
            String.join(new List < String > (Schema.describeSObjects(new String[] {
                strObjectname
            })[0].fields.getMap().keyset()), ', ');

        if (String.isNotBlank(extraFields)) {
            strQuery += ', ' + extraFields;
        }

        if (mapParentRealtion != null && !mapParentRealtion.isEmpty()) {
            for (String parentObjectName: mapParentRealtion.keyset()) {
                String preFix = ', ' + mapParentRealtion.get(parentObjectName);
                strQuery += preFix +
                    String.join(new List < String > (getFields(parentObjectName)), preFix);
            }
        }

        if (mapChildObjectToRelationName != null && !mapChildObjectToRelationName.isEmpty()) {
            for (String childObjectname: mapChildObjectToRelationName.keyset()) {
                strQuery += ', (SELECT ' +
                    String.join(new List < String > (getFields(childObjectname)), ', ') +
                    ' FROM ' +
                    mapChildObjectToRelationName.get(childObjectname) +
                    ' ) ';
            }
        }

        strQuery += ' FROM ' + strObjectname;

        if (String.isNotBlank(strWhereCondition)) {
            strQuery += ' WHERE ' + strWhereCondition;
        }

        System.debug(LoggingLevel.ERROR, '##### APTS_TestDataSetupUtility.getObjects() : ' + strQuery);
        return strQuery;
    }

    public static Set < String > getFields(String strObjectAPI) {
        return Schema.describeSObjects(new String[] {
            strObjectAPI
        })[0].fields.getMap().keyset();
    }
    
     public static Apttus__AgreementLineItem__c getAgrLineItm(String agrId, String prodId) {
        Apttus__AgreementLineItem__c agALI = new Apttus__AgreementLineItem__c();
        agALI.Apttus__AgreementId__c = agrId;
        agALI.Apttus_CMConfig__LineNumber__c = 1;
        agALI.Apttus__Quantity__c = 1;
        agALI.Apttus_CMConfig__LineStatus__c = 'New';
        agALI.Apttus_CMConfig__IsPrimaryLine__c = true;
        agALI.Apttus__ProductId__c = prodId;
        agALI.Apttus_CMConfig__LineType__c='Product/Service';

        return agALI;
    }
   
}