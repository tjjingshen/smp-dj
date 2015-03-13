public class checkinController {

    public String getVisit() {
        return null;
    }


    public String visit { get; set; }

    public Check_In__c checkIn {
        get;
        set;
    }

    public checkinController() {
        checkIn = new Check_In__c();
    }

    public PageReference save() {
        String userid = String.valueOf(userinfo.getUserId());

        //Dupe Check Logic  
        List < Check_In__c > sv = [select id from Check_In__c where
        Bar_Code_No__c = : checkIn.Bar_Code_No__c
        and latitude__c = : checkIn.Latitude__c
        and longitude__c = : checkIn.longitude__c
        and OwnerId = : userid];

        if (sv.size() > 0) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Interest for this category is submitted');
            ApexPages.addMessage(msg);
            return null;
        } else {
            insert checkIn;
            checkIn = new Check_In__c();
            return null;
        }
    }
}