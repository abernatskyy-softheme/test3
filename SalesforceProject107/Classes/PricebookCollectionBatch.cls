/**
	Responsible to sync Pricebook__c object by copying all records from the native pricebook2 object.
	Date: 2/18/2011
*/
global class PricebookCollectionBatch implements Database.Batchable<SObject> {
	 global Database.QueryLocator start(Database.BatchableContext bc){ 
	 	String sql = 'SELECT IsActive, Description, Id, Name FROM Pricebook2';
	 	System.debug('sql: ' + sql);
        return Database.getQueryLocator(sql);
	 }
	 
	 global void execute(Database.BatchableContext bc, List<SObject> rows){
			System.debug('pricebook batch process starts');	 		
	 		Map<String, Pricebook__c> pbCloneMap = prepareCloneMap();
			List<Pricebook2> pbOrigList = (List<Pricebook2>) rows;
			
			List<Pricebook__c> pbListToInsert = new List<Pricebook__c>();
			List<Pricebook__c> pbListToUpdate = new List<Pricebook__c>();
			List<Pricebook__c> pbListToDelete = new List<Pricebook__c>();
			
			//identify new & existing pricebooks
			for (Pricebook2 pbOrig : pbOrigList) {
				Pricebook__c pbClone = pbCloneMap.get(pbOrig.Id);
				if (pbClone == null) {  //new pricebook
					pbListToInsert.add(prepareNewPBClone(pbOrig));
				}
				else {  //existing pricebook
					if (isDataChanged(pbClone, pbOrig)) {
						pbListToUpdate.add(prepareExistPBCloneFromOrig(pbClone, pbOrig));
					}
				}
			}				 	
			
			//identify obsolete pricebooks
			Map<Id, Pricebook2> pbOrigMap = new Map<Id, Pricebook2>(pbOrigList);
			for (Pricebook__c pbClone : pbCloneMap.values()) {
				Pricebook2 pbOrig = pbOrigMap.get(pbClone.Base_Pricebook_Record_Id__c);
				if (pbOrig == null) {
					pbListToDelete.add(pbClone);
				}
			}
			
			System.debug('pbListToInsert: ' + pbListToInsert);
			System.debug('pbListToUpdate: ' + pbListToUpdate);
			System.debug('pbListToDelete: ' + pbListToDelete);
			
			if (pbListToInsert.size() > 0) insert pbListToInsert;
			if (pbListToUpdate.size() > 0) update pbListToUpdate;
			if (pbListToDelete.size() > 0) delete pbListToDelete;
			
	 		System.debug('pricebook batch process ends');
	 }
	 
	 private Map<String, Pricebook__c> prepareCloneMap() {
	 	List<Pricebook__c> pbCloneList = [Select Id, Name, Active__c, Description__c, Base_Pricebook_Record_Id__c from Pricebook__c];
	 	System.debug('pbCloneList: ' + pbCloneList);
	 	Map<String, Pricebook__c> pbCloneMap = new Map<String, Pricebook__c>();
	 	for (Pricebook__c pb : pbCloneList) {
	 		pbCloneMap.put(pb.Base_Pricebook_Record_Id__c, pb);
	 	}
	 	System.debug('pbCloneMap: ' + pbCloneMap);
	 	return pbCloneMap;
	 }
	 global void finish(Database.BatchableContext bc){
	 	
	 }
	 
	 /* PRIVATE METHODS */
	 private Pricebook__c prepareNewPBClone(Pricebook2 pbOrig) {
	 	Pricebook__c pbClone = new Pricebook__c();
	 	pbClone.Name = pbOrig.Name;
	 	pbClone.Active__c = pbOrig.IsActive;
	 	pbClone.Description__c = pbOrig.Description;
	 	pbClone.Base_Pricebook_Record_Id__c = pbOrig.Id;
	 	return pbClone;
	 }
	 private Boolean isDataChanged(Pricebook__c pbClone, Pricebook2 pbOrig) {
	 	return pbClone.Name != pbOrig.Name || pbClone.Active__c != pbOrig.IsActive || pbClone.Description__c != pbOrig.Description;
	 }
	 private Pricebook__c prepareExistPBCloneFromOrig(Pricebook__c pbClone, Pricebook2 pbOrig) {
	 	pbClone.Name = pbOrig.Name;
	 	pbClone.Active__c = pbOrig.IsActive;
	 	pbClone.Description__c = pbOrig.Description;
	 	return pbClone;
	 }

}