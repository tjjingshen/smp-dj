//TJ Addedd comments on 3/12
//TJ Addedd comments on 3/12
//TJ Addedd comments on 3/12

public with sharing class AccountPagination {
    private final Location_Deal__c acct;  


 //String userid= String.valueOf(userinfo.getUserId()); 
     
    public AccountPagination(ApexPages.StandardSetController controller) {
       this.acct = (Location_Deal__c)controller.getRecord(); 
    } 
    
    public ApexPages.StandardSetController accountRecords{
        get {
            if(accountRecords == null) {
                return new ApexPages.StandardSetController(Database.getQueryLocator(
                [select name  from Location_Deal__c ]));
            }
            return accountRecords;  
        }
        private set;
    }
    public List<Location_Deal__c> getAccountPagination() {
         return (List<Location_Deal__c>) accountRecords.getRecords();
    }  
}