/**
 * The DMLOperations class serves as a deep dive into Data Manipulation Language (DML) in Apex.
 * It covers fundamental DML operations such as insert, update, upsert, and delete.
 *
 * This class introduces developers to the concept of manipulating Salesforce records in Apex.
 * It discusses how to use DML operations to create, update, and delete records.
 * This class uses standard Salesforce objects like Account, Contact, and Opportunity for demonstration.
 *
 * Topics covered in this class include:
 * - Understanding how to use insert DML operation to create records in Salesforce.
 * - Understanding how to use update and upsert DML operations to update existing records in Salesforce.
 * - Understanding how to use delete DML operation to remove records from Salesforce.
 *
 * Users of this class can expect to gain a strong understanding of DML operations in Apex and
 * be prepared for more advanced topics in Salesforce development.
 *
 * The methods within this class serve as practical examples of different DML operations,
 * allowing developers to learn through practice and examples.
 *
 * @author Christie Martin
 */


public with sharing class DMLOperations {

    /**
     * Question 1
     * Create a new Account object and inserts it into the database.
     * The Account will have a random name for uniqueness.
     * @return The Id of the newly created Account.
     */
    public static Id insertNewAccount() {
        // Create a new Account instance
        Account myFirstAccount = new Account();
        
            // Set some fields on the Account
                myFirstAccount.Name = 'First Accounty';
                myFirstAccount.Industry = 'Consulting';
        
                // Insert the Account into the database        
                database.insert(myFirstAccount, AccessLevel.USER_MODE);
                        
            return myFirstAccount.Id;
        } 
    

    /**
     * Question 2
     * Create a new Account with the specified name and industry provided.
     * @param name The name of the account to be created.
     * @param industry The industry of the account to be created.
     */
    public static void createAccount(String name, String industry) {
        // Create a new Account and set the fields inline
        Account newAccount = new Account(Name = 'Test Account', Industry = 'Technology');
        
        
        database.insert(newAccount, AccessLevel.USER_MODE);
        // Set some fields on the Account

        // Insert the Account
    }

    
    /**
     * Question 3
     * Create a new Contact and link it to the Account id provided then inserts it into the database.
     * @param accountId The Id of the Account to link the Contact to.
     * @return The Id of the newly created Contact.
     */
    public static Id insertNewContact(Id accountId) {
        // Create a new Contact instance
        Contact newContact = new Contact();
    // Set some fields on the Contact
        newContact.FirstName = 'Christie';
        newContact.AccountId = accountId;
        newContact.LastName = 'DiedreDelaney';

        // Insert the Contact into the database
        
        database.insert(newContact, AccessLevel.USER_MODE);
        
        // Set the AccountId field to the given accountId


        // Return the Id of the newly created Contact
        return newContact.Id;
    }

    /**
     * Question 4
     * Update the last name of a Contact in the database.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param contactId The Id of the Contact to update.
     * @param newLastName The new last name for the Contact.
     */
    public static void updateContactLastName(Id contactId, String newLastName) {
        // Retrieve the Contact from the database
        Contact myContact = [SELECT Id, LastName FROM Contact WHERE Id = :contactId WITH USER_MODE];

        // Update the Contact's last name
    myContact.LastName = newLastName;

        // Update the Contact in the database
        database.update(myContact,AccessLevel.USER_MODE);
    }

    /**
     * Question 5
     * Update the stage of an Opportunity in the database.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param oppId The Id of the Opportunity to update.
     * @param newStage The new stage for the Opportunity.
     */
    public static void updateOpportunityStage(Id oppId, String newStage) {
        // Retrieve the Opportunity from the database
        Opportunity myOpportunity = [SELECT StageName, Id FROM Opportunity WHERE Id = :oppId WITH USER_MODE];

        // Update the Opportunity's stage
            myOpportunity.StageName = newStage;
        // Update the Opportunity in the database
            database.update(myOpportunity, AccessLevel.USER_MODE);
    }

    /**
     * Question 6
     * Update the Account's Name and Industry given an Account Id.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param accountId The Id of the account to be updated.
     * @param newName The new name for the account.
     * @param newIndustry The new industry for the account.
     */
    public static void updateAccountFields(Id accountId, String newName, String newIndustry) {
        // Query the account
        Account myAccount = [SELECT Id, Name, Industry FROM Account WHERE Id = :accountId WITH USER_MODE];

            myAccount.Name = newName;
            myAccount.Industry = newIndustry;
        // Update the Account with the given Id with the new name and industry

            Database.update(myAccount, AccessLevel.USER_MODE);
    }


    /**
     * Question 7
     * Create or updates an Opportunities
     * The Opportunity's Stage is set to Qualification.
     * The Opportunity's Close Date is set to 3 months from today.
     * The Opportunity's Amount is set to 50000.
     * @param list of Opportunities to be changed then upserted.
     */
    public static void upsertOpportunityList(List<Opportunity> opportunities) {
        // Loop through each Opportunity in the list
    

        for (Opportunity opp : opportunities){
            
            opp.StageName = 'Qualification';// Set the Opportunity's Stage to Qualification
            opp.CloseDate = Date.Today().addMonths(3);// Set the Opportunity's Close Date to 3 months from today
            opp.Amount = 50000;// Set the Opportunity's Amount to 50000
            
            }
            // Upsert the opportunities List so that records are either updated or created
        Database.upsert(opportunities, AccessLevel.USER_MODE) ;
    }
            

    /** 
     * Question 8
     * Insert or update opportunities from list of names.
     * Associate the Opportunities with account that has the name accountName.
     * There should be an Opportunity for each name provided in the list.
     * HINT: The account may or may not exists in the database but is required for opportunity creation. Consider how upsert operation can help with this.
     * HINT: There should not be duplicate opportunites based on the name
     * @param accountName The name of the Account.
     * @param oppNames The list of Opportunity names.
     */
    public static void upsertOpportunities(String accountName, List<String> oppNames) {
        
    Id myAccountId;
            
        List<Account> myNeededAcctIds = [SELECT Id FROM Account WHERE Name = :accountName WITH USER_MODE LIMIT 1];
            if(myNeededAcctIds.isEmpty()){
                Account account = new Account(Name = accountName); 
                    Database.insert(account, AccessLevel.USER_MODE);
                myAccountId = account.Id;
                system.debug('New Acct Id: ' + myAccountId);
                }
        
                else {
                    myAccountId = myNeededAcctIds.get(0).Id;
                }
            List<Opportunity> existingOpps = [SELECT Id, Name FROM Opportunity WHERE Name IN :OppNames];      
        
                Set<String> existingOppNames = new Set<String>();
                    for (Opportunity eachOpp : existingOpps){
                    existingOppNames.add(eachOpp.Name);
                    }
        
            List<Opportunity> oppsToUpsert = new List<Opportunity>();    
            
            
            
        for (String OppName : OppNames) {
            if(existingOppNames.contains(OppName)){
                
                for (Opportunity eachOpp : existingOpps) {
                if (eachOpp.Name == oppName) {
                    eachOpp.AccountId = myAccountId;// Opportunity exists, associate with Account and add to upsert list
                    oppsToUpsert.add(eachOpp);
                }
            }
        } else {
            Opportunity opp = new Opportunity();
                opp.Name = oppName;
                opp.StageName = 'Qualification';
                opp.CloseDate = Date.Today().addMonths(3);
                opp.Amount = 50000;
                opp.AccountID = myAccountId;
                
                oppsToUpsert.add(opp);
            System.debug('New Opp to upsert?' + opp);
            }
        }
        
        if (!oppsToUpsert.isEmpty()) {
            Database.upsert(oppsToUpsert, false);
            }
        }
        
            

    
    /**
     * Question 9
	 * Upserts an Account with the specified name.
	 * If an Account with the given name already exists, update the description to "Updated Account".
	 * If no such Account exists, it creates a new one and sets the description to "New Account".
	 * @param accountName The name of the Account to be upserted.
	 * @return The Account that was upserted.
	 */
	public static Account upsertAccount(String accountName) {
		// Query for the Account
		List<Account> accounts = [SELECT Id, Description FROM Account WHERE Name = :accountName];
        Account acctsToUpsert = new Account();
                
        if(!accounts.IsEmpty()){
            
            acctsToUpsert = accounts[0];
            acctsToUpsert.Description = 'Updated Account';
                    
                }   

                else {   
                Account myNewAccount = new Account();
                    myNewAccount.Name = accountName;
                    myNewAccount.description = 'New Account'; // otherwise, create a new Account and set the description
                    acctsToUpsert = myNewAccount;           
                }
            database.upsert(acctsToUpsert, AccessLevel.USER_MODE);// Upsert the Account
            
            return acctsToUpsert;
            }

    /**
     * Question 10
	 * Manage the association between Contacts and Accounts
	 * Ensure that for each Contact in the provided list, there is a corresponding Account Name that matches the Contact's last name.
	 * If such an Account does not exist, the method creates it; if it does, the method ensures the Contact is associated with it. (Hint: use previous upsertAccount method - this may cause bad practices but for learning purposes it's okay.)
     * Example Contact.LastName = 'Doe' Link to Account.Name = 'Doe' 
     * Example Contact.LastName = 'Jane' Link to Account.Name = 'Jane'
	 * @param contactsToUpsert List of Contacts to be upserted and linked to accounts.
	 */
	public static void upsertAccountsWithContacts(List<Contact> contactsToUpsert) {
		// Loop through each Contact
        Map<String, Account> accountNameMap = new Map<String, Account>();   

        if(!contactsToUpsert.IsEmpty()){
            
            for(Contact eachContact : contactsToUpsert){
                String accountName = eachContact.LastName;// Extract the Account Name from Contact's LastName
                        Account upsertedAccount = DMLOperations.upsertAccount(accountName);// Get the account based on the name or create one if it doesn't exist
                        accountNameMap.put(accountName, upsertedAccount);
                    eachContact.AccountId = upsertedAccount.Id; // Link the Contact to its Account using the Account Id
                }
                database.upsert(contactsToUpsert, AccessLevel.USER_MODE);  // Upsert the Contacts
        }	
    }

    /**
     * Question 11
     * Insert a list of Leads and then deletes them.
     * @param leadNames The list of Lead names to be inserted.
     */
    public static void insertAndDeleteLeads(List<String> leadNames) {
        List<Lead> leadsToInsert = new List<Lead>();
            
            for(String eachLead : leadNames){      // Loop through each Lead name
                Lead lead = new Lead();
                    lead.LastName = eachLead;
                    lead.Company = 'Test Company ABC';
                    leadsToInsert.add(lead);   
            }         
            insert leadsToInsert; 
        List<Lead> deletingLeads = new List<Lead>(); 
    
                for(Lead leadTD : leadsToInsert){
                ID leadIdtoDelete = leadTD.Id;
                deletingLeads.add(leadTD);
            } 
        delete deletingLeads; 
    }


    /**
     * Question 12
     * Dynamically create the number of cases and relate it to the accountId, then deletes them.
     * @param accountId The account for which the cases will be created and then deleted.
     * @param numOfCases The number of cases to create.
     */
    public static void createAndDeleteCases(String accountId, Integer numOfCases) {
    List<Case> newCases = new List<Case>();


for(Integer i = 0; i < numOfCases; i++){
    
    Case newCase = new Case();
    newCase.Subject = 'Find me ice cream';
    newCase.AccountId = accountId;
    newCases.add(newCase);
    }
    insert newCases;
		
List<Case> casesToDelete = new List<Case>();

for(Case eachCase : newCases){
    ID caseIdToDelete = eachCase.Id;
    casesToDelete.add(eachCase);
    }

    delete casesToDelete;
}
}