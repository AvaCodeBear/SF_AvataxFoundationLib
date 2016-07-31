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
//
// The latest version of this source file may be obtained from
// https://github.com/AvaCodeBear/SF_AvataxFoundationLib
////////////////////////////////////////////////////////////////////////////////

public with sharing class AvaAcctShippingValidate 
extends AvaSObjectAddrValidate
{
	public AvaAcctShippingValidate(ApexPages.StandardController controller)
	{
	}
	
	public AvaAcctShippingValidate(Account acct)
	{
		m_SObjectRecID = acct.ID;
	}
	
    public override AddressSvc.BaseAddress FetchOriginalAddress()
    {
    	AddressSvc.BaseAddress retVal = new AddressSvc.BaseAddress();
    	List<Account> acctAddrList;
    	
        if(!Test.isRunningTest())
        {
        	acctAddrList = [select Name, ID, ShippingStreet, ShippingCity, ShippingState, 
        		ShippingPostalCode, ShippingCountry from Account where ID =: m_SObjectRecID];
        }
        else
        {
        	acctAddrList = new List<Account>();
        	acctAddrList.add( new Account(
        		ShippingStreet = '1060 w Addison',
        		ShippingCity = 'Chicago',
        		ShippingState = 'il',
        		ShippingPostalCode = '60613',
        		ShippingCountry = 'US'
        	));
        }
        
        	
        if(acctAddrList.size() > 0)
        {
        	List<String> Lines = AvaStaticHelpers.parseStreetAddress(acctAddrList[0].ShippingStreet);
        	retVal.Line1 = Lines[0]; 
        	retVal.Line2 = Lines[1]; 
        	retVal.Line3 = Lines[2]; 
        	retVal.City = acctAddrList[0].ShippingCity; 
        	retVal.Region = acctAddrList[0].ShippingState; 
        	retVal.PostalCode = acctAddrList[0].ShippingPostalCode; 
        	retVal.Country = acctAddrList[0].ShippingCountry;
        }
        return retVal;
    }
    
   public override PageReference Validate()
   {
   		return Validate(false);
   }
    
    public override PageReference Validate(boolean apiSuccessFlag)
    {
    	m_Title = 'Validate Account Shipping Address';
    	m_Redirect = Page.AvaAcctShippingValidateVerify;
    	PageReference pref = super.Validate(apiSuccessFlag);
  	
    	return pref;
    }

}