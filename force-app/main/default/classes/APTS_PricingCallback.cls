/**
 * Apttus Config & Pricing
 * DefaultPricingCallback2
 *
 * @2011-2014 Apttus Inc. All rights reserved.
 */
global with sharing class APTS_PricingCallback implements Apttus_Config2.CustomClass.IPricingCallback3 {
	private Apttus_Config2.ProductConfiguration contextCart;
	private Apttus_Config2.CustomClass.PricingMode currentMode;
	private boolean priceIncreaseApplied;

	/**
	 * Callback at the beginning of the pricing call.
	 * Use the start method to initialize state
	 * @param cart the cart object
	 */
	global void start(Apttus_Config2.ProductConfiguration cart) {
		this.contextCart = cart;
		this.priceIncreaseApplied = false;
		system.debug('In Pricing callbak: Start()');
	}
	/**
	 * Callback to indicate the pricing mode
	 * @param mode the pricing mode
	 */
	global void setMode(Apttus_Config2.CustomClass.PricingMode mode) {
		this.currentMode = mode;
		system.debug('In Pricing callbak: setMode()-->' + this.currentMode);
	}
	/**
	 * Callback after the price list item is set on the given line item
	 * @param itemSO the price list item associated with the line item
	 * @param lineItemMO the line item
	 */
	global void onPriceItemSet(Apttus_Config2__PriceListItem__c itemSO, Apttus_Config2.LineItem lineItemMO) {
		system.debug('In Pricing callbak: onPriceItemSet()');
		system.debug('onPriceItemSet::Line Number::' + lineItemMO.getLineItemSO().Apttus_Config2__PrimaryLineNumber__c);
		Apttus_Config2__LineItem__c itemNew = lineItemMO.getLineItemSO();
		//If (itemNew.Apttus_Config2__OptionId__c == '01tBo000003OhIDIA0') {
		//itemNew.Apttus_Config2__BasePrice__c = basePrice + (0.05*basePrice);
		system.debug('onPriceItemSet :: New Base Price::' + itemNew.Apttus_Config2__BasePrice__c);
		//}
	}
	/**
	 * Callback before pricing the line item collection
	 * Use this method to do all required pre-processing to prepare the line items for pricing.
	 * @param itemColl the line item collection to pre-process
	 */
	global void beforePricing(Apttus_Config2.ProductConfiguration.LineItemColl itemColl) {
		system.debug('In Pricing callbak: beforePricing()');

		decimal autoRenewalTerm;
		string currencyISOCode;

		Apttus_Config2__LineItem__c bundleProductLine = new Apttus_Config2__LineItem__c();

		for (Apttus_Config2.LineItem configLineItem : itemColl.getAllLineItems()) {
			Apttus_Config2__LineItem__c item = configLineItem.getLineItemSO();
			system.debug('beforePricing()::Line Number::' + item.Apttus_Config2__PrimaryLineNumber__c);
			system.debug('beforePricing()::Current Base Price::' + item.Apttus_Config2__BasePrice__c);

			currencyISOCode = item.currencyISOCode;

			APTS_Nearmap_Subscription_Setting__c subscriptionValue = APTS_Nearmap_Subscription_Setting__c.getValues(currencyISOCode);
			if (subscriptionValue != null) {
				autoRenewalTerm = subscriptionValue.APTS_Default_Auto_Renewal_Term__c;
			}

			if (currentMode == Apttus_Config2.CustomClass.PricingMode.BASEPRICE && contextCart != null && item.Apttus_Config2__ConfigurationId__r.Apttus_Config2__BusinessObjectType__c == 'Proposal') {
				if (item.Apttus_Config2__PricingStatus__c == 'Pending' && item.Apttus_Config2__NetPrice__c != 0) {
					this.priceIncreaseApplied = true;
					item.APTS_Price_Increase_Applied__c = false;
				}

				if (item.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.APTS_Is_Trial_Quote__c == false) {
					item.Apttus_Config2__AutoRenewalTerm__c = autoRenewalTerm;

					if (item.Apttus_Config2__LineType__c == 'Product/Service' && item.Apttus_Config2__ParentBundleNumber__c == null) {
						item.APTS_Trial__c = false;
					} else {
						//No Change
					}
				} else if (item.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.APTS_Is_Trial_Quote__c == true) {
					if (item.Apttus_Config2__LineType__c == 'Product/Service' && item.Apttus_Config2__ParentBundleNumber__c == null) {
						item.APTS_Trial__c = true;
					} else {
						item.APTS_Trial__c = false;
					}
					item.Apttus_Config2__AutoRenewalTerm__c = null;
				}

				if (item.Apttus_Config2__LineType__c == 'Product/Service') {
					bundleProductLine = item;
				} else {
					if (item.Apttus_Config2__LineSequence__c == bundleProductLine.Apttus_Config2__LineSequence__c && item.Apttus_Config2__LineStatus__c != 'Cancelled' && item.Apttus_Config2__EndDate__c != bundleProductLine.Apttus_Config2__EndDate__c) {
						item.Apttus_Config2__EndDate__c = bundleProductLine.Apttus_Config2__EndDate__c;
					}
				}

				if (item.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.APTS_Auto_Renewal__c == 'No Change' && item.Apttus_Config2__AssetLineItemId__c != null) {
					item.APTS_Manual_Renewal__c = item.Apttus_Config2__AssetLineItemId__r.APTS_Manual_Renewal__c;
				} else if (
					(item.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.APTS_Auto_Renewal__c == 'No Change' && item.Apttus_Config2__AssetLineItemId__c == null) ||
					item.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.APTS_Auto_Renewal__c == 'Off'
				) {
					if (item.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.APTS_Is_Trial_Quote__c == true) {
						item.APTS_Manual_Renewal__c = true;
					} else {
						item.APTS_Manual_Renewal__c = false;
					}
				} else if (item.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.APTS_Auto_Renewal__c == 'On') {
					item.APTS_Manual_Renewal__c = false;
				}
			} else if (currentMode == Apttus_Config2.CustomClass.PricingMode.ADJUSTMENT && (this.priceIncreaseApplied || !item.APTS_Price_Increase_Applied__c)) {
				system.debug('beforePricing()::Current Base Price::' + item.Apttus_Config2__BasePrice__c);
				system.debug('beforePricing()::Current List Price::' + item.Apttus_Config2__ListPrice__c);
				system.debug('beforePricing()::Current Pricing Status::' + item.Apttus_Config2__PricingStatus__c);
				item.Apttus_Config2__BasePrice__c = item.Apttus_Config2__BasePrice__c + (0.05 * item.Apttus_Config2__BasePrice__c);
				// item.Apttus_Config2__BaseExtendedPrice__c = item.Apttus_Config2__BasePrice__c;
				// item.Apttus_Config2__ExtendedPrice__c = item.Apttus_Config2__BasePrice__c;
				item.APTS_Price_Increase_Applied__c = true;
				configLineItem.updatePrice();
				this.priceIncreaseApplied = true;
			}
		}
	}
	/**
	 * Callback before pricing the given line item in the line item collection
	 * Use this method to do all required pre-processing to prepare the line item for pricing.
	 * @param itemColl the line item collectionholding the line item
	 * @param lineItemMO the line item to pre-process
	 */
	global void beforePricingLineItem(Apttus_Config2.ProductConfiguration.LineItemColl itemColl, Apttus_Config2.LineItem lineItemMO) {
		system.debug('In Pricing callbak: beforePricingLineItem()');
		for (Apttus_Config2.LineItem configLineItem : itemColl.getAllLineItems()) {
			Apttus_Config2__LineItem__c item = configLineItem.getLineItemSO();
			system.debug('beforePricingLineItem()::Line Number::' + item.Apttus_Config2__PrimaryLineNumber__c);
		}
	}
	/**
	 * Callback after pricing the given line item in the line item collection
	 * Use this method to do all required post-processing after the line item is priced
	 * @param itemColl the line item collection holding the line item
	 * @param lineItemMO the line item to post-process
	 */
	global void afterPricingLineItem(Apttus_Config2.ProductConfiguration.LineItemColl itemColl, Apttus_Config2.LineItem lineItemMO) {
		system.debug('In Pricing callbak: afterPricingLineItem()');
		for (Apttus_Config2.LineItem configLineItem : itemColl.getAllLineItems()) {
			Apttus_Config2__LineItem__c item = configLineItem.getLineItemSO();
			system.debug('afterPricingLineItem()::Line Number::' + item.Apttus_Config2__PrimaryLineNumber__c);
		}
	}

	/**
	 * Callback after pricing the line item collection
	 * Use this method to do all required post-processing after line items are priced.
	 * @param itemColl the line item collection to post-process
	 */
	global void afterPricing(Apttus_Config2.ProductConfiguration.LineItemColl itemColl) {
		system.debug('In Pricing callbak: afterPricing()');

		for (Apttus_Config2.LineItem configLineItem : itemColl.getAllLineItems()) {
			Apttus_Config2__LineItem__c item = configLineItem.getLineItemSO();
			system.debug('afterPricing()::Line Number::' + item.Apttus_Config2__PrimaryLineNumber__c);
			system.debug('afterPricing()::Current Base Price::' + item.Apttus_Config2__BasePrice__c);
			system.debug('afterPricing()::Current List Price::' + item.Apttus_Config2__ListPrice__c);
			system.debug('afterPricing()::Current Pricing Status::' + item.Apttus_Config2__PricingStatus__c);
			// if (item.Apttus_Config2__ListPrice__c <= 0) {
			// 	item.Apttus_Config2__BasePrice__c = item.Apttus_Config2__BasePrice__c + (0.05 * item.Apttus_Config2__BasePrice__c);
			// } else {
			// 	item.Apttus_Config2__BasePrice__c = item.Apttus_Config2__ListPrice__c + (0.05 * item.Apttus_Config2__ListPrice__c);
			// }
			// configLineItem.updatePrice();
		}
	}
	/**
	 * Callback after all batches of line items are processed
	 * Use the finish method to release state
	 */
	global void finish() {
		system.debug('In Pricing callbak: finish()');
		if (this.priceIncreaseApplied) {
			List<Apttus_Config2.LineItem> itemColl = this.contextCart.getLineItems();
			if (itemcoll != null && itemColl.size() > 0) {
				for (Apttus_Config2.LineItem configLineItem : itemColl) {
					configLineItem.updatePrice();
				}
			}
		}
	}
}
