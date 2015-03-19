trigger AccountUpdate on Account (after update) {
	String log='';
    String objectType='Account';
    Account accNew = Trigger.new[0];
    Account accOld = Trigger.old[0];
    InteractionUtils iu = new InteractionUtils();
    Map<String, Schema.SObjectField> M = Schema.SObjectType.Account.fields.getMap();
    
    //get all updates on fields
    for (String str : M.keyset()){ 
        try{
           system.debug('str:' + str);                
           if(accNew.get(str) != accOld.get(str) && str!= 'systemmodstamp' && str!= 'lastmodifieddate'){ 
		     log = log + ',' + str + ' changed from ' +  accOld.get(str) + ' to ' + accNew.get(str);                
            }
         } 
      catch (Exception e){ 
          System.debug('Error: ' + e); 
        } 
     }
    
    //get the contact and create interactions.
    String contId=iu.getContact('Account',accNew.Id);
    if (log.length()> 0){
        iu.insertInteraction(contId);
        iu.insertInteractionAction(accNew.Id,objectType,log.removeStart(','));
     } 
  }