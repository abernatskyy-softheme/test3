@isTest
private class Test_PricebookCollectionSchedule {
	testMethod static void testCase() {
		Test.startTest();
		System.schedule('pricebook sync test job', '0 0 6-20 ? JAN-DEC MON-FRI', new PricebookCollectionSchedule());
		PricebookCollectionSchedule.scheduleJob();
		Test.stopTest();
	}
}