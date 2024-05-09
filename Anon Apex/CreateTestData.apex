//  Anonymous apex

//  Delete Test Data 

// Delete all information 

List<Contact> contacts1 = [ Select ID from contact];
delete contacts1;

List<SEPA_Batch__c> SepaBatches1 = [ Select ID from SEPA_Batch__c];
delete SepaBatches1;

List<Opportunity> donations1 = [Select Id	 from Opportunity  ];
Delete donations1;

List<npe03__Recurring_Donation__c> recurDonations1 = [Select Id	 from npe03__Recurring_Donation__c  ];
Delete recurDonations1;

date firstPaymentdate = system.Today();


List <string> endToEndIds = new list<string>();
endToEndIds.add('985280-10386210-190221144429');
endToEndIds.add('D2D2013-190221144429');
endToEndIds.add('990624-84020570-190221144429');
system.debug('end to end Ids' + endToEndIds );
ID firstBatchRecordTypeID = Schema.SObjectType.SEPA_Batch__c.getRecordTypeInfosByDeveloperName().get('First').getRecordTypeId();

//  Create a contact
List<Contact> contacts = new List<Contact>();

for (Integer i = 0; i < 50; i++) {
    contacts.add(new contact (firstName = 'TestFN' + i,  lastName = 'TestLN' + i));
}
// contacts.add (new contact (firstName = 'Test ',  lastName = 'One'));
// contacts.add (new contact (firstName = 'Test ',  lastName = 'Two'));
// contacts.add (new contact (firstName = 'Test ',  lastName = 'Three'));

insert contacts;

// recurring Donations
List<npe03__Recurring_Donation__c> RecurringDonations = new List<npe03__Recurring_Donation__c>();

for (contact oneContact :Contacts) {
    RecurringDonations.add (new npe03__Recurring_Donation__c (
    Name = 'Test' + contact.firstName
    ,npe03__Amount__c = 100
    ,npe03__Contact__c = oneContact.id
    ,npe03__Date_Established__c = firstPaymentdate
    ,npe03__Open_Ended_Status__c = 'Open'
    ,npe03__Installment_Period__c = 'Monthly'
    ,npe03__Installments__c = 1
    ,npe03__Schedule_Type__c='Multiply By'
    ,SEPA_transaction_code__c = 'RCUR'
    ,Date_Mandate_Signed__c = firstPaymentdate
    ,BIC__c = 'BICTEST'
    ,IBAN__c = 'IBANTEST'
    , SEPA_Direct_Debit__c = true
    ,Bank_Account_Name__c = oneContact.lastName
    )
    );

}

insert RecurringDonations;

list<opportunity> opplist= [select id, closedate from Opportunity where closedate != :date.newinstance(2020, 1, 26) limit 1000];
for (opportunity opp : opplist) {
    opp.closedate = date.newinstance(2020, 1, 26);
}

update opplist;

firstPaymentdate = system.Today() + 3;
firstBatchRecordTypeID = Schema.SObjectType.SEPA_Batch__c.getRecordTypeInfosByDeveloperName().get('First').getRecordTypeId();
// Create SEPA Batch 
SEPA_Batch__c sepaBatch = new SEPA_Batch__c(
RecordTypeId = firstBatchRecordTypeID
,Number_of_donations_posted__c = 0
,Collection_Date__c = firstPaymentdate
);

insert sepaBatch;

opplist= [select id, closedate from Opportunity where closedate != :date.newinstance(2020, 1, 26) limit 1000];
for (opportunity opp : opplist) {
    opp.closedate = date.newinstance(2020, 1, 26);
}

update opplist;
