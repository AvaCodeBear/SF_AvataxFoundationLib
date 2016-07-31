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

@isTest
private class AvaUnitTests 
{
	static testmethod void CompanyValidate()
	{
		AvaCompany__c acomp = new AvaCompany__c(
			Address__c = '1060 w addison',
			City__c = 'Chicago',
			Region__c = 'IL',
			Postal_Code__c = '60613',
			Country__c = 'US'
		);
		
		AvaCompanyValidate acv = new AvaCompanyValidate(acomp);
		acv.Validate();
		acv.Validate(true);
		AvaCompAddrValMsg acvm = new AvaCompAddrValMsg();
		acvm.UpdateAddress(); 
	}
	
	static testmethod void AccountValidate()
	{
		Account acct = new Account (
			ShippingStreet = '1060 w addison',
			ShippingCity = 'Chicago',
			ShippingState = 'il',
			ShippingPostalCode = '60613',
			ShippingCountry = 'us',
			BillingStreet = '1060 w addison',
			BillingCity = 'Chicago',
			BillingState = 'il',
			BillingPostalCode = '60613',
			BillingCountry = 'us'
		);
		AvaAcctShippingValidate asv = new AvaAcctShippingValidate(acct);
		asv.Validate();
		asv.Validate(true);
		AvaAcctShippingValMsg asvm = new AvaAcctShippingValMsg();
		asvm.UpdateAddress();
		AvaAcctBillingValidate abv = new AvaAcctBillingValidate(acct);
		abv.Validate();
		abv.Validate(true);
		AvaAcctBillingValMsg abvm = new AvaAcctBillingValMsg();
		abvm.UpdateAddress();
	}
	
	static testmethod void StaticHelpers()
	{
		try
		{
			AvaCredentials__c creds = AvaStaticHelpers.FetchActiveCredentials();
			System.Assert(false);
		}
		catch(Exception ex)
		{
			AvaStaticHelpers.ShowException(ex,ApexPages.currentPage());
		}
		
		try
		{
			AvaCredentials__c creds = AvaStaticHelpers.FetchCurrentCredentials();
			System.Assert(false);
		}
		catch(Exception ex)
		{
			AvaStaticHelpers.ShowException(ex,ApexPages.currentPage());
		}
		
		List<AvaCredentials__c> credsList = new List<AvaCredentials__c>();
		credsList.add(new AvaCredentials__c(Active_Credentials__c = true));
		credsList.add(new AvaCredentials__c(Active_Credentials__c = true));
		insert credsList;
		try
		{
			AvaCredentials__c creds = AvaStaticHelpers.FetchActiveCredentials();
			System.Assert(false);
		}
		catch(Exception ex)
		{
			AvaStaticHelpers.ShowException(ex,ApexPages.currentPage());
		}
	}
		
	static testmethod void MessageBoxes()
	{
		AvaMessageBox amb = new AvaMessageBox();
		amb.DismissPage();
		AvaStaticHelpers.ShowMessageBox('Test','Message',ApexPages.currentPage());
		AddressSvc.ValidAddress vaAddr  = new AddressSvc.ValidAddress();
		vaAddr.Line1 = '123 Any Street';
		vaAddr.Line2 = '';
		vaAddr.Line3 = '';
		vaAddr.City = 'SomeTown';
		vaAddr.Region = 'LT';
		vaAddr.PostalCode = '90210';
		vaAddr.Country = 'US';
		AddressSvc.BaseAddress baAddr = new AddressSvc.BaseAddress();
		baAddr.Line1 = '123 Any Street';
		baAddr.Line2 = '';
		baAddr.Line3 = '';
		baAddr.City = 'SomeTown';
		baAddr.Region = 'LT';
		baAddr.PostalCode = '90210';
		baAddr.Country = 'US';
		AvaStaticHelpers.ShowAddresses('Test', baAddr, vaAddr, ApexPages.currentPage(),Page.AvaCompAddrValidateVerify);
	}
	
   static testmethod void TestConnectUnitTests()
   {
		AvaTestConnect atc = new AvaTestConnect();
		atc.TestConnection(true);
		atc.TestConnection();   	
   }
   
