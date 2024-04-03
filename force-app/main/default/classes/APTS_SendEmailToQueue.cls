global class APTS_SendEmailToQueue {
	global class DataWrapper {
		@InvocableVariable(label='Record ID' required=true)
		public String recordID;
		@InvocableVariable(label='Email Template ID' required=true)
		public String emailTemplateID;
		@InvocableVariable(label='Queue Name' required=false)
		public String queueName;
	}

	@invocableMethod(label='Send Email to Queue')
	global static void sendMailToQueue(List<DataWrapper> passedData) {
        DataWrapper data = passedData[0];
		List<GroupMember> queueMembers = [SELECT Id, UserOrGroupId FROM GroupMember WHERE Group.Name = :data.queueName];

		List<string> userIdList = new List<string>();

		if (queueMembers != null && queueMembers.size() > 0) {
			for (GroupMember gm : queueMembers) {
				if (string.valueOf(gm.UserOrGroupId).startsWith('005')) {
					userIdList.add(gm.UserOrGroupId);
				}
			}
		}

		List<User> users = [SELECT Id, Email FROM User WHERE Id IN :userIdList];

		for (User user : users) {
			// Messaging.SingleEmailMessage mailToSend = new Messaging.SingleEmailMessage();
			// //mailToSend.setTargetObjectId(data.contactID);
			// mailToSend.setWhatId(data.recordID);
			// mailToSend.setTemplateID(data.emailTemplateID);
			// List<Messaging.SendEmailResult> sendResults = Messaging.sendEmail(new List<Messaging.Email>{ mailToSend });
			// System.debug(sendResults[0]);
		}
	}
}
