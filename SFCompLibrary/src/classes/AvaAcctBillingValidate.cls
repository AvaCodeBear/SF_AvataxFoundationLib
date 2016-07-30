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

public with sharing class AvaAcctBillingValidate 
extends AvaAcctAddrValidate
{
	public AvaAcctBillingValidate(ApexPages.StandardController controller)
	{
	}
	
	public AvaAcctBillingValidate(Account acct)
	{
		m_AccountRec = acct.ID;
	}
	
    public override AddressSvc.BaseAddress FetchOriginalAddress()
    {
    	AddressSvc.BaseAddress retVal = new AddressSvc.BaseAddress();
    	List<Account> acctAddrList;
    	
        if(!Test.isRunningTest())
        {
        	acctAddrList = [select Name, ID, BillingStreet, BillingCity, BillingState, 
        		BillingPostalCode, BillingCountry from Account where ID =: m_AccountRec];
        }
        else
        {
        	acctAddrList = new List<Account>();
        	acctAddrList.add( new Account(
        		BillingStreet = '1060 w Addison',
        		BillingCity = 'Chicago',
        		BillingState = 'il',
        		BillingPostalCode = '60613',
        		BillingCountry = 'US'
        	));
        }
        
        	
        if(acctAddrList.size() > 0)
        {
        	List<String> Lines = AvaStaticHelpers.parseStreetAddress(acctAddrList[0].BillingStreet);
        	retVal.Line1 = Lines[0]; 
        	retVal.Line2 = Lines[1]; 
        	retVal.Line3 = Lines[2]; 
        	retVal.City = acctAddrList[0].BillingCity; 
        	retVal.Region = acctAddrList[0].BillingState; 
        	retVal.PostalCode = acctAddrList[0].BillingPostalCode; 
        	retVal.Country = acctAddrList[0].BillingCountry;
        }
        return retVal;
    }
    
   public override PageReference Validate()
   {
   		return Validate(false);
   }
    
    public override PageReference Validate(boolean apiSuccessFlag)
    {
    	m_Title = 'Validate Account Billing Address';
    	m_Redirect = Page.AvaAcctBillingValidateVerify;
    	PageReference pref = super.Validate(apiSuccessFlag);
  	
    	return pref;
    }
}