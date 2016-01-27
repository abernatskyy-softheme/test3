/**
    Controller class which is used to update pricing tier value on opportunity record. 
    This is invoked from opportunity record using a custom link or button.
*/
public with sharing class UpdateOpportunityPricingTierController {
    public Opportunity opp {get; set;}
    public Boolean applyToAccount {get; set;}
    public List<SelectOption> pricebookOptions {get; set;}
    public String selectedPricebookId {get; set;}
    public List<OpportunityLineItem> existingProducts {get; set;}

    private Map<Id, Pricebook__c> pbMap;
    private String preSelectedPricebookId {get; set;}
    
    public UpdateOpportunityPricingTierController() {
        String oppId = ApexPages.currentPage().getParameters().get('id');
        System.debug('oppId: ' + oppId);
        load(oppId);
    }
    
    public PageReference updatePricebook() {
        System.debug('selectedPricebookId: ' + selectedPricebookId);
        System.debug('preSelectedPricebookId: ' + preSelectedPricebookId);
        
        if (selectedPricebookId != null) {
            if (existingProducts.size() > 0 && preSelectedPricebookId != selectedPricebookId) {
                System.debug('trying to delete existing opportunity line items: ' + existingProducts.size());
                delete existingProducts;
            }
            
            if (preSelectedPricebookId != selectedPricebookId) {
                System.debug('trying to update pricebook on opportunity');
                opp.Pricebook2Id = pbMap.get(selectedPricebookId).Base_Pricebook_Record_Id__c;
                update opp;
            }
            
            if (applyToAccount == true) {
                Account acct = new Account(Id=opp.AccountId, Pricebook__c=selectedPricebookId);
                update acct;
            }
        }
        return new PageReference('/' + opp.Id);
    }
    
    public PageReference cancel() {
        return new PageReference('/' + opp.Id);
    }
    
    public String getHasExistingProducts() {
        return existingProducts.size() > 0 ? 'Yes' : 'No';
    }
    
    private void load(String oppId) {
        opp = [Select Id, Name, AccountId, Account.Pricebook__c, Pricebook2Id from Opportunity where Id=:oppId];
        System.debug('opp: ' + opp);
        
        existingProducts = [Select Id from OpportunityLineItem where OpportunityId=:opp.Id];
        System.debug('existingProducts: ' + existingProducts);
        
        loadPricebookOptions();
        applyToAccount = false;
    }
    
    private void loadPricebookOptions() {
        pbMap = new Map<Id, Pricebook__c>();
        List<Pricebook__c> pbList = [Select Id, Name, Base_Pricebook_Record_Id__c from Pricebook__c where Active__c=true order by Name];
        pricebookOptions = new List<SelectOption>();
        for (Pricebook__c pb : pbList) {
            pbMap.put(pb.Id, pb);
            if (pb.Base_Pricebook_Record_Id__c == opp.Pricebook2Id) {
                selectedPricebookId = pb.Id;                
                preSelectedPricebookId = pb.Id;             
            }
            pricebookOptions.add(new SelectOption(pb.Id, pb.Name));
        }
        System.debug('pricebookOptions: ' + pricebookOptions);
    } 
}