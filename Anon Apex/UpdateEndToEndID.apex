date firstPaymentdate = system.today() + 3;

List <string> endToEndIds = new list<string>();
endToEndIds.add('985280-10386210-190221144429');
endToEndIds.add('D2D2013-190221144429');
endToEndIds.add('990624-84020570-190221144429');
system.debug('end to end Ids' + endToEndIds );

Integer i=0;
//  Set end to End IDs
List<Opportunity> donations = [Select Id,End_to_End_ID__c	 
from Opportunity where  CloseDate = :firstPaymentdate ];
system.debug('donations' + donations );
for (Opportunity oneDonation :donations) {
    oneDonation.End_to_End_ID__c = endToEndIDs[i];
    i++;

}
update donations;

