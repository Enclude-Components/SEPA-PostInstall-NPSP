/********************
 * Install reject codes
 */
    list<enc_sepa2__SEPA_Reject_Codes__c> deleteRejectCodes = [
        SELECT ID
        FROM enc_sepa2__SEPA_Reject_Codes__c
        WITH SECURITY_ENFORCED
    ];

    delete deleteRejectCodes;

    list<string> Codes = new List<string>();
    Codes.add('AC01');
    Codes.add('AC04');
    Codes.add('AC06');
    Codes.add('AG01');
    Codes.add('AG02');
    Codes.add('AM04');
    Codes.add('AM05');
    Codes.add('BE05');
    Codes.add('FF01');
    Codes.add('FF05');
    Codes.add('MD01');
    Codes.add('MD02');
    Codes.add('MD06');
    Codes.add('MD07');
    Codes.add('MS02');
    Codes.add('MS03');
    Codes.add('RC01');
    Codes.add('RR01');
    Codes.add('RR02');
    Codes.add('RR03');
    Codes.add('RR04');
    Codes.add('SL01');
    Codes.add('DNOR');
    Codes.add('CNOR');

    list<string> descr = new List<string>();
    descr.add('Account Identifier incorrect ( i.e. invalid IBAN )');
    descr.add(' Account closed');
    descr.add('Account blocked/account blocked for direct debit by Debtor');
    descr.add(
        'Direct Debit forbidden on this account for regulatory reasons'
    );
    descr.add('Operation/transaction code incorrect, invalid file format');
    descr.add('Insufficient funds');
    descr.add('Duplicate collection');
    descr.add('Identifier of the Creditor Incorrect');
    descr.add('Operation/transaction code incorrect, invalid file format');
    descr.add('Direct Debit type incorrect');
    descr.add('No Valid Mandate (cancelled, blocked or expired)');
    descr.add('Mandate data missing or incorrect');
    descr.add(' Disputed Authorized Transaction');
    descr.add('Debtor Deceased');
    descr.add('Refusal by the Debtor');
    descr.add('Reason not specified');
    descr.add('Bank Identifier Incorrect (i.e. invalid BIC)');
    descr.add('Regulatory Reason');
    descr.add(' Regulatory Reason');
    descr.add(' Regulatory Reason');
    descr.add(' Regulatory Reason');
    descr.add('Specific Service offered');
    descr.add('Debtor bank is not registered under this BIC in the CSM');
    descr.add('Creditor bank is not registered under this BIC in the CSM');

    list<string> type = new List<string>();
    type.add('Hard');
    type.add('Hard');
    type.add('Hard');
    type.add('Hard');
    type.add('Soft');
    type.add('Soft');
    type.add('Soft');
    type.add('Soft');
    type.add('Soft');
    type.add('Soft');
    type.add('Hard');
    type.add('Soft');
    type.add('Hard');
    type.add('Hard');
    type.add('Soft');
    type.add('Soft');
    type.add('Soft');
    type.add('Soft');
    type.add('Soft');
    type.add('Soft');
    type.add('Soft');
    type.add('Soft');
    type.add('Hard');
    type.add('Hard');

    list<enc_sepa2__SEPA_Reject_Codes__c> rejectCodes = new List<enc_sepa2__SEPA_Reject_Codes__c>();

    for (integer i = 0; i < codes.size(); i++) {
        rejectCodes.add(
            new enc_sepa2__SEPA_Reject_Codes__c(
                name = codes[i],
                enc_sepa2__Description__c = descr[i],
                enc_sepa2__Type__c = type[i]
            )
        );
    }

    insert rejectCodes;

/********************
 * Create SEPA Settings record
 */
    insert new enc_sepa2__SEPA_Settings__c();

    enc_sepa2__SEPA_Settings__c sepaSettings = enc_sepa2__SEPA_Settings__c.getOrgDefaults();
    sepaSettings.enc_sepa2__Invalid_characters__c = '[&]';
    sepaSettings.enc_sepa2__SEPA_Batch_Size__c = 100;
    sepaSettings.enc_sepa2__ROI_SEPA_OIN__c = 'IE01234567890';
    sepaSettings.enc_sepa2__ROI_IBAN__c = 'IE01234567890123456789';
    sepaSettings.enc_sepa2__ROI_BIC__c  = '01234567';
    sepaSettings.enc_sepa2__Is_Bank_of_Ireland__c = false;
    sepaSettings.enc_sepa2__Bank_Account_Name__c = 'BANK ACCOUNT NAME';
    sepaSettings.enc_sepa2__Remittance_Text__c = 'REMITTANCE TEXT';
    sepaSettings.enc_sepa2__Process_Hard_Rejects__c = true;
    sepaSettings.enc_sepa2__Batch_Mode__c = true;
    sepaSettings.enc_sepa2__Number_of_Days_Before_Collection_Date__c = 2;
    sepaSettings.enc_sepa2__Number_of_Presentations__c = 2; // Maximum number of presentations
    sepaSettings.enc_sepa2__SEPA_File_Batch_Size__c = 2500;
    sepaSettings.enc_sepa2__Selection_Days__c = '5,10,15,20';

    update sepaSettings;

/********************
 * Create test data
 */
    /* date firstPaymentdate = system.Today();

    Id firstBatchRecordTypeID = Schema.SObjectType.enc_sepa2__SEPA_Batch__c.getRecordTypeInfosByDeveloperName().get('First').getRecordTypeId();

    //  Create a contact
    List<Contact> contacts = new List<Contact>();

    for (Integer i = 0; i < 50; i++) {
        contacts.add(new contact (firstName = 'SepaTestFN' + i,  lastName = 'SepaTestLN' + i));
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
        ,enc_sepa2__SEPA_transaction_code__c = 'RCUR'
        ,enc_sepa2__Date_Mandate_Signed__c = firstPaymentdate
        ,enc_sepa2__BIC__c = 'BICTEST'
        ,enc_sepa2__IBAN__c = 'IBANTEST'
        ,enc_sepa2__SEPA_Direct_Debit__c = true
        ,enc_sepa2__Bank_Account_Name__c = oneContact.lastName
        )
        );

    }

    insert RecurringDonations; */