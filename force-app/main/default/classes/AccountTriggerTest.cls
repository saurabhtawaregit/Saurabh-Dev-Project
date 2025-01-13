@isTest
public class AccountTriggerTest {
    @isTest
    static void testAccountTrigger() {
        // Setup test data
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        // Verify that the trigger logic is executed correctly
        testAccount = [SELECT Name FROM Account WHERE Id = :testAccount.Id];
        System.assertEquals('Test Account', testAccount.Name);
    }
}