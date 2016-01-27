@isTest
private class Test_OpportunitySetPricebook_Trigger {
	testMethod static void testCase() {
		Pricebook2 pb = new Pricebook2(Name='test pricebook1', IsActive=true, Description='test description');
		insert pb;
		
		Pricebook__c customPb = new Pricebook__c(Active__c=true, Name='test pricebook', Base_Pricebook_Record_Id__c=pb.Id, Description__c='test description');
		insert customPb;

		Account acct = new Account(Name='test account', Pricebook__c=customPb.Id);
		insert acct;
		
		Test.startTest();
		Opportunity opp = new Opportunity(Name='test opportunity', AccountId=acct.id, StageName='Prospect', CloseDate=System.today());
		insert opp;
		Test.stopTest();
		opp = [Select Id, Pricebook2Id from Opportunity where Id=:opp.Id];
		System.assert(opp.Pricebook2Id == pb.Id);
	}
}