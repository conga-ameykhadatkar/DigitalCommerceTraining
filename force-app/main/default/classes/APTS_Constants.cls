/**
* @Name: APTS_Constants
* @Author(Creator) : Avani Badheka (Conga)
* @CreateDate: 13/Feb/2024
* @Description: Keeping all the constants and flags used in code
-----------------------------------------------------------------------------------------------
**/
public without sharing class APTS_Constants {
	//BEG: Other Constants
	public static final String AGMT_STATUS_FULLY_SIGNED = 'Fully Signed';
	public static final String AGMT_TYPE_OF_SIGNATURE = 'Esignature';
	public static final String AGMT_SIGNED_DOC_KEY = 'signed';
	public static final String NAMESPACE_APTTUS_QPCONFIG = 'apttus_qpconfig__';
	public static final String NAMESPACE_APTTUS_CMCONFIG = 'apttus_cmconfig__';
	//END: Other Constants

	// Agreement Record types
	public static final String AGMT_RECTYPE_PRODUCTAGREEMENT = 'APTS_Product_Agreement';

	//Quote Approval Stage
	public static final String QUOTE_APSTG_ACCEPTED = 'Accepted';

	// Config related status
	public static final String CONFIG_STATUS_SAVED = 'Saved';
	public static final String CONFIG_STATUS_APPROVALREQUIRED = 'Approval Required';
	public static final String CONFIG_USE_TYPE_CONFIG = 'Config';

	//Source Channels
	public static final String QUOTE_SRC_CHANNEL_DC = 'Digital Commerce';

	//Currency
	public static final String AUD = 'AUD';
	public static final String USD = 'USD';
	public static final String NZD = 'NZD';
	public static final String CAD = 'CAD';

	//Config status
	public static final string FINALIZED = 'Finalized';
	public static final string PENDING = 'Pending';

	//Boolean values
	public static final boolean APTS_TRUE = true;
	public static final boolean APTS_FALSE = false;

	//LineStatus
	public static final string LINEITEM_STATUS_NEW = 'New';
	public static final string LINEITEM_STATUS_AMEND = 'Amend';
	public static final string LINEITEM_STATUS_RENEWED = 'Renewed';
	public static final string LINEITEM_STATUS_AMENDED = 'Amended';

	//Quote ABO Status
	public static final string QUOTE_ABOTYPE_AMEND = 'Amend';
	public static final string QUOTE_ABOTYPE_RENEWAL = 'Renewal';
	public static final string QUOTE_ABOTYPE_TERMINATE = 'Terminate';
}