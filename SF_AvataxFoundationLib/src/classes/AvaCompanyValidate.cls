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

public with sharing class AvaCompanyValidate
extends AvaBaseValidate
{
	private ID m_CompanyRec = null;
	
	
    public AvaCompanyValidate(ApexPages.StandardController controller)
    {
		m_CompanyRec =  m_apCurPage.getParameters().get('id');
    }
    
    public AvaCompanyValidate()
    {
    	m_CompanyRec = m_apCurPage.getParameters().get('id');
    }
    
    public AvaCompanyValidate(AvaCompany__c compRec)
    {
    	m_CompanyRec = compRec.ID;
    }

    public override AddressSvc.BaseAddress FetchOriginalAddress()
    {
    	AddressSvc.BaseAddress retVal = new AddressSvc.BaseAddress();
    	List<AvaCompany__c> compAddrList;
    	
        if(!Test.isRunningTest())
        {
        	compAddrList = [select Name, City__c, Company_Code__c, Country__c, Postal_Code__c, Region__c, Address__c
        		from AvaCompany__c where ID =: m_CompanyRec];
        }
        else
        {
        	compAddrList = new List<AvaCompany__c>();
        	compAddrList.add( new AvaCompany__c(
        		Address__c = '1060 w Addison',
        		City__c = 'Chicago',
        		Region__c = 'il',
        		Postal_Code__c = '60613',
        		Country__c = 'US'
        	));
        }
        
        	
        if(compAddrList.size() > 0)
        {
        	List<String> Lines = AvaStaticHelpers.parseStreetAddress(compAddrList[0].Address__c);
        	retVal.Line1 = Lines[0]; 
        	retVal.Line2 = Lines[1]; 
        	retVal.Line3 = Lines[2]; 
        	retVal.City = compAddrList[0].City__c; 
        	retVal.Region = compAddrList[0].Region__c; 
        	retVal.PostalCode = compAddrList[0].Postal_Code__c; 
        	retVal.Country = compAddrList[0].Country__c;
        }
        return retVal;
    }

    public override PageReference Validate()
    {
    	return Validate(false);
    }
    
    public override PageReference Validate(boolean apiSuccessFlag)
    {
    	m_Title = 'Validate Company Address';
    	m_Redirect = Page.AvaCompAddrValidateVerify;
    	PageReference pref = super.Validate(apiSuccessFlag);
  	
    	return pref;
    }
}