@isTest
private class Test_PricebookCollectionBatch {
	testMethod static void testPBInsert() {
		Pricebook2 pb = new Pricebook2(Name='test pricebook1', IsActive=true, Description='test description');
		insert pb;
		
		Test.startTest();
		Database.executeBatch(new PricebookCollectionBatch(), 1000);
		Test.stopTest();
		Integer newlyCreated = [Select count() from Pricebook__c where Base_Pricebook_Record_Id__c=:pb.Id];
		System.assert(newlyCreated == 1);
	}
	testMethod static void testPBUpdate() {
		Pricebook2 pb = new Pricebook2(Name='test pricebook1', IsActive=true, Description='test description');
		insert pb;
		Pricebook__c pbClone = new Pricebook__c(Base_Pricebook_Record_Id__c=pb.Id, Name=pb.Name, Active__c=false);
		insert pbClone;
		
		Test.startTest();
		Database.executeBatch(new PricebookCollectionBatch(), 1000);
		Test.stopTest();
		pbClone = [Select Id, Active__c, Description__c from Pricebook__c where Id=:pbClone.Id];
		System.assert(pbClone.Active__c == true);
		System.assert(pbClone.Description__c == pb.Description);
	}
	testMethod static void testPBDelete() {
		Pricebook2 pb = new Pricebook2(Name='test pricebook1', IsActive=true, Description='test description');
		insert pb;
		Pricebook__c pbClone = new Pricebook__c(Base_Pricebook_Record_Id__c=pb.Id, Name=pb.Name, Active__c=false);
		insert pbClone;
		delete pb;
		
		Test.startTest();
		Database.executeBatch(new PricebookCollectionBatch(), 1000);
		Test.stopTest();
		Integer deletedCnt = [Select count() from Pricebook__c where Id=:pbClone.Id];
		System.assert(deletedCnt == 0);
	}
}