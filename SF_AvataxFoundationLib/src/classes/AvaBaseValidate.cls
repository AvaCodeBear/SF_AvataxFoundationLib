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

public with sharing abstract class AvaBaseValidate 
{
    protected PageReference m_apCurPage;
    protected PageReference m_Redirect;
    private AddressSvc.ValidAddress m_vaAddr = null;
    private AddressSvc.BaseAddress m_Original = null;
    protected string m_Title = null;

    public AvaBaseValidate() 
    {
        m_apCurPage = ApexPages.currentPage();
    }
    
	public virtual PageReference Validate(boolean apiSuccessFlag)
	{
		try
		{
			m_Original = FetchOriginalAddress();
			m_Original.Line1 = m_Original.Line1 != null ? m_Original.Line1.trim() : '';
			m_Original.Line2 = m_Original.Line2 != null ? m_Original.Line2.trim() : '';
	        m_Original.Line3 = m_Original.Line3 != null ? m_Original.Line3.trim() : '';
    	    m_Original.City = m_Original.City != null ? m_Original.City.trim() : '';
        	m_Original.Region = m_Original.Region != null ? m_Original.Region.trim() : '';
        	m_Original.PostalCode = m_Original.PostalCode != null ? m_Original.PostalCode.trim() : '';
        	m_Original.Country = m_Original.Country != null ? m_Original.Country.trim() : '';
        	
			AvaCredentials__c config;
			
			if(!Test.IsRunningTest())
			{
				config = AvaStaticHelpers.FetchActiveCredentials();
			}
			else
			{
				config = new AvaCredentials__c(Service_URL__c = 'https://testingsvcurl.net',
					Account_Number__c = '12345678',License_Key__c ='Excelsior'); 
			}
			AddressSvc.AddressSvcSoap aSvc = new AddressSvc.AddressSvcSoap(config.Service_URL__c);
			aSvc.apiSuccessFlag = apiSuccessFlag;
	        aSvc.Security = new AddressSvc.Security();
	        aSvc.Security.UsernameToken.Username = config.Account_Number__c;
	        aSvc.Security.UsernameToken.Password = config.License_Key__c;
	        aSvc.Profile.Client = 'YourConnector,1.0.0';
	        aSvc.timeout_x = 30000;   // timeout 30 seconds
			AddressSvc.ValidateRequest vreq = new AddressSvc.ValidateRequest();
			vreq.Address = m_Original;
		
			vreq.TextCase = 'Mixed';
			vreq.Coordinates = true;
			AddressSvc.ValidateResult vres = null;
		
			if(!Test.IsRunningTest())
			{
				vres = aSvc.Validate(vreq);			
			}
			else
			{
				vres = new AddressSvc.ValidateResult();
				if(apiSuccessFlag)
				{
					vres.ResultCode = 'Success';
					vres.ValidAddresses = new AddressSvc.ArrayOfValidAddress();
					vres.ValidAddresses.ValidAddress = new AddressSvc.ValidAddress[1];
					vres.ValidAddresses.ValidAddress[0] = new AddressSvc.ValidAddress();
			        vres.ValidAddresses.ValidAddress[0].Line1 = '123 Any Street';
			        vres.ValidAddresses.ValidAddress[0].Line2 = '';
			        vres.ValidAddresses.ValidAddress[0].Line3 = '';
			        vres.ValidAddresses.ValidAddress[0].City = 'SomeTown';
			        vres.ValidAddresses.ValidAddress[0].Region = 'LT';
			        vres.ValidAddresses.ValidAddress[0].PostalCode = '90210';
			        vres.ValidAddresses.ValidAddress[0].Country = 'US';
			        vres.ValidAddresses.ValidAddress[0].Line4 = '';
			        vres.ValidAddresses.ValidAddress[0].County = '';
			        vres.ValidAddresses.ValidAddress[0].Latitude = '0.00';
			        vres.ValidAddresses.ValidAddress[0].Longitude = '0.00';
				}
				else
				{
					vres.ResultCode = 'Fail';
            		vres.Messages = new AddressSvc.ArrayOfMessage();
            		vres.Messages.Message = new AddressSvc.Message[1];
            		vres.Messages.Message[0] = new AddressSvc.Message();
            		vres.Messages.Message[0].Name = 'Unit Test Error';
            		vres.Messages.Message[0].Summary = 'Unit Test Error Summary';
            		vres.Messages.Message[0].Details = 'Unit Test Error Details';
				}
			}
			
			if(vres.ResultCode == 'Success')
			{
				m_vaAddr = vres.ValidAddresses.ValidAddress[0];
				return AvaStaticHelpers.ShowAddresses(m_Title, m_Original, m_vaAddr,m_apCurPage,m_Redirect);
			}
			else
			{
				return AvaStaticHelpers.ShowMessageBox('Validate Returned: ' + vres.ResultCode, 
					'Error Message: ' + vres.Messages.Message[0].Name + '\r\n' +
                	'Summary: ' + vres.Messages.Message[0].Summary + '\r\n' +
                 	'Details: ' + vres.Messages.Message[0].Details, m_apCurPage);
			}
		}
		catch(Exception ex)
		{
			return AvaStaticHelpers.ShowException(ex, m_apCurPage);
		}
	}
	
	/* Call to implementation instantiates m_Original */
	public abstract AddressSvc.BaseAddress FetchOriginalAddress();
    public abstract PageReference Validate();
}