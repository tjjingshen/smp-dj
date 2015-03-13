trigger allocatePickUp on Check_In__c(after insert) {

    Set < Id > ids = trigger.newmap.keySet();

    List < Check_In__c > checkIns = [SELECT Bar_Code_No__c, Latitude__c, Longitude__c, OwnerId, Terminal__c
    FROM Check_In__c WHERE Id IN: ids];

    /* Load Junction Object */
     
    List < Van_Information__c > vanInformations = [SELECT Van_Number__c, latitude__c, longitude__c  FROM Van_Information__c WHERE On_Shift__c = TRUE];
    List < Dispatch_Service__c > dispatchService = new List < Dispatch_Service__c > ();

    for (Check_In__c checkIn: checkIns) {
        for (Van_Information__c vanInformation: vanInformations) {

            Integer checkIn_lat = Integer.valueOf(checkIn.latitude__c);
            Integer vanInformation_lat = Integer.valueOf(vanInformation.latitude__c);
            Integer checkIn_lon = Integer.valueOf(checkIn.longitude__c);
            Integer vanInformation_lon = Integer.valueOf(vanInformation.longitude__c);
             

            if ((((checkIn_lat + 5 >= vanInformation_lat) || (checkIn_lat - 5 <= vanInformation_lat)) && ((checkIn_lon + 5 >= vanInformation_lon) || (checkIn_lon - 5 <= vanInformation_lon))))

            {
                Dispatch_Service__c tempdealJunc = new Dispatch_Service__c(Bar_Code_No__c = checkIn.Bar_Code_No__c, Van_Number__c = vanInformation.Van_Number__c, ownerId = checkIn.OwnerId );
                dispatchService.add(tempdealJunc);
                

            }
        } // For Deal
        
    } // For Location
    upsert dispatchService Bar_Code_No__c;

}

// No question of dupes here