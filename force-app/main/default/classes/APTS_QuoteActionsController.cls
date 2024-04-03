/**
 * Class: APTS_QuoteActionsController
 *    Defines aura enabled methods for Apttus Quotes  
 */     
public with sharing class APTS_QuoteActionsController {
    
    public class QuoteActionVisibilityMatrix {
        @AuraEnabled
        public Boolean clone;
        @AuraEnabled
        public Boolean configureProducts;
        @AuraEnabled
        public Boolean accept;
        @AuraEnabled
        public Boolean generate;
        @AuraEnabled
        public Boolean makePrimary;
        @AuraEnabled
        public Boolean sendProposal;
        @AuraEnabled
        public Boolean readOnlyCart;
        @AuraEnabled
        public Boolean preview;
        @AuraEnabled
        public Boolean synchronizeWithOpportunity;
        @AuraEnabled
        public Boolean approvals;
		@AuraEnabled
        public Boolean myApprovals;
        @AuraEnabled
        public Boolean congaSign;
        @AuraEnabled
        public Boolean cancel;
        @AuraEnabled
        public Boolean createAgreement;
    }   
    
    
    /**
     * returns the Proposal
     */ 
    @AuraEnabled
    public static Apttus_Proposal__Proposal__c getProposal(Id proposalId) {
        List<Apttus_Proposal__Proposal__c> proposals 
            = [SELECT Id, Name, 
                     Apttus_QPConfig__PriceListId__c, 
                      Apttus_Proposal__ReadyToGenerate__c, 
                      Apttus_Proposal__ReadyToPresent__c, 
                      Apttus_Proposal__Approval_Stage__c,
               		  Apttus_QPApprov__Approval_Status__c,
                      Apttus_Proposal__Opportunity__c,
                      Apttus_Proposal__Primary__c,
                      Apttus_Proposal__Primary_Contact__c, 
                      Apttus_Proposal__Account__c,
                      Apttus_Proposal__Valid_Until_Date__c,
               		  OwnerId,
                      RecordType.Name,
               		  APTS_Is_Trial_Quote__c,
               		  Apttus_QPConfig__ABOType__c
          FROM Apttus_Proposal__Proposal__c 
        WHERE Id =: proposalId
                LIMIT 1];
        
        if(!proposals.isEmpty()) {
            return proposals[0];

        } else {
            return null;
        }
    }
    
    /**
     * returns the QuoteActionVisibilityMatrix
     */ 
    @AuraEnabled
    public static QuoteActionVisibilityMatrix getQuoteActionVisibility(Id proposalId) {
		
		Apttus_Proposal__Proposal__c proposalObj = getProposal(proposalId);
		String propApprovalStageName = '';
        
        if (proposalObj != NULL ){
            list<APTS_Map_Stage_to_Quote_Actions_Matrix__mdt> quoteStageActionMap = [select Quote_Action_Matrix_Field_API_Name__c 
                                                                      		  	  from APTS_Map_Stage_to_Quote_Actions_Matrix__mdt
                                                                       		 	 where Proposal_Approval_Stage__c = :proposalObj.Apttus_Proposal__Approval_Stage__c
                                                                     		 	 limit 1];
            if(quoteStageActionMap != null && quoteStageActionMap.size() > 0){
                propApprovalStageName = quoteStageActionMap[0].Quote_Action_Matrix_Field_API_Name__c;
            }
        }
        
        String queryString = 'select Id, DeveloperName, MasterLabel, Label, Draft__c, ApprovalRequired__c, InReview__c, Approved__c, Generated__c, InSignature__c, FullySigned__c, Accepted__c, Denied__c from APTS_QuoteActionVisibilityMatrix__mdt where '+propApprovalStageName+' = true';
        List<sObject> listSobjects = Database.query(queryString);
                
        if(!listSobjects.isEmpty()) {
            QuoteActionVisibilityMatrix matrix = new QuoteActionVisibilityMatrix();
            matrix.clone = false;
            matrix.configureProducts = true;
            matrix.accept = false;
            matrix.generate = false;
            matrix.makePrimary = false;
            matrix.sendProposal = false;
            matrix.readOnlyCart = false;
            matrix.preview = false;
            matrix.synchronizeWithOpportunity = false;
            matrix.approvals = false;
			matrix.myApprovals = false;
            matrix.congaSign = false;
            matrix.cancel = false;
            matrix.createAgreement = false;
            
            PermissionSetAssignment[] psaRecord = [SELECT Id, PermissionSet.Name, AssigneeId, Assignee.Name FROM PermissionSetAssignment WHERE AssigneeId =: UserInfo.getUserId() and PermissionSet.Name = 'Apttus_CPQ_Approval_User'];
            
            Apttus_Config2__CollaborationRequest__c[] collaborationRequestRecords = [SELECT Id, Name, Apttus_Config2__ParentBusinessObjectId__c, Apttus_Config2__Status__c from Apttus_Config2__CollaborationRequest__c where Apttus_Config2__ParentBusinessObjectId__c =: proposalObj.Id and Apttus_Config2__Status__c != 'Accepted'];
            
            Apttus_Config2__ProductConfiguration__c[] configRecords = [Select Id, Apttus_QPConfig__Proposald__c,Apttus_Config2__Status__c from Apttus_Config2__ProductConfiguration__c where Apttus_QPConfig__Proposald__c =: proposalObj.Id];
            
            for(sObject sobj : listSobjects){
                if(sobj.get('DeveloperName') == 'ConfigureProducts' && proposalObj.Apttus_QPConfig__PriceListId__c == NULL /*&& proposalObj.OwnerId == UserInfo.getUserId()*/ || (proposalObj.Apttus_Proposal__Approval_Stage__c == 'Accepted' || (proposalObj.Apttus_QPConfig__ABOType__c == 'Amend' && proposalObj.APTS_Is_Trial_Quote__c == False && proposalObj.APTS_Parent_Agreement__c == null) || (proposalObj.Apttus_QPConfig__ABOType__c == 'Renewal' && proposalObj.APTS_Is_Trial_Quote__c == False && proposalObj.APTS_Parent_Agreement__c == null) ||
(proposalObj.Apttus_QPConfig__ABOType__c == 'Terminate' && proposalObj.APTS_Parent_Agreement__c == null))){
                    matrix.configureProducts = false;
                }else if(sobj.get('DeveloperName') == 'Clone' && configRecords.size() > 0){
                    matrix.clone = true;
                }else if(sobj.get('DeveloperName') == 'Accept' && /*proposalObj.OwnerId == UserInfo.getUserId() &&*/ (proposalObj.Apttus_Proposal__Primary__c == true && proposalObj.Apttus_QPConfig__ABOType__c != 'Terminate') || (proposalObj.Apttus_Proposal__Primary__c == true && proposalObj.Apttus_QPConfig__ABOType__c == 'Terminate')){
                    matrix.accept = true;
                }else if(sobj.get('DeveloperName') == 'Generate' /*&& proposalObj.OwnerId == UserInfo.getUserId()*/){
                    matrix.generate = true;
                }else if(sobj.get('DeveloperName') == 'MakePrimary' && /*proposalObj.OwnerId == UserInfo.getUserId() &&*/ proposalObj.Apttus_Proposal__Primary__c != true){
                    matrix.makePrimary = true;
                }else if(sobj.get('DeveloperName') == 'SendProposal' && /*proposalObj.OwnerId == UserInfo.getUserId() &&*/ proposalObj.Apttus_QPApprov__Approval_Status__c != 'Approved'){
                    matrix.sendProposal = true;
                }else if(sobj.get('DeveloperName') == 'ReadOnlyCart' && ((proposalObj.Apttus_QPApprov__Approval_Status__c == 'Not Submitted' && collaborationRequestRecords.size() > 0) || configRecords.size() > 0)){
                    matrix.readOnlyCart = true;
                }else if(sobj.get('DeveloperName') == 'Preview'){
                    matrix.preview = true;
                }else if(sobj.get('DeveloperName') == 'SynchronizeWithOpportunity' && /*proposalObj.OwnerId == UserInfo.getUserId() &&*/ proposalObj.Apttus_Proposal__Primary__c == true && proposalObj.Apttus_QPApprov__Approval_Status__c == 'Approved'){
                    matrix.synchronizeWithOpportunity = true;
                }else if(sobj.get('DeveloperName') == 'SendForCongaSign'){
                    matrix.congaSign = true;
                }else if(sobj.get('DeveloperName') == 'Approvals' && /*proposalObj.OwnerId == UserInfo.getUserId() &&*/ (proposalObj.Apttus_QPApprov__Approval_Status__c == 'Pending Approval' || proposalObj.Apttus_QPApprov__Approval_Status__c == 'Approved' || proposalObj.Apttus_QPApprov__Approval_Status__c == 'Rejected')){
                    matrix.approvals = true;
                }else if(sobj.get('DeveloperName') == 'MyApprovals' && psaRecord.size() > 0 && (proposalObj.Apttus_QPApprov__Approval_Status__c == 'Pending Approval' || proposalObj.Apttus_QPApprov__Approval_Status__c == 'Approved' || proposalObj.Apttus_QPApprov__Approval_Status__c == 'Rejected')){
                    matrix.myApprovals = true;
                }else if(sobj.get('DeveloperName') == 'CreateAgreement' && /*proposalObj.OwnerId == UserInfo.getUserId() &&*/ proposalObj.Apttus_Proposal__Approval_Stage__c == 'Accepted' && (proposalObj.Apttus_QPConfig__ABOType__c == null || proposalObj.Apttus_QPConfig__ABOType__c == 'Trial Conversion')){
                    matrix.CreateAgreement = true;
                }else if(sobj.get('DeveloperName') == 'Cancel' /*&& proposalObj.OwnerId == UserInfo.getUserId()*/){
                    matrix.Cancel = true;
                }else if(sobj.get('DeveloperName') == 'Present' /*&& proposalObj.Apttus_QPApprov__Approval_Status__c != 'Approved'*/ && proposalObj.Apttus_Proposal__Approval_Stage__c != 'Accepted' && proposalObj.APTS_Primary_Contact__c != null){
                    matrix.accept = true;
                }
            }
            system.debug('matrix => '+matrix);
            return matrix;
        } else {
            return null;
        }
    }   

    /**
     * Returns true if there is a Product Configuration, related to the Quote/Proposal
     */
    @AuraEnabled
    public static Boolean getProductConfiguration(Id proposalId) {
        System.debug('getProductConfiguration');

        List<Apttus_Config2__ProductConfiguration__c> prodConfigs 
            = [SELECT Id,
                Apttus_Config2__Status__c
                FROM Apttus_Config2__ProductConfiguration__c
                WHERE
                Apttus_QPConfig__Proposald__c =: proposalId 
                LIMIT 1];

        if(!prodConfigs.isEmpty()) {
            return true;
        } else {
            return false;
        }
    }
    
    @AuraEnabled
    public static string updateProposalStatus(Id proposalId, string status)
    {
        system.debug('GGInside');
        
        Apttus_Proposal__Proposal__c prop = new Apttus_Proposal__Proposal__c();
        prop.Id = proposalId;
        prop.Apttus_Proposal__Approval_Stage__c = status;
    
        if(status != 'Accepted')
        {
        	prop.Apttus_QPApprov__Approval_Status__c = status;    
        }
              
        try{
        	update prop;
        	return 'SUCCESS';    
        }
        catch(Exception e){
         	return e.getStackTraceString();   
        }
    }
}