// Populate SEPA Settings for Enable Ireland

insert new SEPA_Settings__c();

SEPA_Settings__c sepaSettings = SEPA_Settings__c.getOrgDefaults();
sepaSettings.Invalid_characters__c = '[&]';
sepaSettings.SEPA_Batch_Size__c = 100;
sepaSettings.ROI_SEPA_OIN__c = 'IE01234567890';
sepaSettings.ROI_IBAN__c = 'IE01234567890123456789';
sepaSettings.ROI_BIC__c  = '01234567';
sepaSettings.Is_Bank_of_Ireland__c = false;
sepaSettings.Bank_Account_Name__c = 'BANK ACCOUNT NAME';
sepaSettings.Remittance_Text__c = 'REMITTANCE TEXT';
sepaSettings.Process_Hard_Rejects__c = true;
sepaSettings.Batch_Mode__c = true;
sepaSettings.Number_of_Days_Before_Collection_Date__c = 2;
sepaSettings.Number_of_Presentations__c = 2; // Maximum number of presentations
sepaSettings.SEPA_File_Batch_Size__c = 2500;
sepaSettings.Selection_Days__c = '5,10,15,20';

update sepaSettings;