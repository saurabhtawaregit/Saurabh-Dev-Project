public class ContactTriggerHandler extends TriggerHandler{
    
    Map<Id,Contact> oldMap {get;set;}
    Map<Id,Contact> newMap {get;set;}
    List<Contact> newList  {get;set;}
    List<Contact> oldList  {get;set;}
    
    public ContactTriggerHandler() {
        this.newMap = (Map<Id,Contact> )Trigger.newMap;
        this.oldMap = (Map<Id,Contact> )Trigger.oldMap;
        this.oldList = (List<Contact>)Trigger.old;
        this.newList = (List<Contact>)Trigger.new;
    }
    public override void afterInsert(){
     	//createSkyAprvlHstrRecord(this.newMap,this.oldMap);
    }
	
}