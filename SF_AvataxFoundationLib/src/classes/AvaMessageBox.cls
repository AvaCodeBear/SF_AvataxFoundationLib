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
//
// The latest version of this source file may be obtained from
// https://github.com/AvaCodeBear/SF_AvataxFoundationLib
////////////////////////////////////////////////////////////////////////////////

public with sharing virtual class AvaMessageBox 
{
	public AvaUserMessage__c m_oUserMessage {get; set;}
	public List<AvaUserMessage__c> m_lUserMessages=null;
	
	public AvaMessageBox()
	{
		m_lUserMessages = [select Name, MessageBoxTitle__c, Message_Col1__c, Message_Col2__c,
			City_Col2__c, Region_Col2__c, PostalCode_Col2__c, Country_Col2__c, Street_Address_Col2__c,
			ReturnPageID__c, TimeStamp__c
		    from AvaUserMessage__c where Name =: UserInfo.getUserID() order by TimeStamp__c DESC];
		
		if(m_lUserMessages.size() >= 0 && !Test.isRunningTest())
		{
			m_oUserMessage = m_lUserMessages[0];	// if > 0, timestamp ensures latest one
		}
		else
		{
			m_oUserMessage = new AvaUserMessage__c(Name=UserInfo.getUserID(),MessageBoxTitle__c='Internal Error',
				Message_Col1__c='Unable to Retrieve Message\r\nContact Your Provider', Message_Col2__c=' ',
				City_Col2__c = ' ', Region_Col2__c = ' ', PostalCode_Col2__c = ' ', Country_Col2__c = ' ', 
				ReturnPageID__c = ApexPages.currentPage().getParameters().get('id'));
		}
	
	}
	
	public PageReference DismissPage()
    {
        String retPage = '/' + m_oUserMessage.ReturnPageID__c;
        try
        {
        	delete m_lUserMessages; // delete the list so that if there is more than one record for this user, all are deleted
        							// leftover records for this user can in fact accumulate whenever a MessageBoxPage is
        							// by some other means than pressing the OK button
        }
        catch (Exception ex)
        {
        	// ignore - User may have already deleted message from another tab
        	// for example, test connect on Config tab and Validate Company address on another
        	// then attempting to dismiss each one - the first will delete all messages, and the second 
        	// will attempt again - we ignore the exception the second delete causes - it is benign
        }
        // Redirect the user back to the original page         
        PageReference pageRef = new PageReference(retPage);         
    
        pageRef.setRedirect(true);         
        return pageRef;               
    }

}