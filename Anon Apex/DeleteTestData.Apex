//  Delete Test Data 

// Delete all information 
List<SEPAPAIN008Upload__c> delPAIN008 = [ Select ID from SEPAPAIN008Upload__c limit 10000];
delete delPAIN008;

List<Contact> contacts = [ Select ID from contact];
delete contacts;

List<SEPA_Batch__c> SepaBatches = [ Select ID from SEPA_Batch__c];
delete SepaBatches;

List<Opportunity> donations = [Select Id	 from Opportunity  ];
Delete donations;

List<npe03__Recurring_Donation__c> recurDonations = [Select Id	 from npe03__Recurring_Donation__c  ];
Delete recurDonations;