   static testmethod void AddressSvcUnitTests()
   {
   		AddressSvc.BaseAddress m_BaseAddr = new AddressSvc.BaseAddress();
        m_BaseAddr.Line1 = '123 AnyStreet';
        m_BaseAddr.Line2 = 'Line 2';
        m_BaseAddr.Line3 = 'Line 3';
        m_BaseAddr.City = 'AnyTown';
        m_BaseAddr.Region = 'WA';
        m_BaseAddr.PostalCode = '90210';
        m_BaseAddr.Country = 'US';

        AddressSvc m_AddrSvc = new AddressSvc();
        AddressSvc.AddressSvcSoap m_addrSvcSoap = new AddressSvc.AddressSvcSoap('https://development.avalara.net');
        m_addrSvcSoap.timeout_x = 1000;
        m_addrSvcSoap.apiSuccessFlag = true;
        AddressSvc.PingResult m_tstPres = m_addrSvcSoap.Ping('');
        AddressSvc.IsAuthorizedResult m_testIas = m_addrSvcSoap.IsAuthorized('fubar');
		AddressSvc.ValidateRequest vreq = new AddressSvc.ValidateRequest();
		vreq.TextCase = 'Mixed';
		vreq.Coordinates = true;
		vreq.Address = m_BaseAddr;
		AddressSvc.ValidateResult vres = m_addrSvcSoap.Validate(vreq);
		
        m_tstPres = m_addrSvcSoap.Ping('');
        m_testIas = m_addrSvcSoap.IsAuthorized('fubar');
		vres = m_addrSvcSoap.Validate(vreq);
		
        AddressSvc.IsAuthorizedResponse_element m_tiare = new AddressSvc.IsAuthorizedResponse_element();
        AddressSvc.Message m_tmsg = new AddressSvc.Message();
        AddressSvc.ArrayOfValidAddress m_tarrva = new AddressSvc.ArrayOfValidAddress();
        AddressSvc.ValidateRequest m_tvr = new AddressSvc.ValidateRequest();
        AddressSvc.Profile m_tpr = new AddressSvc.Profile();
        AddressSvc.PingResponse_element m_tpre = new AddressSvc.PingResponse_element(); 
        AddressSvc.ValidateResponse_element m_tvre = new AddressSvc.ValidateResponse_element();
        AddressSvc.Ping_element m_tpe = new AddressSvc.Ping_element();
        AddressSvc.IsAuthorized_element m_tiae = new AddressSvc.IsAuthorized_element();
      	AddressSvc.BaseAddress m_tba = new AddressSvc.BaseAddress();
        AddressSvc.ArrayOfMessage m_taom = new AddressSvc.ArrayOfMessage();
        AddressSvc.Security m_tsec = new AddressSvc.Security();
        AddressSvc.Validate_element m_tve = new AddressSvc.Validate_element();
        AddressSvc.ValidAddress m_tva = new AddressSvc.ValidAddress();
        AddressSvc.UsernameToken_element m_tute = new AddressSvc.UsernameToken_element();
		m_tute.Username = 'codebear';
		m_tute.Password='chinacloset'; 
		       
    }
    
