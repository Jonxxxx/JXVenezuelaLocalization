report 84108 JXVZRetentionsBook
{
    Caption = 'Withholding book', Comment = 'ESP=Libro retenciones';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'ReportLayout/ARRetentionsBook.rdl';


    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = SORTING(Number) ORDER(Ascending) WHERE(Number = CONST(1));
            column(ToDate; ToDate)
            {
            }
            column(Folio; Folio)
            {
            }
            column(FromDate; FromDate)
            {
            }
            column(CompanyInformation_VATRegistrationNo; CompanyInformation."VAT Registration No.")
            {
            }
            column(CompanyInformation_Name; CompanyInformation.Name)
            {
            }
            column(CompanyInformation_Address; CompanyInformation.Address + ', ' + CompanyInformation."Post Code" + ', ' + CompanyInformation.City + ', ' + CompanyInformation."Country/Region Code")
            {
            }
            column(CompanyInformation_County; CompanyInformation.County)
            {
            }
            column(Integer_Number; Number)
            {
            }

            dataitem(JXVZHistoryReceiptHeaderDT; JXVZHistoryReceiptHeader)
            {
                DataItemTableView = SORTING(JXVZReceiptNo) ORDER(Ascending);
                RequestFilterHeading = 'For Sales';

                dataitem(JXVZPaymentValueEntrySales; JXVZHistReceiptValueLine)
                {
                    DataItemLink = JXVZReceiptNo = field(JXVZReceiptNo);
                    DataItemTableView = SORTING(JXVZReceiptNo, JXVZLineNo) ORDER(Ascending);

                    column(JXVZPaymentValueEntrySales_JXVZPostingDate; JXVZHistoryReceiptHeader.JXVZPostingDate)
                    {
                    }
                    column(JXVZPaymentValueEntrySales_JXVZDocumentNo; JXVZPaymentValueEntrySales.JXVZReceiptNo)
                    {
                    }
                    column(JXVZPaymentValueEntrySales_JXVZValue; JXVZPaymentValueEntrySales.JXVZDescription)
                    {
                    }
                    column(JXVZPaymentValueEntrySales_JXVZSeriesCode; JXVZPaymentValueEntrySales.JXVZSeriesCode)
                    {
                    }
                    column(JXVZPaymentValueEntrySales_JXVZAmount; JXVZPaymentValueEntrySales.JXVZAmount)
                    {
                    }
                    column(JXVZPaymentValueEntrySales_JXVZValueNo; JXVZPaymentValueEntrySales.JXVZValueNo)
                    {
                    }
                    column(Customer_No; Customer."No.")
                    {
                    }
                    column(Customer_VATRegistrationNo; Customer."VAT Registration No.")
                    {
                    }
                    column(Customer_Name; Customer.Name)
                    {
                    }
                    column(DescripAccountSales; DescripAccountSales)
                    { }
                    column(CertDateSales; JXVZPaymentValueEntrySales.JXVZToDate)
                    { }

                    trigger OnAfterGetRecord()
                    var
                        GLAccount: Record "G/L Account";
                    begin
                        Clear(DescripAccountSales);
                        GLAccount.Reset();
                        GLAccount.SetRange("No.", JXVZPaymentValueEntrySales.JXVZAccount);
                        if GLAccount.FindFirst() then
                            DescripAccountSales := GLAccount.Name
                        else
                            DescripAccountSales := JXVZPaymentValueEntrySales.JXVZDescription;

                        JXVZHistoryReceiptHeader.Reset();
                        JXVZHistoryReceiptHeader.SetRange(JXVZReceiptNo, JXVZPaymentValueEntrySales.JXVZReceiptNo);
                        if JXVZHistoryReceiptHeader.FindFirst() then begin
                            Customer.Reset();
                            Customer.SetCurrentKey("No.");
                            Customer.SetRange("No.", JXVZHistoryReceiptHeader.JXVZCustomerNo);
                            if Customer.FindFirst() then;
                        end;
                    end;

                    trigger OnPreDataItem()
                    begin
                        //JXVZPaymentValueEntrySales.SetRange(JXVZPaymentValueEntrySales.JXVZToDate, FromDate, ToDate);                        
                        JXVZPaymentValueEntrySales.SetFilter(JXVZPaymentValueEntrySales.JXVZValueNo, '<>%1', '');
                    end;
                }

                trigger OnPreDataItem()
                begin
                    JXVZHistoryReceiptHeaderDT.SetRange(JXVZPostingDate, FromDate, ToDate);
                    JXVZHistoryReceiptHeaderDT.SetRange(JXVZStatus, JXVZHistoryReceiptHeaderDT.JXVZStatus::Registered);
                end;
            }

            dataitem(JXVZPaymentValueEntryPurch; JXVZWithholdLedgerEntry)
            {
                DataItemTableView = SORTING(JXVZNo) ORDER(Ascending) WHERE(JXVZWitholdingType = CONST(Realizada));
                RequestFilterHeading = 'En Compras';
                column(JXVZPaymentValueEntryPurch_JXVZAmount; JXVZPaymentValueEntryPurch.JXVZWitholdingAmount)
                {
                }
                column(JXVZPaymentValueEntryPurch_JXVZSeriesCode; JXVZPaymentValueEntryPurch.JXVZWitholdingCertificateNo)
                {
                }
                column(JXVZPaymentValueEntryPurch_JXVZValue; JXVZPaymentValueEntryPurch.JXVZTaxCode)
                {
                }
                column(JXVZPaymentValueEntryPurch_JXVZDocumentNo; JXVZPaymentValueEntryPurch.JXVZVoucherNo)
                {
                }
                column(JXVZPaymentValueEntryPurch_JXVZPostingDate; JXVZPaymentValueEntryPurch.JXVZWitholdingDate)
                {
                }
                column(JXVZPaymentValueEntryPurch_JXVZValueNo; JXVZPaymentValueEntryPurch.JXVZWitholdingCertificateNo)
                {
                }
                column(Vendor_No; Vendor."No.")
                {
                }
                column(Vendor_VATRegistrationNo; Vendor."VAT Registration No.")
                {
                }
                column(Vendor_Name; Vendor.Name)
                {
                }
                column(WitholdCertDate; WitholdCertDate)
                {
                }

                trigger OnAfterGetRecord()

                begin
                    Vendor.Reset();
                    Vendor.SetCurrentKey("No.");
                    Vendor.SetRange("No.", JXVZPaymentValueEntryPurch.JXVZVendorCode);
                    if Vendor.FindFirst() then;

                    if JXVZPaymentValueEntryPurch.JXVZWitholdingCertDate <> 0D then
                        WitholdCertDate := JXVZPaymentValueEntryPurch.JXVZWitholdingCertDate
                    else
                        WitholdCertDate := JXVZPaymentValueEntryPurch.JXVZWitholdingDate;
                end;

                trigger OnPreDataItem()
                begin
                    JXVZPaymentValueEntryPurch.SetRange(JXVZPaymentValueEntryPurch.JXVZWitholdingDate, FromDate, ToDate);
                end;
            }
            dataitem(JXVZPaymentValueEntryTotals; JXVZPaymentValueEntry)
            {
                DataItemTableView = SORTING(JXVZDescription) ORDER(Ascending) WHERE(JXVZDocumentType = CONST(Recibo));
                column(JXVZPaymentValueEntryTotals_JXVZValue; '')
                {
                }
                column(JXVZPaymentValueEntryTotals_JXVZAmount; JXVZPaymentValueEntryTotals.JXVZAmount)
                {
                }
                column(TotalsText; "Text")
                {
                }

                trigger OnAfterGetRecord()
                begin

                end;

                trigger OnPreDataItem()
                begin
                    JXVZPaymentValueEntryTotals.Reset();
                    JXVZPaymentValueEntryTotals.SetRange(JXVZPaymentValueEntryTotals.JXVZPostingDate, FromDate, ToDate);
                end;
            }

            trigger OnPreDataItem()
            begin
                CompanyInformation.Reset();
                CompanyInformation.Get('');
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Opciones)
                {
                    Caption = 'Options', Comment = 'ESP=Opciones';
                    field(Desde; FromDate)
                    {
                        ApplicationArea = All;
                        Caption = 'From', Comment = 'ESP=Desde';
                        ToolTip = 'From', Comment = 'ESP=Desde';
                    }
                    field(Hasta; ToDate)
                    {
                        ApplicationArea = All;
                        Caption = 'To', Comment = 'ESP=Hasta';
                        ToolTip = 'To', Comment = 'ESP=Hasta';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    procedure SetDates(_FromDate: Date; _ToDate: Date)
    begin
        FromDate := _FromDate;
        ToDate := _ToDate;
    end;

    var
        CompanyInformation: Record "Company Information";
        Customer: Record Customer;
        Vendor: Record Vendor;
        JXVZHistoryReceiptHeader: Record JXVZHistoryReceiptHeader;
        Folio: Integer;
        FromDate: Date;
        ToDate: Date;
        "Text": Text[30];
        DescripAccountSales: Text[100];
        WitholdCertDate: Date;
}

