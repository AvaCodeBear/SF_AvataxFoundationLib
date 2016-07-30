////////////////////////////////////////////////////////////////////////////////
//   Copyright 2014 CodeBear Software LLC
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.
////////////////////////////////////////////////////////////////////////////////

public with sharing class AvaAcctBillingValMsg 
extends AvaMessageBox
{
    public PageReference UpdateAddress()
    {
     	Account acctRec = new Account(
    		ID=m_oUserMessage.ReturnPageID__c,
    		BillingStreet = m_oUserMessage.Street_Address_Col2__c,
    		BillingCity = m_oUserMessage.City_Col2__c,
    		BillingState = m_oUserMessage.Region_Col2__c,
    		BillingPostalCode = m_oUserMessage.PostalCode_Col2__c,
    		BillingCountry = m_oUserMessage.Country_Col2__c
    	);
    	
    	if(!Test.isRunningTest())
    	{
    		update acctRec;
    	}
   	
        return super.DismissPage();               
    }

}