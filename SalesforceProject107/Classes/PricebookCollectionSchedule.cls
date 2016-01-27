/**
	Scheduler class for PricebookCollectionBatch
*/
global class PricebookCollectionSchedule implements Schedulable {

	global void execute(SchedulableContext sc) {
		Database.executeBatch(new PricebookCollectionBatch(), 2000);
	}

	public static void scheduleJob() {
		//The following command schedules this job every 2 hrs Mon-Fri.
		System.schedule(getUniqueJobName('PricebookSyncJob'), '0 0 0,2,4,6,8,10,12,14,16,18,20,22 ? JAN-DEC MON-FRI', new PricebookCollectionSchedule());
	}
	
    private static String getUniqueJobName(String batchApexName) {
        System.debug('batchApexName: ' + batchApexName);
        String uniqueJobName = batchApexName + '_' + System.now().format('yyyy-MM-dd_k:m:s');
        System.debug('uniqueJobName: ' + uniqueJobName);
        return uniqueJobName;
    }
	 
}