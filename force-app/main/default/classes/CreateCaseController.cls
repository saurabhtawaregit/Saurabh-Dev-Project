public with sharing class CreateCaseController {
    public Case caseRecord { get; set; }

    public CreateCaseController(ApexPages.StandardController stdController) {
        caseRecord = (Case)stdController.getRecord();
    }

    // Initialize method (if needed for defaults)
    public void init() {
        caseRecord = new Case();
    }

    // Save the new case
    public PageReference saveCase() {
        try {
            insert caseRecord;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Case created successfully.'));
            return new PageReference('/' + caseRecord.Id);
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error creating case: ' + e.getMessage()));
            return null;
        }
    }

    // Cancel and return to the previous page
    public PageReference cancel() {
        return ApexPages.currentPage().getParameters().get('retURL') != null ? 
            new PageReference(ApexPages.currentPage().getParameters().get('retURL')) : null;
    }
}