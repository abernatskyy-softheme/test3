@isTest
private class Test_UpdateOpportunityPricingTierCtrl {
	testMethod static void testCase1() {
		
		Pricebook2 pb = new Pricebook2(Name='test pricebook1109', IsActive=true, Description='test description');
		insert pb;

		Pricebook2 pb2 = new Pricebook2(Name='test pricebook3409', IsActive=true, Description='test description');
		insert pb2;
		
		Pricebook__c pbClone = new Pricebook__c(Base_Pricebook_Record_Id__c=pb.Id, Name=pb.Name, Active__c=true);
		insert pbClone;

		Pricebook__c pbClone2 = new Pricebook__c(Base_Pricebook_Record_Id__c=pb2.Id, Name=pb2.Name, Active__c=true);
		insert pbClone2;
		
		Account acct = new Account(Name='test account', Pricebook__c=pbClone.Id);
		insert acct;

		Opportunity opp = new Opportunity(Name='test opportunity', AccountId=acct.id,  
				StageName='Prospect', CloseDate=System.today());
		insert opp;
		opp = [Select Id, Pricebook2Id from Opportunity where Id=:opp.Id];

		pb = [Select Id from Pricebook2 where Id=:opp.Pricebook2Id];

		Pricebook2 spb = [Select Id from Pricebook2 where IsStandard=true limit 1];
		
		Product2 p = new Product2(Name='test product', IsActive=true, ProductCode='xx', Description='test');
		insert p;
		
		PricebookEntry spbe = new PriceBookEntry(Product2Id=p.Id, Pricebook2Id=spb.Id, UnitPrice=100.98, IsActive=True);
		insert spbe;
		
		PricebookEntry pbe = new PriceBookEntry(Product2Id=p.Id, Pricebook2Id=pb.Id, UnitPrice=100.98, IsActive=True);
		insert pbe;

		OpportunityLineItem oli = new OpportunityLineItem(OpportunityId=opp.Id, PricebookEntryId=pbe.Id, Quantity=2, TotalPrice=1000.98);
		insert oli;
				
		Test.startTest();
		ApexPages.currentPage().getParameters().put('id', opp.Id);
		UpdateOpportunityPricingTierController ctrol = new UpdateOpportunityPricingTierController();
		ctrol.selectedPricebookId = pbClone2.Id;
		ctrol.applyToAccount = true;
		ctrol.updatePricebook();
		ctrol.cancel();

		Test.stopTest();
		
	}
}