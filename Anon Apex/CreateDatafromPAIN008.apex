//  this creates contacts and recurring donations for PAIN008 files
// Used for Take on - not part of package

list <SEPA_Transactions__c> rejectTxns = [Select id, End_to_End_ID__c from SEPA_Transactions__c ];
System.debug ('rejectTxns :' + rejectTxns);
List <String> EndToEndIDs = new list <String>();

  
 for (SEPA_Transactions__c oneTxn :rejectTxns){
    
     if (oneTxn.End_to_End_ID__c <> null) {
        // System.debug ('oneE2EId :' + oneTxn.End_to_End_ID__c);
        
         string oneE2Eid = oneTxn.End_to_End_ID__c;
        // System.debug ('oneE2EId1 :' + oneE2Eid);
        EndToEndIDs.add (oneE2Eid);
    }
    }
System.debug ('EndtoEndIDs :' + EndtoEndIds.size());
    
List<SEPAPAIN008Upload__c> PAIN008s = [Select ID, IBAN__c
    , BIC__c, Mandate_ID__c, Date_Mandate_Signed__c , Debtor_Name__c, EndtoEndID__c, Amount_Text__c 
    from SEPAPAIN008Upload__c where EndtoEndID__c = 'D2D2013-190404143128' ];
    
System.debug ('PAIN008Size :' + PAIN008s.size());

for (SEPAPAIN008Upload__c oneUpload :PAIN008s){
    
    System.debug('E2E' + oneUpload.EndtoEndID__c + '_' + oneUpload.IBAN__c + '_'  + oneUpload.Amount_Text__c  + '_'  + oneUpload.Debtor_Name__c );
    
    }
    

List<Contact> contacts1 = [ Select ID from contact];
delete contacts1;

List<SEPA_Batch__c> SepaBatches1 = [ Select ID from SEPA_Batch__c];
delete SepaBatches1;

List<Opportunity> donations1 = [Select Id	 from Opportunity  ];
Delete donations1;

List<npe03__Recurring_Donation__c> recurDonations1 = [Select Id	 from npe03__Recurring_Donation__c  ];
Delete recurDonations1;

date firstPaymentdate = Date.newInstance(2019, 05, 13);
//******!!Run this if running in Batch if there are a lot of PAIN008s selected
//CreateDataFromPAIN008Batch sepaSend = new CreateDataFromPAIN008Batch(); 
//Database.executeBatch(sepaSend, 100);

// ******!!Run this if only testing a few donations (LIMIT)
    

    //  Create Contacts
    List<Contact> contacts = new List<Contact>();
    for (SEPAPAIN008Upload__c onePAIN008 :PAIN008s){
    contacts.add (new contact (lastName = onePAIN008.Debtor_Name__c));
    }
    insert contacts;

    // use the last name to get the Contact whne creating recurring DD
    map <string,id>  mapContactNameToId = new map <string, id> ();
    List <contact> contacts2 = [Select ID, lastName from contact ];
    for (contact oneContact :contacts2){
    mapContactNameToId.put (oneContact.lastName,  oneContact.id);
    }


// recurring Donations
    List<npe03__Recurring_Donation__c> RecurringDonations = new List<npe03__Recurring_Donation__c>();

    for (SEPAPAIN008Upload__c onePAIN008 :PAIN008s){ 
        RecurringDonations.add (new npe03__Recurring_Donation__c (
         Name = onePAIN008.Debtor_Name__c
        ,Manual_Mandate_Reference__c = onePAIN008.Mandate_ID__c
        ,Date_Mandate_Signed__c = onePAIN008.Date_Mandate_Signed__c
        ,BIC__c = onePAIN008.BIC__c
        ,IBAN__c = onePAIN008.IBAN__c
        ,SEPA_Direct_Debit__c = true
        ,Bank_Account_Name__c = onePAIN008.Debtor_Name__c

        ,npe03__Amount__c = decimal.valueOf(onePAIN008.Amount_Text__c)
        ,npe03__Contact__c = mapContactNameToId.get(onePAIN008.Debtor_Name__c)
        ,npe03__Date_Established__c = firstPaymentdate
        ,npe03__Open_Ended_Status__c = 'Open'
        ,npe03__Installment_Period__c = 'Monthly'
        ,npe03__Installments__c = 3
        ,npe03__Schedule_Type__c='Multiply By'));

    }

    insert RecurringDonations;
    
    
    // Create SEPA Batch 
    ID firstBatchRecordTypeID = Schema.SObjectType.SEPA_Batch__c.getRecordTypeInfosByDeveloperName().get('First').getRecordTypeId();
    SEPA_Batch__c sepaBatch = new SEPA_Batch__c(
    RecordTypeId = firstBatchRecordTypeID
    ,Number_of_donations_posted__c = 0
    ,Collection_Date__c = firstPaymentdate
    );
    insert sepaBatch;
