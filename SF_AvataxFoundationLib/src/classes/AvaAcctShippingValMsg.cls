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

public with sharing class AvaAcctShippingValMsg 
extends AvaMessageBox
{
    public PageReference UpdateAddress()
    {
     	Account acctRec = new Account(
    		ID=m_oUserMessage.ReturnPageID__c,
    		ShippingStreet = m_oUserMessage.Street_Address_Col2__c,
    		ShippingCity = m_oUserMessage.City_Col2__c,
    		ShippingState = m_oUserMessage.Region_Col2__c,
    		ShippingPostalCode = m_oUserMessage.PostalCode_Col2__c,
    		ShippingCountry = m_oUserMessage.Country_Col2__c
    	);
    	
    	if(!Test.isRunningTest())
    	{
    		update acctRec;
    	}
   	
        return super.DismissPage();               
    }

}