// Enable Ireland Test: Update Opportunities with End To End ID and Instrid 
// in order to create a PAIN008 file for testing

date firstPaymentdate = Date.newInstance(2019, 05, 23);

List<SEPAPAIN008Upload__c> PAIN008s = [Select ID, IBAN__c, InstrId__c
    , BIC__c, Mandate_ID__c, Date_Mandate_Signed__c , Debtor_Name__c, EndtoEndID__c, Amount_Text__c 
    from SEPAPAIN008Upload__c ];

    map<string, string> mapEndToEndIds = new map <string, string>();
     map<string, string> mapInstrIds = new map <string, string>();

for (SEPAPAIN008Upload__c onePAIN008 :PAIN008s){ 
mapEndToEndIds.put(onePAIN008.Mandate_ID__c,onePAIN008.EndtoEndID__c );
mapInstrIds.put(onePAIN008.Mandate_ID__c,onePAIN008.InstrId__c );

}

system.debug(mapEndToEndIds);


List<Opportunity> donations = [Select ID, End_to_End_ID__c, InstrId__c, Mandate_Reference__c	
    from Opportunity where CloseDate = : firstPaymentdate];

for (Opportunity onedonation :donations){ 
onedonation.End_to_End_ID__c = mapEndToEndIds.get(onedonation.Mandate_Reference__c);
onedonation.InstrId__c = mapInstrIds.get(onedonation.Mandate_Reference__c);
//System.debug('Mandate Ref:' + Mandate_Reference__c);

}
update donations;
