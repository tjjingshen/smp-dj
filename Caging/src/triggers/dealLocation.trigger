trigger dealLocation on Sales_Visit__c(after insert) {

    Set < Id > ids = trigger.newmap.keySet();

    List < Sales_Visit__c > uMs = [SELECT Interest__c, latitude__c, longitude__c, OwnerId
    FROM Sales_Visit__c WHERE Id IN: ids];

    /* Load Junction Object */
    String userid = String.valueOf(userinfo.getUserId());
    List < Deals__c > uDeals = [SELECT Deal_Category__c, latitude__c, longitude__c, Deals__c.Account__r.Name FROM Deals__c WHERE Published__c = TRUE];
    List < Location_Deal__c > dealJun = new List < Location_Deal__c > ();

    for (Sales_Visit__c uM: uMs) {
        for (Deals__c uDeal: uDeals) {

            Integer uM_lat = Integer.valueOf(uM.latitude__c);
            Integer uDeal_lat = Integer.valueOf(uDeal.latitude__c);
            Integer uM_lon = Integer.valueOf(uM.longitude__c);
            Integer uDeal_lon = Integer.valueOf(uDeal.longitude__c);
            String uDeal_Store_Name = String.valueOf(uDeal.Account__r.Name);

            if ((uM.Interest__c == uDeal.Deal_Category__c) && (uM.OwnerId == userid) && (((uM_lat + 5 >= uDeal_lat) || (uM_lat - 5 <= uDeal_lat)) && ((uM_lon + 5 >= uDeal_lon) || (uM_lon - 5 <= uDeal_lon))))

            {
                Location_Deal__c tempdealJunc = new Location_Deal__c(Deals__c = uDeal.Id, Location__c = uM.Id, ownerId = uM.OwnerId, Deal_Valid__c = True, External_Id__c = uM.Interest__c + uDeal_Store_Name + uM.OwnerId);
                dealJun.add(tempdealJunc);
                uM.Deal_Pushed__c = True;

            }
        } // For Deal
        update uM;
    } // For Location
    upsert dealJun external_id__c;

}

// No question of dupes here