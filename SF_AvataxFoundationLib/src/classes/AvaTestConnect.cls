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

public with sharing class AvaTestConnect 
{
    private PageReference apCurPage;

   
    public AvaTestConnect(ApexPages.StandardController controller) 
    {
       apCurPage = ApexPages.currentPage();
    }
    
    public AvaTestConnect()
    {
		apCurPage = ApexPages.currentPage();    
    }
    
    public PageReference TestConnection()
    {
    	return TestConnection(false);	
    }
    
    public PageReference TestConnection(boolean successFlag)
    {
    	string UserMessage;
    	string Title;
    	
        AvaCredentials__c config = null;
               
		try
		{
	        if(!Test.isRunningTest())
    	    {
        		config = AvaStaticHelpers.FetchCurrentCredentials();
        	}
        	else
        	{
	        	config = new AvaCredentials__c(Account_Number__c = '123456', 
        		Service_URL__c = 'https://bogusavalaraurl.net', 
        		License_Key__c = 'foo',  
        		Active_Credentials__c = true);
        	}
        
        	TaxSvc.TaxSvcSoap taxSvc = new TaxSvc.TaxSvcSoap(config.Service_URL__c);
        	taxSvc.Security = new TaxSvc.Security();
        	taxSvc.Security.UsernameToken.Username = config.Account_Number__c;
        	taxSvc.Security.UsernameToken.Password = config.License_Key__c;
        	taxSvc.Profile.Client = 'AvaTax4ServiceMax,1.0.0';
        	taxSvc.timeout_x = 30000;   // timeout 30 seconds
			taxSvc.IsAuthorizedResult opres = null;
			if(!Test.isRunningTest())
			{
				opres = taxSvc.IsAuthorized('IsAuthorized');
			}
			else
			{
				opres = new taxSvc.IsAuthorizedResult();
				if(successFlag)
				{
					opres.ResultCode = 'Success';
				}					
				else
				{
					opres.ResultCode = 'Fail';
            		opres.Messages = new TaxSvc.ArrayOfMessage();
            		opres.Messages.Message = new TaxSvc.Message[1];
            		opres.Messages.Message[0] = new TaxSvc.Message();
            		opres.Messages.Message[0].Summary = 'Unit Test Error Summary';
            		opres.Messages.Message[0].Details = 'Unit Test Error Details';
				}
			}
			
			Title = 'TestConnect Result: ' + opres.ResultCode + '\r\n';
			if(opres.ResultCode == 'Success')
			{
				UserMessage = 'Avalara Service URL \'' + config.Service_URL__c +
					'\' Availability Verified\r\nAccount Number \'' + config.Account_Number__c +
					'\' Validated\r\nExpiration Date: ' + opres.Expires.date();
            }
   	        else
       	    {
           	    UserMessage = 'Error Message: ' + opres.Messages.Message[0].Name + '\r\n' +
               		'Summary: ' + opres.Messages.Message[0].Summary + '\r\n' +
              		'Details: ' + opres.Messages.Message[0].Details;
			}
		}
		catch(Exception ex)
		{
			return AvaStaticHelpers.ShowException(ex, apCurPage);
		}
            
        return AvaStaticHelpers.ShowMessageBox(Title,UserMessage,apCurPage);
    }
}