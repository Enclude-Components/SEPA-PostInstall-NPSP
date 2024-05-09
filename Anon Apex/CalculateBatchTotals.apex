//  Test update of Batch Totals
ID firstBatchRecordTypeID = Schema.SObjectType.SEPA_Batch__c.getRecordTypeInfosByDeveloperName().get('First').getRecordTypeId();
ID representBatchRecordTypeID = Schema.SObjectType.SEPA_Batch__c.getRecordTypeInfosByDeveloperName().get('Representation').getRecordTypeId();
ID rejectBatchRecordTypeID = Schema.SObjectType.SEPA_Batch__c.getRecordTypeInfosByDeveloperName().get('Rejects').getRecordTypeId();

ID SepaBatchID = [ Select ID from SEPA_Batch__c where RecordTypeId = :rejectBatchRecordTypeID limit 1].id;
SEPA_Batch__c sepaBatch = SEPAUtility.getBatch(SepaBatchID);
SEPAUtility.updateBatchTotals(sepaBatch);