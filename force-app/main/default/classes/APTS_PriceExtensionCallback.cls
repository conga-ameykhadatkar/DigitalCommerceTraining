global with sharing class APTS_PriceExtensionCallback implements Apttus_Config2.CustomClass.IPricingExtensionCallback {
	/**
	 * Indicates whether the before pricing callback is enabled
	 * Use this method to determine whether before pricing should be invoked for the callback
	 * @return <code>true</code> if before pricing callback is enabled, <code>false</code> otherwise
	 */
	global Boolean isBeforePricingEnabled() {
		return true;
	}

	/**
	 * Callback before pricing the given cart
	 * Use this method to do all required pre-processing to prepare the cart line items for pricing.
	 * @param cart the cart object to pre-process
	 * @param helper the cart helper class
	 * @return the pricing extension result object
	 */
	global Apttus_Config2.CustomClass.PricingExtensionResult beforePricing(Apttus_Config2.ProductConfiguration cart, Apttus_Config2.CustomClass.CartHelper helper) {
		// Id cartId = cart.getConfigSO().Id;
		// List<Apttus_Config2__LineItem__c> lineItemsToUpdate = new List<Apttus_Config2__LineItem__c>();
		// List<Apttus_Config2__LineItem__c> lineItems = [
		// 	SELECT Id, Name, Total_reagent_qty_for_the_site__c, PrePricingCriteriaField__c, Apttus_Config2__Quantity__c, Apttus_Config2__SyncStatus__c, Apttus_Config2__PricingStatus__c
		// 	FROM Apttus_Config2__LineItem__c
		// 	WHERE Apttus_Config2__ConfigurationId__c = :cartId
		// ];

		// system.debug('******************* lineItems:' + lineItems);

		// Decimal totalQty = 0;
		// for (Apttus_Config2__LineItem__c lineItemSO : lineItems) {
		// 	//lineItemSO.Apttus_Config2__Quantity__c = 10;
		// 	totalQty += lineItemSO.Apttus_Config2__Quantity__c + (lineItemSO.PrePricingCriteriaField__c != null ? lineItemSO.PrePricingCriteriaField__c : 0);
		// 	lineItemSO.Apttus_Config2__PricingStatus__c = 'Pending';
		// 	lineItemSO.Apttus_Config2__SyncStatus__c = 'Pre-Pricing Complete';
		// 	lineItemsToUpdate.add(lineItemSO);
		// }

		// for (Apttus_Config2__LineItem__c lineItemSO : lineItemsToUpdate) {
		// 	lineItemSO.Total_reagent_qty_for_the_site__c = totalQty;
		// }

		// Database.update(lineItemsToUpdate);

		// lineItemsToUpdate = new List<Apttus_Config2__LineItem__c>();

		// List<Id> pricingCartIds = helper.getPricingCartsFor(cartId);
		// for (Apttus_Config2__LineItem__c pricingItemSO : [
		// 	SELECT Id, Name
		// 	FROM Apttus_Config2__LineItem__c
		// 	WHERE Apttus_Config2__ConfigurationId__c IN :pricingCartIds
		// ]) {
		// 	//pricingItemSO.Apttus_Config2__Quantity__c = 10;
		// 	pricingItemSO.Total_reagent_qty_for_the_site__c = totalQty;
		// 	pricingItemSO.Apttus_Config2__SyncStatus__c = 'Pre-Pricing Complete';
		// 	lineItemsToUpdate.add(pricingItemSO);
		// }

		// Database.update(lineItemsToUpdate);
		return new Apttus_Config2.CustomClass.PricingExtensionResult();
	}

	/**
	 * Indicates whether the after pricing callback is enabled
	 * Use this method to determine whether after pricing should be invoked for the callback
	 * @return <code>true</code> if after pricing callback is enabled, <code>false</code> otherwise
	 */
	global Boolean isAfterPricingEnabled() {
		return true;
	}

	/**
	 * Callback after pricing the given cart
	 * Use this method to do all required post-processing after line items are priced.
	 * @param cart the cart object to post-process
	 * @param helper the cart helper class
	 * @return the pricing extension result object
	 */
	global Apttus_Config2.CustomClass.PricingExtensionResult afterPricing(Apttus_Config2.ProductConfiguration cart, Apttus_Config2.CustomClass.CartHelper helper) {
		Id cartId = cart.getConfigSO().Id;
		List<Apttus_Config2__LineItem__c> lineItemsToUpdate = new List<Apttus_Config2__LineItem__c>();

		List<Id> pricingCartIds = helper.getPricingCartsFor(cartId);
		for (Apttus_Config2__LineItem__c lineItemSO : [
			SELECT Id, Name, Apttus_Config2__SyncStatus__c
			FROM Apttus_Config2__LineItem__c
			WHERE Apttus_Config2__ConfigurationId__c IN :pricingCartIds
		]) {
			lineItemSO.Apttus_Config2__SyncStatus__c = 'Post-Pricing Complete';
			lineItemSO.Apttus_Config2__Description__c = 'Net Price should be updated as per the new quantity 10';
			lineItemSO.Apttus_Config2__NetPrice__c = 250;
			lineItemsToUpdate.add(lineItemSO);
		}

		Database.update(lineItemsToUpdate);
		return new Apttus_Config2.CustomClass.PricingExtensionResult();
	}
}
