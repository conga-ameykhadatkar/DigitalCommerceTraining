/**
  * @Name: APTS_agreementLineItemTriggerHelper
  * @Author(Creator): Avani Badheka (CONGA)
  * @CreateDate: 13/Feb/2024
  * @Description: Trigger helper on Agreement Line Item object.
  -----------------------------------------------------------------------------------------------
  **/
  public class APTS_agreementLineItemTriggerHelper {
    public static void updateFieldsAfterInsert(List<Apttus__AgreementLineItem__c> newList,Map<Id,Apttus__AgreementLineItem__c> oldMap){
        List<Id> aliIds=new List<Id>();
        List<Id> agreementIds=new List<Id>();
        List<Id> agreementIdForDelete=new List<Id>();
        List<Decimal> lineItemNumberList=new List<decimal>();
        List<Apttus__AgreementLineItem__c> aliNewList=new List<Apttus__AgreementLineItem__c>();
        List<Apttus__AgreementLineItem__c> aliToBeDeleted=new List<Apttus__AgreementLineItem__c>();
        List<string> agrNumberList=new List<String>();
        try {
            for(Apttus__AgreementLineItem__c ali:newList){
                aliIds.add(ali.Id);
            }
            if(aliIds.size()>0){
                aliNewList=[select Id,Apttus_CMConfig__Type__c,
                APTS_Manual_Renewal__c, Apttus_CMConfig__LineType__c,
                Apttus_CMConfig__ParentBundleNumber__c, Apttus_CMConfig__LineStatus__c, 
                Apttus_CMConfig__AssetId__c, APTS_Trial__c,Apttus__AgreementId__r.Apttus_CMConfig__ABOType__c,
                Apttus__AgreementId__r.Apttus_CMConfig__IsSystemGenerated__c,Apttus__AgreementId__r.Apttus__Status__c,
                Apttus_CMConfig__AssetLineItemId__r.APTS_Trial__c,Apttus_CMConfig__AssetLineItemId__c,Apttus__AgreementId__c,
                Apttus_CMConfig__AssetLineItemId__r.APTS_Manual_Renewal__c,Apttus_CMConfig__LineNumber__c
                from Apttus__AgreementLineItem__c where id in :aliIds with security_enforced];
            }
            //Line Type = 'Product/Services' && Parent Bundle Number = blank/null && Line Status = 'Renewed' 
            //&& ALI.Asset != null && ALI.Asset.Trial = True && ALI.Asset.Manual Renewal = True && ALI.Agreement.ABO Type = 'Renewal'
            // && ALI.Agreement.System Generated = True && ALI.Agreement.Status = 'Request' && ALI.Agreement.Status Category = 'Request'
            if(aliNewList.size()>0){
                for(Apttus__AgreementLineItem__c ali:aliNewList){
                    //ABO-005
                    if(ali.Apttus_CMConfig__LineType__c=='Product/Service' 
                    && ali.Apttus_CMConfig__ParentBundleNumber__c==null 
                    && ali.Apttus_CMConfig__LineStatus__c=='Renewed'
                    && ali.Apttus__AgreementId__r.Apttus_CMConfig__ABOType__c=='Renewal'
                    && ali.Apttus__AgreementId__r.Apttus_CMConfig__IsSystemGenerated__c==true
                    && ali.Apttus__AgreementId__r.Apttus__Status__c == 'Request'
                    && ali.Apttus__AgreementId__r.Apttus__Status_Category__c =='Request'
                    && ali.Apttus_CMConfig__StartDate__c > ali.Apttus__AgreementId__r.Apttus__Contract_Start_Date__c){
                        agreementIdForDelete.add(ali.Apttus__AgreementId__c);  
                        lineItemNumberList.add(ali.Apttus_CMConfig__LineNumber__c);
                        aliToBeDeleted.add(ali);
                    }
                    
                    if(ali.Apttus_CMConfig__LineType__c=='Product/Service' 
                    && ali.Apttus_CMConfig__ParentBundleNumber__c==null 
                    && ali.Apttus_CMConfig__LineStatus__c=='Renewed'
                    && ali.Apttus_CMConfig__AssetLineItemId__c!=null
                    && ali.Apttus_CMConfig__AssetLineItemId__r.APTS_Trial__c==true 
                    && ali.Apttus_CMConfig__AssetLineItemId__r.APTS_Manual_Renewal__c==true
                    && ali.Apttus__AgreementId__r.Apttus_CMConfig__ABOType__c=='Renewal'
                    && ali.Apttus__AgreementId__r.Apttus_CMConfig__IsSystemGenerated__c==true
                    && ali.Apttus__AgreementId__r.Apttus__Status__c == 'Request'
                    && ali.Apttus__AgreementId__r.Apttus__Status_Category__c =='Request'){
                        agreementIds.add(ali.Apttus__AgreementId__c);
                    }
                }
                
                if(agreementIds.size()>0){
                    List<Apttus__APTS_Agreement__c> agreementList=[ select Id,APTS_is_Trial__c, Apttus_CMConfig__ABOType__c,Apttus__Agreement_Number__c
                    from Apttus__APTS_Agreement__c where id in :agreementIds with security_enforced];
                    if(agreementList.size()>0){
                        for(Apttus__APTS_Agreement__c agr:agreementList){
                            agr.APTS_is_Trial__c=True;
                            agr.Apttus_CMConfig__ABOType__c='Manual Renewal';
                        }
                        
                        update agreementList;
                    }
                    
                }
                //ABO-005
                if(!lineItemNumberList.isEmpty()){
                    aliToBeDeleted.addAll([select Id,name,Apttus__AgreementId__c,Apttus__AgreementId__r.Apttus__Agreement_Number__c from Apttus__AgreementLineItem__c where Apttus_CMConfig__LineNumber__c in :lineItemNumberList]);
                    if(!aliToBeDeleted.isEmpty()){
                        Database.delete(aliToBeDeleted, accessLevel.SYSTEM_MODE);
                    }
                }
            }
            
            
        } catch (Exception ex) {
            System.debug('Exception Occurred-->'+ex.getMessage()+'at Line-->'+ex.getLineNumber());
        }
        
        
    }
}