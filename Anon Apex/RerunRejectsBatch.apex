//  This resets a Reject Batch that was completed

ID rejectBatchRecordTypeID = Schema.SObjectType.SEPA_Batch__c.getRecordTypeInfosByDeveloperName().get('Rejects').getRecordTypeId();

SEPA_Batch__c sepaBatch = [select Id
       ,Collection_Date__c
    ,Status__c
    ,Date_Last_Run__c
    ,RecordTypeId
    from SEPA_Batch__c where RecordTypeId=:rejectBatchRecordTypeID 
    and Status__c = 'Completed' limit 1  ];  

    
// Get list of donations to update

list <SEPA_Transactions__c> transactions = [select Id
        , Donation__c
        , Batch__c 
        , Sucess__c
        from SEPA_Transactions__c where Batch__c=:sepaBatch.ID and Sucess__c = true];  

List<ID> DonationIDs = new list<ID>();
For (SEPA_Transactions__c t :transactions){
    DonationIDs.add(t.Donation__c);
}

list <Opportunity> donations = [select Id , StageName from Opportunity where ID in :DonationIDs]; 

For (Opportunity o :donations){
    o.StageName = label.Posted_Stage;
}

upsert donations;

sepaBatch.Status__c = 'Ready';
sepaBatch.Date_Last_Run__c = null;
upsert sepaBatch;