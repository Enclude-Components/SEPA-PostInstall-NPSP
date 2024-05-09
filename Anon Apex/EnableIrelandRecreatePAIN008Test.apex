// Used to Test generation of SEPA file for Enable Ireland
// Before running
//  Run the Delete Test Data Anon apex
//  Upload the PAIN008 file

date firstPaymentdate = Date.newInstance(2019, 05, 13);

// CREATE THE CONTACTS AND RECURRING DONATIONS
//
//******!!Run this if running in Batch if there are a lot of PAIN008s selected
//CreateDataFromPAIN008Batch sepaSend = new CreateDataFromPAIN008Batch(); 
//Database.executeBatch(sepaSend, 100);
// ******!!Run the remaining code  if only testing a few donations (LIMIT)
    List<SEPAPAIN008Upload__c> PAIN008s = [Select ID, IBAN__c, InstrId__c
    , BIC__c, Mandate_ID__c, Date_Mandate_Signed__c , Debtor_Name__c, EndtoEndID__c, Amount_Text__c 
    from SEPAPAIN008Upload__c ];

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

    

