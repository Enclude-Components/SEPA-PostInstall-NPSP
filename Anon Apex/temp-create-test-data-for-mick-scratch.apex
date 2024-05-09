/********************
 * Create test data
 */
date firstPaymentdate = system.Today();

// Id firstBatchRecordTypeID = Schema.SObjectType.SEPA_Batch__c.getRecordTypeInfosByDeveloperName().get('First').getRecordTypeId();

//  Create a contact
List<Contact> contacts = new List<Contact>();

for (Integer i = 0; i < 25; i++) {
    contacts.add(new contact (
        firstName = 'SepaTestFN' + i,
        lastName = 'SepaTestLN' + i,
        BIC__c = 'BICTEST' + i,
        IBAN__c = 'IBANTEST' + i,
        Bank_Account_Name__c = 'ACCOUNTNAMETEST' + i
    ));
}

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
    ,npe03__Installments__c = 3
    ,npe03__Schedule_Type__c='Multiply By'
        // ,SEPA_transaction_code__c = 'RCUR'
    // ,Date_Mandate_Signed__c = firstPaymentdate
        // ,BIC__c = 'BICTEST'
        // ,IBAN__c = 'IBANTEST'
    // ,SEPA_Direct_Debit__c = true
        // ,Bank_Account_Name__c = oneContact.lastName
    )
    );

}

insert RecurringDonations;

List<npe03__Recurring_Donation__c> recDonList = [SELECT id FROM npe03__Recurring_Donation__c];

for (npe03__Recurring_Donation__c recDon : recDonList) {
    recDon.enc_sepa2__Date_Mandate_Signed__c = 'RCUR';
    recDon.enc_sepa2__SEPA_Direct_Debit__c = true;
}

update recDonList