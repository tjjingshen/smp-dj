public with sharing class PajinateController {
    
    //Location_Deal__c
    public List<Account> accounts{get;set;}
    
	String userid= String.valueOf(userinfo.getUserId());
	
    public PajinateController(){
        //accounts = [SELECT id, name, Deal_Detail__c, Deal_Store__c, Reject__c FROM Account /*where ownerid = :userid and Reject__c = FALSE*/  ];
        accounts = [SELECT id, name , rating,annualRevenue , industry FROM Account   ];
    }
}