/**
* @description       : Utility to send out emails
* @group             : 
**/
public inherited sharing class SWKS_EmailUtility {
    
    
    /**
    * @description : Send email to contact with email template with targetobjectid
    * @param Contact con 
    * @param EmailTemplate emailTemp 
    * @param Sobject Sobj 
    * @param Boolean SaveAsActivity 
    * @param Boolean UseSignature 
    **/
    /*public static void sendEmail1(List<String> listEmail, EmailTemplate emailTemp, Sobject Sobj, 
                                 Boolean SaveAsActivity, Boolean UseSignature)
    {
        //
        Messaging.SingleEmailMessage emailMessage = new Messaging.SingleEmailMessage();
        emailMessage.setToAddresses(listEmail);
        emailMessage.setTemplateId(emailTemp.Id);
        emailMessage.setTargetObjectId(sObj.id);
        // emailMessage.SaveAsActivity = SaveAsActivity;
        emailMessage.UseSignature = UseSignature;
        Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { emailMessage });
        // Call a helper method to inspect the returned results
        inspectResults(results);
        
    }

    /**
    * @description : Send email to contact with email template with targetobjectid
    * @param Contact con 
    * @param EmailTemplate emailTemp 
    * @param Sobject Sobj 
    * @param Boolean SaveAsActivity 
    * @param Boolean UseSignature 
    **/    
    /*public static void sendEmail(Contact con, EmailTemplate emailTemp, Sobject Sobj, 
                                 Boolean SaveAsActivity, Boolean UseSignature)
    {
        Messaging.SingleEmailMessage emailMessage = new Messaging.SingleEmailMessage();
        emailMessage.setTemplateId(emailTemp.Id);
        emailMessage.setTargetObjectId(con.id);
        emailMessage.setWhatId(Sobj.id);
        // emailMessage.SaveAsActivity = SaveAsActivity;
        emailMessage.UseSignature = UseSignature;
        Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { emailMessage });
        // Call a helper method to inspect the returned results
        inspectResults(results);
    }
    
    /**
    * @description : Send email to contact with email template with targetobjectid from OrganizationWideAddress.
    * @param Contact EmailTemplate 
    * @param OrganizationWideAddress Sobject 
    **/
   /* public static void sendEmail(Contact con, EmailTemplate emailTemp, OrgWideEmailAddress Owa, Sobject Sobj, 
                                 Boolean SaveAsActivity, Boolean UseSignature)
    {
        Messaging.SingleEmailMessage emailMessage = new Messaging.SingleEmailMessage();
        if(Owa != null)
        {
            emailMessage.setOrgWideEmailAddressId(Owa.Id);
            //emailMessage.setSenderDisplayName(Owa.displayName);
        }
        //Else Can not be covered in test class as we can not insert Org wide email address in test class.
        else{
            
            OrgWideEmailAddress OrgEmailAdd = [SELECT Id, Address, DisplayName, isAllowAllProfiles FROM OrgWideEmailAddress LIMIT 1];
            if(OrgEmailAdd!=null){
                emailMessage.setOrgWideEmailAddressId(OrgEmailAdd.Id);
            }
        }
        emailMessage.setTemplateId(emailTemp.Id);
        emailMessage.setTargetObjectId(con.id);
        if(Sobj != null)
        {
        	emailMessage.setWhatId(Sobj.id);
        }
//        emailMessage.SaveAsActivity = SaveAsActivity;
        emailMessage.UseSignature = UseSignature;
        Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { emailMessage });
        // Call a helper method to inspect the returned results
        inspectResults(results);
    }
    
    /**
    * @description : Send email to email Address with email template with targetobjectid from OrganizationWideAddress.
    * @param List<String> emailAddresses 
    * @param EmailTemplate OrganizationWideAddress 
    * @param Sobject 
    **/
    /*public static void sendEmail(List<String> emailAddresses, EmailTemplate emailTemp, OrgWideEmailAddress Owa, 
                                 Sobject Sobj, Boolean SaveAsActivity, Boolean UseSignature)
    {
        
        Savepoint sP1 = Database.setSavepoint();
        
        try{

            Account acc = new Account(Name = 'Test Account Dummy - 001',
                                    BillingCountry = 'India', 
                                    Email__c = 'test@test.com',
                                    BillingState = 'Uttar Pradesh',
                                    BillingPostalCode = '560081');
            insert acc;
            
            Contact con = new Contact(FirstName = 'dummy 01',
                                    LastName = 'test dummy contact',
                                    AccountId = acc.Id,
                                    Email = 'test@test.com',
                                    Phone = '9876543232');
            insert con;

            Messaging.SingleEmailMessage dummyEmailMessage = new Messaging.SingleEmailMessage();
            dummyEmailMessage.setTemplateId(emailTemp.Id);
            dummyEmailMessage.setTargetObjectId(Con.id);
            if(Sobj != null && !String.valueOf(Sobj.id).startswith('005')){
                dummyEmailMessage.setWhatId(Sobj.id);    
            }
            if(Test.isRunningTest()){ dummyEmailMessage.setWhatId(acc.id); }
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { dummyEmailMessage });
            Database.rollback(sP1);
            
            Messaging.SingleEmailMessage emailMessage = new Messaging.SingleEmailMessage();
            emailMessage.toAddresses = emailAddresses;
            if(Owa != null)
            {
                emailMessage.setOrgWideEmailAddressId(Owa.Id);
            }
            emailMessage.setPlainTextBody(dummyEmailMessage.getPlainTextBody());
            emailMessage.setHTMLBody(dummyEmailMessage.getHTMLBody());
            emailMessage.setSubject(dummyEmailMessage.getSubject());
            if(Sobj != null && String.valueOf(Sobj.id).startswith('001')){
            emailMessage.setWhatId(Sobj.id); 
            }
            
            // emailMessage.SaveAsActivity = SaveAsActivity;
            emailMessage.UseSignature = UseSignature;
            Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { emailMessage });
            // Call a helper method to inspect the returned results
            inspectResults(results);
        }
        catch(Exception ex)
        {
            Database.rollback(sP1);
        }
    }
    
    /**
    * @description : Send email to email Address with subject and body  from OrganizationWideAddress.
    * @param List<String> emailAddresses 
    * @param Subject Body 
    * @param OrganizationWideAddress 
    **/
    /*public static void sendEmail(List<String> emailAddresses, String Subject, String Body, 
                                 OrgWideEmailAddress Owa, Boolean SaveAsActivity, Boolean UseSignature)
    {
        Messaging.SingleEmailMessage emailMessage = new Messaging.SingleEmailMessage();
        emailMessage.toAddresses = emailAddresses;
        if(Owa != null)
        {
        	emailMessage.setOrgWideEmailAddressId(Owa.Id);
        }
        emailMessage.subject = Subject;
        emailMessage.plainTextBody = Body;
        // emailMessage.SaveAsActivity = SaveAsActivity;
        emailMessage.UseSignature = UseSignature;
        Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { emailMessage });
        // Call a helper method to inspect the returned results
        inspectResults(results);
    }   

    /**
    * @description : Send email via email template -> subject and body from OrganizationWideAddress.
    * @author Rialtes team
    **/
    /*public static void sendEmail(EmailTemplate emailTemp, Sobject sobj, OrgWideEmailAddress Owa, Boolean SaveAsActivity, Boolean UseSignature)
    {
        Messaging.SingleEmailMessage emailMessage = new Messaging.SingleEmailMessage();
        emailMessage.setTemplateId(emailTemp.Id);
        emailMessage.setTargetObjectId(sobj.id);
        if(Owa != null)
        {
        	emailMessage.setOrgWideEmailAddressId(Owa.Id);
        }
        //Else Can not be covered in test class as we can not insert Org wide email address in test class.
        else{
            OrgWideEmailAddress OrgEmailAdd = [SELECT Id, Address, DisplayName, isAllowAllProfiles FROM OrgWideEmailAddress LIMIT 1];
            if(OrgEmailAdd!=null){
                emailMessage.setOrgWideEmailAddressId(OrgEmailAdd.Id);
            }
        }
        // emailMessage.SaveAsActivity = SaveAsActivity;
        emailMessage.UseSignature = UseSignature;
        Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { emailMessage });
        // Call a helper method to inspect the returned results
        inspectResults(results);
    } 
    
    /**
    * @description : return true if email sent.
    * @author Rialtes team
    **/
    /*private static Boolean inspectResults(Messaging.SendEmailResult[] results) {
        Boolean sendResult = true;
        // sendEmail returns an array of result objects.
        // Iterate through the list to inspect results. 
        // In this class, the methods send only one email, 
        // so we should have only one result.
        for (Messaging.SendEmailResult res : results) {
            if (res.isSuccess()) {
                System.debug('Email sent successfully');
            }
            else {
                sendResult = false;
                System.debug('The following errors occurred: ' + res.getErrors());                 
            }
        }
        return sendResult;
    }
    /**
    * @description : Validate email address formate.
    * @author Rialtes team
    **/
    /*public static Boolean emailAddressIsValid(String email) {

        if (String.isEmpty(email)){
          return false;  
        }

		String emailRegex = '^[a-zA-Z0-9._|\\\\%⌗~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$'; 

		Pattern MyPattern = Pattern.compile(emailRegex);

		Matcher MyMatcher = MyPattern.matcher(email);

        if (!MyMatcher.matches()) {
        	return false;    
        }

		return true;	

	}
    
    public static void sendEmail(List<String> emailAddresses, EmailTemplate emailTemp, OrgWideEmailAddress Owa, 
                                 Sobject Sobj, Boolean SaveAsActivity, Boolean UseSignature, String replace)
    {
        System.debug('CC Email Method');
        Savepoint sP1 = Database.setSavepoint();
        
        try{

            Account acc = new Account(Name = 'Test Account Dummy - 001',
                                    BillingCountry = 'India', 
                                    Email__c = 'test@test.com',
                                    BillingState = 'Uttar Pradesh',
                                    BillingPostalCode = '560081');
            insert acc;
            
            Contact con = new Contact(FirstName = 'dummy 01',
                                    LastName = 'test dummy contact',
                                    AccountId = acc.Id,
                                    Email = 'test@test.com',
                                    Phone = '9876543232');
            insert con;

            Messaging.SingleEmailMessage dummyEmailMessage = new Messaging.SingleEmailMessage();
            dummyEmailMessage.setTemplateId(emailTemp.Id);
            dummyEmailMessage.setTargetObjectId(Con.id);
            if(Sobj != null && !String.valueOf(Sobj.id).startswith('005')){
                dummyEmailMessage.setWhatId(Sobj.id);    
            }
            if(Test.isRunningTest()){ dummyEmailMessage.setWhatId(acc.id); }
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { dummyEmailMessage });
            Database.rollback(sP1);
            
            Messaging.SingleEmailMessage emailMessage = new Messaging.SingleEmailMessage();
            emailMessage.toAddresses = emailAddresses;
            if(Owa != null)
            {
                emailMessage.setOrgWideEmailAddressId(Owa.Id);
            }
            emailMessage.setPlainTextBody(dummyEmailMessage.getPlainTextBody());
            String replacedBody = '';
            if(dummyEmailMessage.getHTMLBody().indexOf('EMAIL_MESSAGE') >= 0)
            {
                replacedBody = dummyEmailMessage.getHTMLBody().replaceAll('EMAIL_MESSAGE', replace);
            }
            else
            {
                replacedBody = dummyEmailMessage.getHTMLBody();
            }
            emailMessage.setHTMLBody(replacedBody);
            emailMessage.setSubject(dummyEmailMessage.getSubject());
            if(Sobj != null && String.valueOf(Sobj.id).startswith('001')){
            emailMessage.setWhatId(Sobj.id); 
            }
            
            // emailMessage.SaveAsActivity = SaveAsActivity;
            emailMessage.UseSignature = UseSignature;
            Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { emailMessage });
            // Call a helper method to inspect the returned results
            inspectResults(results);
        }
        catch(Exception ex)
        {
            Database.rollback(sP1);
        }
    }
    public static void sendEmail(List<String> emailAddresses, EmailTemplate emailTemp, OrgWideEmailAddress Owa, 
                                 Sobject Sobj, Boolean SaveAsActivity, Boolean UseSignature, String replace1, String replace2, String replace3)
    {
        
        Savepoint sP1 = Database.setSavepoint();
        
        try{

            Account acc = new Account(Name = 'Test Account Dummy - 001',
                                    BillingCountry = 'India', 
                                    Email__c = 'test@test.com',
                                    BillingState = 'Uttar Pradesh',
                                    BillingPostalCode = '560081');
            insert acc;
            
            Contact con = new Contact(FirstName = 'dummy 01',
                                    LastName = 'test dummy contact',
                                    AccountId = acc.Id,
                                    Email = 'test@test.com',
                                    Phone = '9876543232');
            insert con;
            system.debug('Email----->');
            Messaging.SingleEmailMessage dummyEmailMessage = new Messaging.SingleEmailMessage();
            system.debug('Email----->'+dummyEmailMessage);

            dummyEmailMessage.setTemplateId(emailTemp.Id);
            dummyEmailMessage.setTargetObjectId(Con.id);
            if(Sobj != null && !String.valueOf(Sobj.id).startswith('005')){
                dummyEmailMessage.setWhatId(Sobj.id);    
            }
            if(Test.isRunningTest()){ dummyEmailMessage.setWhatId(acc.id); }
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { dummyEmailMessage });
            Database.rollback(sP1);
            
            Messaging.SingleEmailMessage emailMessage = new Messaging.SingleEmailMessage();
            emailMessage.toAddresses = emailAddresses;
            if(Owa != null)
            {
                emailMessage.setOrgWideEmailAddressId(Owa.Id);
            }
            System.debug('Email--->'+dummyEmailMessage.getHTMLBody());
            emailMessage.setPlainTextBody(dummyEmailMessage.getPlainTextBody());
            String replacedBody = '';
            if(dummyEmailMessage.getHTMLBody().indexOf('EMAIL_MESSAGE1') >= 0 &&
               dummyEmailMessage.getHTMLBody().indexOf('EMAIL_MESSAGE3') >= 0 &&
               dummyEmailMessage.getHTMLBody().indexOf('EMAIL_MESSAGE2') >= 0)
            {
                replacedBody = dummyEmailMessage.getHTMLBody().replaceAll('EMAIL_MESSAGE1', replace1);
                replacedBody = replacedBody.replaceAll('EMAIL_MESSAGE2', replace2);
                replacedBody = replacedBody.replaceAll('EMAIL_MESSAGE3', replace3);
            }
            else
            {
                replacedBody = dummyEmailMessage.getHTMLBody();
            }
            emailMessage.setHTMLBody(replacedBody);
            emailMessage.setSubject(dummyEmailMessage.getSubject());
            if(Sobj != null && String.valueOf(Sobj.id).startswith('001')){
            emailMessage.setWhatId(Sobj.id); 
            }
            
            // emailMessage.SaveAsActivity = SaveAsActivity;
            emailMessage.UseSignature = UseSignature;
            Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { emailMessage });
            // Call a helper method to inspect the returned results
            inspectResults(results);
        }
        catch(Exception ex)
        {
            Database.rollback(sP1);
        }
    }*/
}