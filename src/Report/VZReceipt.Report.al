report 84103 JXVZReceipt
{
    Caption = 'Receipt', Comment = 'ESP=Recibo';
    DefaultLayout = RDLC;
    //UsageCategory = None;
    RDLCLayout = 'src/ReportLayout/VZReceipt.rdl';

    dataset
    {
        dataitem(JXVZHistoryReceiptHeader; JXVZHistoryReceiptHeader)
        {
            RequestFilterFields = JXVZReceiptNo;
            column(Number; Number)
            {
            }
            column(JXVZHistoryReceiptHeader_JXVZDocumentDate; JXVZHistoryReceiptHeader.JXVZDocumentDate)
            {
            }
            column(JXVZName; JXVZName)
            {
            }
            column(JXVZAddress; Customer.Address + ', ' + Customer."Post Code" + ', ' + Customer.City)
            {
            }
            column(JXVZRIF; JXVZRIF)
            {
            }
            column(JXVZHistoryReceiptHeader_JXVZCustomerNo; JXVZHistoryReceiptHeader.JXVZCustomerNo)
            {
            }
            column(NumberIIBB; '')
            {
            }
            column(CompanyInformation_Address; CompanyInformation.Address + ', ' + CompanyInformation."Post Code" + ', ' + CompanyInformation.City + ', ' + CompanyInformation."Country/Region Code")
            {
            }
            column(CompanyInformation_Name; CompanyInformation.Name)
            {
            }
            column(JXVZUserId; JXVZUserId)
            {
            }
            dataitem(JXVZHistReceiptVoucherLine; JXVZHistReceiptVoucherLine)
            {
                DataItemLink = JXVZREceiptNo = FIELD(JXVZREceiptNo);
                DataItemTableView = SORTING(JXVZREceiptNo, JXVZVoucherNo, JXVZEntryNo);
                MaxIteration = 0;
                column(DocumentNo; JXVZHistReceiptVoucherLine.JXVZVoucherNo)
                {
                }
                column(JXVZDate; JXVZHistReceiptVoucherLine.JXVZDate)
                {
                }
                column(JXVZAmount; JXVZAmount)
                {
                }
                column(Currencyvalue; Currencyvalue)
                {
                }
                column(JXVZCancelled; JXVZCancelled)
                {
                }
                column(AmountLocal; AmountLocal)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if JXVZHistReceiptVoucherLine.JXVZCurrencyCode = '' then
                        Currencyvalue := CompanyInformation.JXVZLocalCurrencyDesc
                    else
                        Currencyvalue := JXVZHistReceiptVoucherLine.JXVZCurrencyCode;

                    if JXVZCurrencyFactor <> 0 then
                        AmountLocal := JXVZCancelled / JXVZCurrencyFactor
                    else
                        AmountLocal := JXVZCancelled;
                    TotalAmountLocal := TotalAmountLocal + AmountLocal;

                    if (JXVZDocumentType = JXVZDocumentType::"Nota d/c") then begin
                        AmountLocal := -abs(AmountLocal);
                        TotalAmountLocal := -abs(TotalAmountLocal);
                        JXVZCancelled := -abs(JXVZCancelled);
                        JXVZAmount := -abs(JXVZAmount);
                    end;

                end;

                trigger OnPreDataItem()
                begin
                    TotalAmountLocal := 0;
                end;
            }
            dataitem(JXVZHistReceiptValueLine; JXVZHistReceiptValueLine)
            {
                DataItemLink = JXVZReceiptNo = FIELD(JXVZReceiptNo);
                DataItemTableView = SORTING(JXVZReceiptNo, JXVZLineNo);
                column(JXVZValueNo; JXVZValueNo)
                {
                }
                column(JXVZdescription; JXVZHistReceiptValueLine.JXVZDescription)
                {
                }
                column(JXVZEntity; JXVZEntity)
                {
                }
                column(JXVZToDate; JXVZToDate)
                {
                }
                column(PostedValueLineAmount; JXVZAmount)
                {
                }
                column(CurrencyvalueVaL; Currencyvalue)
                {
                }
                column(PostedValueLineAmountLocal; AmountLocal)
                {
                }
                column(PostedValueLineAmount_Control1000000048; JXVZAmount)
                {
                }
                column(TotalAmountLocal_Control1000000053; TotalAmountLocal)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if JXVZHistReceiptValueLine.JXVZCurrencyCode = '' then
                        Currencyvalue := CompanyInformation.JXVZLocalCurrencyDesc
                    else
                        Currencyvalue := JXVZHistReceiptValueLine.JXVZCurrencyCode;

                    if JXVZCurrencyFactor <> 0 then
                        AmountLocal := JXVZAmount / JXVZCurrencyFactor
                    else
                        AmountLocal := JXVZAmount;

                    TotalAmountLocal := TotalAmountLocal + AmountLocal;
                end;

                trigger OnPreDataItem()
                begin
                    TotalAmountLocal := 0;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Customer.Get(JXVZHistoryReceiptHeader.JXVZCustomerNo);
                Number := JXVZReceiptNo;

                CompanyInformation.Get();
                CompanyInformation.CalcFields(CompanyInformation.Picture);
            end;
        }
    }

    var
        Customer: Record Customer;
        CompanyInformation: Record "Company Information";
        Currencyvalue: Code[20];
        AmountLocal: Decimal;
        TotalAmountLocal: Decimal;
        Number: Text[20];
}