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

public with sharing class AvaStaticHelpers 
{
	 public class CBSException extends Exception {}
	 
     static public PageReference ShowMessageBox(string MsgBoxTitle, string MsgContent, PageReference RetPage)
     {
        AvaUserMessage__c oMsgBoxMessage = new AvaUserMessage__c
        (
        	MessageBoxTitle__c = MsgBoxTitle, 
        	Message_Col1__c = MsgContent,
        	ReturnPageID__c = RetPage.getParameters().get('id'), Name = UserInfo.getUserId()
        );          

        insert oMsgBoxMessage;
        PageReference pageRef = Page.AvaMessageBox;         
        pageRef.setRedirect(false);         
        return pageRef;                     
     }

    
	// Displays Original and Validated addresses side by side and allows user to pick which to keep
	 static public PageReference ShowAddresses(string MsgboxTitle, AddressSvc.BaseAddress Original, 
	 	AddressSvc.ValidAddress vaAddr, PageReference ReturnPage, PageReference ShowPage)
     {
     	string Org = Original.Line1.trim();
     	Org += Original.Line2.trim().length() > 0 ? '\r\n' + Original.Line2.trim() : '';
     	Org += Original.Line3.trim().length() > 0 ? '\r\n' + Original.Line3.trim() : '';
     	Org += '\r\n' + Original.City + ', ' + Original.Region + ' ' + Original.PostalCode + '\r\n' + Original.Country;
     	Org = Org.trim();

     	string Val = vaAddr.Line1.trim();
     	Val += vaAddr.Line2.trim().length() > 0 ? '\r\n' + vaAddr.Line2.trim() : '';
     	Val += vaAddr.Line3.trim().length() > 0 ? '\r\n' + vaAddr.Line3.trim() : '';
     	string vStreetAddress = Val.trim();
     	Val += '\r\n' + vaAddr.City + ', ' + vaAddr.Region + ' ' + vaAddr.PostalCode + '\r\n' + vaAddr.Country;
     	Val = Val.trim();
     	
     	
        AvaUserMessage__c oUserMessage = new AvaUserMessage__c
        (
        	MessageBoxTitle__c = MsgboxTitle, 
        	Message_Col1__c = Org, 
        	Message_Col2__c = Val,
        	Street_Address_Col2__c = vStreetAddress,
        	City_Col2__c = vaAddr.City,
        	Region_Col2__c = vaAddr.Region,
        	PostalCode_Col2__c = vaAddr.PostalCode,
        	Country_Col2__c = vaAddr.Country,
        	ReturnPageID__c = ReturnPage.getParameters().get('id'), Name = UserInfo.getUserId()
        );
        insert oUserMessage; 

        ShowPage.setRedirect(false);         
        return ShowPage;                     
     }
     
	
     // Displays Exception info - centralized for consistency
     static public PageReference ShowException(Exception ex, PageReference apCurPage)
     {
     	return AvaStaticHelpers.ShowMessageBox('Validate Threw an Exception of Type ' + ex.getTypeName(), 
			ex.getMessage() + '\r\n\r\nStackTrace:\r\n' + ex.getStackTraceString(), apCurPage);    	
     }

     static public AvaCredentials__c FetchCurrentCredentials()
     {
     	List<AvaCredentials__c> CredList = [select Service_URL__c, Account_Number__c, License_Key__c, 
     			Active_Credentials__c from AvaCredentials__c where id =: ApexPages.currentPage().getParameters().get('id')];
     	
     	if(CredList.size() > 0)
     	{
     		return CredList[0];
     	}
     	else
     	{
     		throw new CBSException('Internal Error Retrieving Current Credential Record');	
     	}
     }

     static public AvaCredentials__c FetchActiveCredentials()
     {
     	List<AvaCredentials__c> CredList = [select Name, Service_URL__c, Account_Number__c, License_Key__c, 
     			Active_Credentials__c from AvaCredentials__c where Active_Credentials__c =: true];
     	
     	if(CredList.size() == 1)
     	{
     		return CredList[0];
     	}
     	else if(CredList.size() == 0)
     	{
     		throw new CBSException('Internal Error: Unable To Fetch Credentials:  No Records Marked as Active');
     	}
     	else
     	{
     		string ErrMsg = 'Error: Found The Following Credentials Marked as Active:\r\n'; 
     	    for(AvaCredentials__c ac : CredList)
     	    {
     	    	ErrMsg += ac.Name + '\r\n';
     	    }
     	    ErrMsg += 'Please Edit and UnCheck \'Active Credentials\' for all but one';
     	    throw new CBSException(ErrMsg);
     	}
     }
     
     // parse a free form street address into a list of exactly 3 strings, each representing
     // line1, line2, line3.  Useful for instantiating an avalara BaseAddress structure from SF.
     static public List<string> parseStreetAddress(string StreetAddress)
     {
     	List<string> rVal = new List<string>();
     	if(StreetAddress == null)
     		StreetAddress = '';
        	
       	List<String> Lines = StreetAddress.trim().split('\r\n');
        
        rVal.add(Lines[0]);
        rVal.add(Lines.size() > 1 ? Lines[1] : '');
        string lastLine = lines.size() > 2 ? Lines[2] : '';
     	for(Integer i = 3; i < Lines.size(); i++)
     	{
     		lastLine += ' ' + Lines[i];
     	}
     	rVal.add(lastLine.trim());
     	
     	return rVal;
     }
     
}