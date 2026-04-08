report 84104 JXVZPaymentOrder
{
    Caption = 'Payment order', Comment = 'ESP=Orden de pago';
    DefaultLayout = RDLC;
    RDLCLayout = 'ReportLayout/VZPaymentOrder.rdl';
    UseRequestPage = false;
    //UsageCategory = None;

    dataset
    {
        dataitem(JXVZHistoryPaymOrder; JXVZHistoryPaymOrder)
        {
            RequestFilterFields = JXVZNo;

            column(JXVZHistoryPaymOrder_JXVZName; JXVZHistoryPaymOrder.JXVZName)
            {
            }
            column(JXVZHistoryPaymOrder_JXVZAddress; JXVZHistoryPaymOrder.JXVZAddress)
            {
            }
            column(Vendor_PostCode; Vendor."Post Code")
            {
            }
            column(Vendor_City; Vendor.City)
            {
            }
            column(JXVZHistoryPaymOrder_JXVZPostingDate; JXVZHistoryPaymOrder.JXVZPostingDate)
            {
            }
            column(JXVZHistoryPaymOrder_JXVZCUIT; JXVZHistoryPaymOrder.JXVZCUIT)
            {
            }
            column(JXVZHistoryPaymOrder_JXVZVendorNo; JXVZHistoryPaymOrder.JXVZVendorNo)
            {
            }
            column(CompanyInformation_Address; CompanyInformation.Address + ', ' + CompanyInformation."Post Code" + ', ' + CompanyInformation.City + ', ' + Province + ', ' + CompanyInformation."Country/Region Code")
            {
            }
            column(JXVZHistoryPaymOrder_JXVZNo; JXVZHistoryPaymOrder.JXVZNo)
            {
            }
            column(CompanyInformation_Name; CompanyInformation.Name)
            {
            }
            column(JXVZHistoryPaymOrder_JXVZUserID; JXVZHistoryPaymOrder.JXVZUserID)
            {
            }
            column(Vendor_JXVZWitholdsNo; '')
            {
            }
            column(TextExchRate; TextExchRate)
            { }
            column(CompanyInformation_VATNum; CompanyInformation."VAT Registration No.")
            { }
            dataitem(JXVZHistPaymVoucherLine; JXVZHistPaymVoucherLine)
            {
                DataItemLink = JXVZPaymentOrderNo = FIELD(JXVZNo);
                DataItemLinkReference = JXVZHistoryPaymOrder;
                DataItemTableView = SORTING(JXVZPaymentOrderNo, JXVZVoucherNo);
                MaxIteration = 0;
                column(JXVZHistPaymVoucherLine_JXVZVoucherNo; VendorInvoiceNo/*JXVZVoucherNo*/)
                {
                }
                column(JXVZHistPaymVoucherLine_JXVZDate; JXVZDate)
                {
                }
                column(JXVZHistPaymVoucherLine_JXVZAmount; JXVZAmount)
                {
                }
                column(CurrencyValue; CurrencyValue)
                {
                }
                column(JXVZHistPaymVoucherLine_JXVZCancelledAmount; JXVZCancelledAmount)
                {
                }
                column(AmountLocal; AmountLocal)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if JXVZHistPaymVoucherLine.JXVZCurrencyCode = '' then
                        CurrencyValue := CompanyInformation.JXVZLocalCurrencyDesc
                    else
                        CurrencyValue := JXVZHistPaymVoucherLine.JXVZCurrencyCode;

                    if JXVZCurrencyFactor <> 0 then
                        AmountLocal := JXVZCancelledAmount / JXVZCurrencyFactor
                    else
                        AmountLocal := JXVZCancelledAmount;

                    TotalAmountLocal := TotalAmountLocal + AmountLocal;

                    if (JXVZDocumentType = JXVZDocumentType::"Nota d/c") then begin
                        AmountLocal := -abs(AmountLocal);
                        TotalAmountLocal := -abs(TotalAmountLocal);
                        JXVZCancelledAmount := -abs(JXVZCancelledAmount);
                        JXVZAmount := -abs(JXVZAmount);
                    end;
                    Clear(VendorInvoiceNo);
                    if PurchInvHeader.Get(JXVZHistPaymVoucherLine.JXVZVoucherNo) then
                        VendorInvoiceNo := PurchInvHeader."Vendor Invoice No."
                    else begin
                        PurchCrMemoHdr.Reset();
                        if PurchCrMemoHdr.Get(JXVZHistPaymVoucherLine.JXVZVoucherNo) then
                            VendorInvoiceNo := PurchCrMemoHdr."Vendor Cr. Memo No."
                        else
                            VendorInvoiceNo := 'PAGO A CUENTA';
                    end;

                    if VendorInvoiceNo = '' then
                        VendorInvoiceNo := JXVZHistPaymVoucherLine.JXVZVoucherNo;
                end;

                trigger OnPreDataItem()
                begin
                    TotalAmountLocal := 0;
                    ExchRate := 0;
                end;
            }
            dataitem(JXVZHistPaymValueLine; JXVZHistPaymValueLine)
            {
                DataItemLink = JXVZNo = FIELD(JXVZNo);
                DataItemLinkReference = JXVZHistoryPaymOrder;
                DataItemTableView = SORTING(JXVZNo, JXVZLineNo);
                column(JXVZHistPaymValueLine_JXVZNo; JXVZNo)
                { }
                column(JXVZHistPaymValueLine_JXVZValueNo; JXVZHistPaymValueLine.JXVZValueNo)
                {
                }
                column(JXVZHistPaymValueLine_JXVZDescription; ValueLineDescrip)
                {
                }
                column(JXVZHistPaymValueLine_JXVZToDate; JXVZHistPaymValueLine.JXVZToDate)
                {
                }
                column(JXVZHistPaymValueLine_JXVZAmount; JXVZHistPaymValueLine.JXVZAmount)
                {
                }
                column(CurrencyValueValueLine; CurrencyValue)
                {
                }
                column(AmountLocalValueLine; AmountLocal)
                {
                }
                column(AccountAmount; AccountAmount)
                {
                }
                column(AmountYes; AmountYes)
                {
                }
                trigger OnAfterGetRecord()
                var
                    JXVZPaymentSetup: Record JXVZPaymentSetup;
                    BankAccount: Record "Bank Account";
                    GLAccount: Record "G/L Account";
                begin

                    if JXVZHistPaymValueLine.JXVZCurrencyCode = '' then
                        CurrencyValue := CompanyInformation.JXVZLocalCurrencyDesc
                    else
                        CurrencyValue := JXVZHistPaymValueLine.JXVZCurrencyCode;

                    if JXVZCurrencyFactor <> 0 then
                        AmountLocal := JXVZAmount / JXVZCurrencyFactor
                    else
                        AmountLocal := JXVZAmount;

                    TotalAmountLocal := TotalAmountLocal + AmountLocal;

                    ValueLineDescrip := JXVZHistPaymValueLine.JXVZDescription;

                    JXVZPaymentSetup.Reset();
                    if JXVZPaymentSetup.FindFirst() then;
                    if JXVZPaymentSetup.JXVZAccountDescripOP then begin
                        GLAccount.Reset();
                        GLAccount.SetRange("No.", JXVZHistPaymValueLine.JXVZAccountNo);
                        if GLAccount.FindFirst() then
                            ValueLineDescrip := GLAccount.Name
                        else begin
                            BankAccount.Reset();
                            BankAccount.SetRange("No.", JXVZHistPaymValueLine.JXVZAccountNo);
                            if BankAccount.FindFirst() then
                                ValueLineDescrip := BankAccount.Name;
                        end;
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    TotalAmountLocal := 0;
                end;
            }

            trigger OnAfterGetRecord()
            var
                JXVZHistPaymVoucherLinelocal: Record JXVZHistPaymVoucherLine;
            begin
                Vendor.Get(JXVZHistoryPaymOrder.JXVZVendorNo);
                CompanyInformation.Get();
                JXVZPaymentSetup.Get();
                /*
                JXVZHistPaymVoucherLinelocal.Reset();
                JXVZHistPaymVoucherLinelocal.SetRange(JXVZPaymentOrderNo, JXVZNo);
                JXVZHistPaymVoucherLinelocal.SetFilter(JXVZCurrencyCode, '<>%1', '');
                if JXVZHistPaymVoucherLinelocal.FindFirst() then
                    if JXVZPaymentSetup.JXVZShowTCPaymentReport then
                        if (ExchRate = 0) then begin
                            GenLedgerSetup.Get();
                            if JXVZHistPaymVoucherLinelocal.JXVZCurrencyFactor <> 0 then
                                ExchRate := Round((1 / JXVZHistPaymVoucherLinelocal.JXVZCurrencyFactor), 0.00001);

                            if ExchRate <> 0 then
                                TextExchRate := 'Tipo de cambio: ' + Format(ExchRate);
                        end;*/
            end;
        }
    }
    var
        Vendor: Record Vendor;
        PurchInvHeader: Record "Purch. Inv. Header";
        CompanyInformation: Record "Company Information";
        PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
        GenLedgerSetup: Record "General Ledger Setup";
        JXVZPaymentSetup: Record JXVZPaymentSetup;
        CurrencyValue: Code[20];
        AmountLocal: Decimal;
        TotalAmountLocal: Decimal;
        VendorInvoiceNo: Code[35];
        Province: Text[50];
        AccountAmount: Text[250];
        AmountYes: Text[250];
        ExchRate: Decimal;
        TextExchRate: Text[150];
        ValueLineDescrip: Text[200];
}
