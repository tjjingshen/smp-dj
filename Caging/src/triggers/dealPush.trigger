trigger dealPush on Deals__c(after insert, after update) {

    /* Pushing Deals */

    Set < Id > ids = trigger.newmap.keySet();

    List < Deals__c > uDeals = [SELECT Id, Deal_Category__c, latitude__c, longitude__c, Deals__c.Account__r.Name, Published__c FROM Deals__c WHERE Id IN: ids /*Deal_Expired__c = False* And Published__c = TRUE */
    ];
    List < Sales_Visit__c > uMs = [SELECT Interest__c, latitude__c, longitude__c, OwnerId
    FROM Sales_Visit__c /*WHERE Deal_Pushed__c = False*/ ];

    /* Load Junction Object */
    String userid = String.valueOf(userinfo.getUserId());
    List < Location_Deal__c > dealJun = new List < Location_Deal__c > ();

    for (Deals__c uDeal: uDeals) {
        for (Sales_Visit__c uM: uMs) {

            Integer uM_lat = Integer.valueOf(uM.latitude__c);
            Integer uDeal_lat = Integer.valueOf(uDeal.latitude__c);
            Integer uM_lon = Integer.valueOf(uM.longitude__c);
            Integer uDeal_lon = Integer.valueOf(uDeal.longitude__c);
            String uDeal_Store_Name = String.valueOf(uDeal.Account__r.Name);


            if ((uM.Interest__c == uDeal.Deal_Category__c) && (((uM_lat + 5 >= uDeal_lat) || (uM_lat - 5 <= uDeal_lat)) && ((uM_lon + 5 >= uDeal_lon) || (uM_lon - 5 <= uDeal_lon)))) {

                if (uDeal.Published__c == TRUE) {
                    Location_Deal__c tempdealJunc = new Location_Deal__c(Deals__c = uDeal.Id, Location__c = uM.Id, ownerId = uM.OwnerId, Deal_Valid__c = True, External_Id__c = uM.Interest__c + uDeal_Store_Name + uM.OwnerId);
                    dealJun.add(tempdealJunc);
                    uM.Deal_Pushed__c = True;

                } else {
                    Location_Deal__c tempdealJunc = new Location_Deal__c(Deals__c = uDeal.Id, Location__c = uM.Id, ownerId = uM.OwnerId, Deal_Valid__c = False, External_Id__c = uM.Interest__c + uDeal_Store_Name + uM.OwnerId);
                    dealJun.add(tempdealJunc);
                    uM.Deal_Pushed__c = False;


                }


            }
            update uM;
        } // For Deal
    } // For Location
    upsert dealJun external_id__c;



}