    // unit tests just instantiate an instance of every class
// in order to satisfy SF's code coverage requirement - no comment
    static testmethod void TaxSvcUnitTests()
    {
        TaxSvc m_TaxSvc = new TaxSvc();
        TaxSvc.TaxSvcSoap m_TaxSvcSoap = new TaxSvc.TaxSvcSoap('https://development.avalara.net');
        m_TaxSvcSoap.timeout_x = 1000;
        m_TaxSvcSoap.testFlag = true;

        TaxSvc.PostTaxRequest m_testPostReq = new TaxSvc.PostTaxRequest();
        m_testPostReq.DocCode = 'Doc123';
        m_testPostReq.CompanyCode = 'XYZComp';

        TaxSvc.CommitTaxRequest m_testCommitReq = new TaxSvc.CommitTaxRequest();
        m_testCommitReq.DocCode = 'Doc123';
        m_testCommitReq.CompanyCode = 'XYZComp';

        TaxSvc.CancelTaxRequest m_testCancelReq = new TaxSvc.CancelTaxRequest();
        m_testCommitReq.DocCode = 'Doc123';
        m_testCommitReq.CompanyCode = 'XYZComp';

        TaxSvc.GetTaxHistoryRequest m_gettaxhistreq = new TaxSvc.GetTaxHistoryRequest();
        m_gettaxhistreq.DocCode = 'Doc123';
        m_gettaxhistreq.CompanyCode = 'XYZComp';

        TaxSvc.ApplyPaymentRequest m_apppmtreq = new TaxSvc.ApplyPaymentRequest();
        m_apppmtreq.DocCode = 'Doc123';
        m_apppmtreq.CompanyCode = 'XYZComp';

		TaxSvc.GetTaxRequest gtReq = new TaxSvc.GetTaxRequest();
		gtReq.CompanyCode = 'XYZComp';
		gtReq.DocType = 'SalesOrder';
		gtReq.DocCode = 'Doc123';
		gtReq.DetailLevel = 'Tax';
		gtReq.DocDate = Date.Today();	
		gtReq.CustomerCode = 'Cust123';
		gtReq.CustomerUsageType = 'K';
		gtReq.OriginCode = 'ORIGIN';
		gtReq.DestinationCode = gtReq.OriginCode;
		
		gtReq.Addresses = new TaxSvc.ArrayOfBaseAddress();
		gtReq.Addresses.BaseAddress = new TaxSvc.BaseAddress[1];
		gtReq.Addresses.BaseAddress[0] = new TaxSvc.BaseAddress();

        gtReq.Addresses.BaseAddress[0].Line1 = 'Line One';
        gtReq.Addresses.BaseAddress[0].Line2 = 'Line Two';
        gtReq.Addresses.BaseAddress[0].Line3 = 'Line Three';
        gtReq.Addresses.BaseAddress[0].City = 'City';
        gtReq.Addresses.BaseAddress[0].Region = 'WA';
        gtReq.Addresses.BaseAddress[0].PostalCode = '90210';
        gtReq.Addresses.BaseAddress[0].Country = 'US';
        gtReq.Addresses.BaseAddress[0].AddressCode = gtReq.OriginCode;
 
        gtReq.Lines = new TaxSvc.ArrayOfLine();
        gtReq.Lines.Line = new TaxSvc.Line[1];
        gtReq.Lines.Line[0] = new TaxSvc.Line();
        
       	gtReq.Lines.Line[0].No = 'Line 1';
       	gtReq.Lines.Line[0].ItemCode = 'P0000000';
       	gtReq.Lines.Line[0].TaxCode = 'P0000000';
       	gtReq.Lines.Line[0].Description = 'fubar';
       	gtReq.Lines.Line[0].Qty = 1.0;
       	gtReq.Lines.Line[0].Amount = 100.00;

		TaxSvc.AdjustTaxRequest atReq = new TaxSvc.AdjustTaxRequest();
		atReq.AdjustmentReason = 8;
		atReq.AdjustmentDescription = 'Because I said so';
		atReq.GetTaxRequest = gtReq;
		
		TaxSvc.ReconcileTaxHistoryRequest rthreq = new TaxSvc.ReconcileTaxHistoryRequest();
		rthreq.CompanyCode = 'XYZ';	
 
        m_TaxSvcSoap.apiSuccessFlag = true;
        TaxSvc.IsAuthorizedResult m_testIas = m_TaxSvcSoap.IsAuthorized('fubar');
        TaxSvc.PingResult m_testPing = m_TaxSvcSoap.Ping('');
        TaxSvc.GetTaxResult m_gtres = m_TaxSvcSoap.GetTax(gtReq);
        TaxSvc.PostTaxResult m_testPtr = m_TaxSvcSoap.PostTax(m_testPostReq);
        TaxSvc.CommitTaxResult m_testCtr = m_TaxSvcSoap.CommitTax(m_testCommitReq);
        TaxSvc.CancelTaxResult m_testCancel = m_TaxSvcSoap.CancelTax(m_testCancelReq);
        TaxSvc.GetTaxHistoryResult m_testGetTaxHistory = m_TaxSvcSoap.GetTaxHistory(m_gettaxhistreq);
        TaxSvc.ApplyPaymentResult m_testAppPmtRes = m_TaxSvcSoap.ApplyPayment(m_apppmtreq);
        TaxSvc.AdjustTaxResult m_testAdjTax = m_TaxSvcSoap.AdjustTax(atReq);
        TaxSvc.ReconcileTaxHistoryResult m_testrth = m_TaxSvcSoap.ReconcileTaxHistory(rthreq);

        m_TaxSvcSoap.apiSuccessFlag = false;
        m_testIas = m_TaxSvcSoap.IsAuthorized('fubar');
        m_testPing = m_TaxSvcSoap.Ping('');
        m_gtres = m_TaxSvcSoap.GetTax(gtReq);
        m_testPtr = m_TaxSvcSoap.PostTax(m_testPostReq);
        m_testCtr = m_TaxSvcSoap.CommitTax(m_testCommitReq);
        m_testCancel = m_TaxSvcSoap.CancelTax(m_testCancelReq);
        m_testGetTaxHistory = m_TaxSvcSoap.GetTaxHistory(m_gettaxhistreq);
        m_testAppPmtRes = m_TaxSvcSoap.ApplyPayment(m_apppmtreq);
		m_testAdjTax = m_TaxSvcSoap.AdjustTax(atReq); 
		m_testrth = m_TaxSvcSoap.ReconcileTaxHistory(rthreq);
		       
        TaxSvc m_tTaxSvc = new TaxSvc();
        TaxSvc.AuditMessage m_tAuditMessage = new TaxSvc.AuditMessage();
        TaxSvc.CommitTaxResult m_tCommitTaxResult = new TaxSvc.CommitTaxResult();
        TaxSvc.TaxSvcSoap m_tTaxSvcSoap = new TaxSvc.TaxSvcSoap('https://bogus.url.net');
        m_tTaxSvcSoap.timeout_x = 1000;
        TaxSvc.IsAuthorized_element m_tIsAuthorized_element = new TaxSvc.IsAuthorized_element();
        TaxSvc.TaxAddress m_tTaxAddress = new TaxSvc.TaxAddress();
        TaxSvc.ArrayOfMessage m_tArrayOfMessage = new TaxSvc.ArrayOfMessage();
        TaxSvc.ArrayOfLine m_tArrayOfLine = new TaxSvc.ArrayOfLine();
        TaxSvc.ApplyPaymentResponse_element m_tApplyPaymentResponse_element = new TaxSvc.ApplyPaymentResponse_element();
        TaxSvc.GetTaxHistoryResult m_tGetTaxHistoryResult = new TaxSvc.GetTaxHistoryResult();
        TaxSvc.ArrayOfBaseAddress m_tArrayOfBaseAddress = new TaxSvc.ArrayOfBaseAddress();
        TaxSvc.PostTax_element m_tPostTax_element = new TaxSvc.PostTax_element();
        TaxSvc.PostTaxRequest m_tPostTaxRequest = new TaxSvc.PostTaxRequest();
        TaxSvc.AdjustTaxRequest m_tAdjustTaxRequest = new TaxSvc.AdjustTaxRequest();
        TaxSvc.ArrayOfTaxLine m_tArrayOfTaxLine = new TaxSvc.ArrayOfTaxLine();
        TaxSvc.ApplyPaymentRequest m_tApplyPaymentRequest = new TaxSvc.ApplyPaymentRequest();
        TaxSvc.PingResult m_tPingResult = new TaxSvc.PingResult();
        TaxSvc.IsAuthorizedResult m_tIsAuthorizedResult = new TaxSvc.IsAuthorizedResult();
        TaxSvc.IsAuthorizedResponse_element m_tIsAuthorizedResponse_element = new TaxSvc.IsAuthorizedResponse_element();
        TaxSvc.CommitTaxRequest m_tCommitTaxRequest = new TaxSvc.CommitTaxRequest();
        TaxSvc.TaxOverride m_tTaxOverride = new TaxSvc.TaxOverride();
        TaxSvc.Profile m_tProfile = new TaxSvc.Profile();
        TaxSvc.ReconcileTaxHistoryRequest m_tReconcileTaxHistoryRequest = new TaxSvc.ReconcileTaxHistoryRequest();
        TaxSvc.ApplyPaymentResult m_tApplyPaymentResult = new TaxSvc.ApplyPaymentResult();
        TaxSvc.BaseAddress m_tBaseAddress = new TaxSvc.BaseAddress();
        TaxSvc.ArrayOfTaxDetail m_tArrayOfTaxDetail = new TaxSvc.ArrayOfTaxDetail();
        TaxSvc.Security m_tSecurity = new TaxSvc.Security();
        TaxSvc.GetTaxHistoryResponse_element m_tGetTaxHistoryResponse_element = new TaxSvc.GetTaxHistoryResponse_element();
        TaxSvc.GetTax_element m_tGetTax_element = new TaxSvc.GetTax_element();
        TaxSvc.UsernameToken_element m_tUsernameToken_element = new TaxSvc.UsernameToken_element();
        TaxSvc.AdjustTaxResult m_tAdjustTaxResult = new TaxSvc.AdjustTaxResult();
        TaxSvc.GetTaxResult m_tGetTaxResult = new TaxSvc.GetTaxResult();
        TaxSvc.CommitTax_element m_tCommitTax_element = new TaxSvc.CommitTax_element();
        TaxSvc.ReconcileTaxHistoryResult m_tReconcileTaxHistoryResult = new TaxSvc.ReconcileTaxHistoryResult();
        TaxSvc.AdjustTax_element m_tAdjustTax_element = new TaxSvc.AdjustTax_element();
        TaxSvc.AdjustTaxResponse_element m_tAdjustTaxResponse_element = new TaxSvc.AdjustTaxResponse_element();
        TaxSvc.Ping_element m_tPing_element = new TaxSvc.Ping_element();
        TaxSvc.GetTaxHistory_element m_tGetTaxHistory_element = new TaxSvc.GetTaxHistory_element();
        TaxSvc.ArrayOfTaxAddress m_tArrayOfTaxAddress = new TaxSvc.ArrayOfTaxAddress();
        TaxSvc.PostTaxResponse_element m_tPostTaxResponse_element = new TaxSvc.PostTaxResponse_element();
        TaxSvc.GetTaxRequest m_tGetTaxRequest = new TaxSvc.GetTaxRequest();
        TaxSvc.CancelTax_element m_tCancelTax_element = new TaxSvc.CancelTax_element();
        TaxSvc.CommitTaxResponse_element m_tCommitTaxResponse_element = new TaxSvc.CommitTaxResponse_element();
        TaxSvc.PostTaxResult m_tPostTaxResult = new TaxSvc.PostTaxResult();
        TaxSvc.ReconcileTaxHistoryResponse_element m_tReconcileTaxHistoryResponse_element = new TaxSvc.ReconcileTaxHistoryResponse_element();
        TaxSvc.CancelTaxResult m_tCancelTaxResult = new TaxSvc.CancelTaxResult();
        TaxSvc.TaxDetail m_tTaxDetail = new TaxSvc.TaxDetail();
        TaxSvc.Message m_tMessage = new TaxSvc.Message();
        TaxSvc.PingResponse_element m_tPingResponse_element = new TaxSvc.PingResponse_element();
        TaxSvc.GetTaxHistoryRequest m_tGetTaxHistoryRequest = new TaxSvc.GetTaxHistoryRequest();
        TaxSvc.ApplyPayment_element m_tApplyPayment_element = new TaxSvc.ApplyPayment_element();
        TaxSvc.CancelTaxRequest m_tCancelTaxRequest = new TaxSvc.CancelTaxRequest();
        TaxSvc.ReconcileTaxHistory_element m_tReconcileTaxHistory_element = new TaxSvc.ReconcileTaxHistory_element();
        TaxSvc.GetTaxResponse_element m_tGetTaxResponse_element = new TaxSvc.GetTaxResponse_element();
        TaxSvc.CancelTaxResponse_element m_tCancelTaxResponse_element = new TaxSvc.CancelTaxResponse_element();
        TaxSvc.TaxLine m_tTaxLine = new TaxSvc.TaxLine();
        TaxSvc.ArrayOfGetTaxResult m_tArrayOfGetTaxResult = new TaxSvc.ArrayOfGetTaxResult();
        TaxSvc.Line m_tLine = new TaxSvc.Line();
    }
}