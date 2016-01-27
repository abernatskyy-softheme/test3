/**
	Performs 'before insert' related initialization activities.
		- populates pricebook id on opportunity record based on custom pricebook lookup field
*/
trigger Opportunity_SetPricebook on Opportunity (before insert) {
	Set<Id> acctIds = new Set<Id>();
	for (Opportunity opp : Trigger.new) {
		acctIds.add(opp.AccountId);
	}
	
	Map<Id, Account> acctMap = new Map<Id, Account>([Select Id, Pricebook__r.Base_Pricebook_Record_Id__c from Account where Id in :acctIds]);
	
	for (Opportunity opp : Trigger.new) {
		System.debug('opportunity: ' + opp);
		Account acct = acctMap.get(opp.AccountId);
		System.debug('assigning pricebook id ' + acct.Pricebook__r.Base_Pricebook_Record_Id__c + ' to opportunity');
		opp.Pricebook2Id = acct.Pricebook__r.Base_Pricebook_Record_Id__c;
	}
}