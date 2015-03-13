public class dealsForYou {
	
	// ApexPages.StandardSetController must be instantiated  
    
  // for standard list controllers    
  
   String userid= String.valueOf(userinfo.getUserId());  
      
    public ApexPages.StandardSetController setCon {
        get {
            if(setCon == null) {
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(
                      [select name , Deal_Location__c, Deal_Coupon__c from Location_Deal__c where OwnerId = :userid ]));
            }
            return setCon;
        }
        set;
    }

    // Initialize setCon and return a list of records  
    
    public List<Location_Deal__c> getOpportunities() {
         return (List<Location_Deal__c>) setCon.getRecords();
    }
    
	// ApexPages.StandardSetController must be instantiated   
  	// for standard list controllers  
   
    


}