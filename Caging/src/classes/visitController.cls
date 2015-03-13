public class visitController {

    public Sales_Visit__c visit {
        get;
        set;
    }

    public visitController() {
        visit = new Sales_Visit__c();
    }

    public PageReference save() {
        String userid = String.valueOf(userinfo.getUserId());

        //Dupe Check Logic  
        List < Sales_Visit__c > sv = [select id from Sales_Visit__c where
        Interest__c = : visit.Interest__c
        and latitude__c = : visit.Latitude__c
        and longitude__c = : visit.longitude__c
        and OwnerId = : userid];

        if (sv.size() > 0) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Interest for this category is submitted');
            ApexPages.addMessage(msg);
            return null;
        } else {
            insert visit;
            visit = new Sales_Visit__c();
            return null;
        }
    }
}