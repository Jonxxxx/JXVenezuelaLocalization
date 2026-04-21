report 84120 JXVZSalesCreditMemo
{
    Caption = 'Venezuela - Nota de Crédito de Venta';
    UsageCategory = None;
    DefaultLayout = RDLC;
    RDLCLayout = 'src/ReportLayout/VZSalesCreditMemo.rdl';

    dataset
    {
        dataitem("Sales Cr. Memo Header"; "Sales Cr.Memo Header")
        {
            column(CustomerName; "Sell-to Customer Name") { }
            column(CustomerRIF; "VAT Registration No.") { }
            column(CustomerAddress; "Sell-to Address") { }
            column(CustomerCity; "Sell-to City") { }
            column(CustomerState; "Sell-to County") { }
            column(CustomerNo; "VAT Registration No.") { }
            column(DueDate; "Due Date") { }
            column(No__Series; "No. Series") { }
            column(PostingDate; "Posting Date") { }
            column(SalespersonCode; "Salesperson Code") { }
            column(InvoiceNo; InvoiceNo) { }
            column(OrderNo; "Applies-to Doc. No.") { }
            column(ControlNo; "Your Reference") { }
            column(InvoiceDate; "Posting Date") { }
            column(Pre_Assigned_No_; "Applies-to Doc. No.") { }
            column(Due_Date; "Due Date") { }
            column(Payment_Terms_Code; "Payment Terms Code") { }
            column(Amountinv; FormatDecimals(Amountinv, 0.0001)) { }
            column(VatAmount; FormatDecimals(VatAmount, 0.0001)) { }
            column(DiscountAmount; FormatDecimals(DiscountAmount, 0.01)) { }
            column(DiscountAmountinv; FormatDecimals(DiscountAmountinv, 0.01)) { }
            column(TotalInvoice; FormatDecimals(TotalInvoice, 0.0001)) { }
            column(AmountinvCurrencyFact; AmountinvCurrencyFact) { }
            column(VatAmountCurrencyFact; VatAmountCurrencyFact) { }
            column(DiscountAmountCurrencyFact; DiscountAmountCurrencyFact) { }
            column(DiscountAmountinvCurrencyFact; DiscountAmountinvCurrencyFact) { }
            column(TotalInvoiceCurrencyFact; TotalInvoiceCurrencyFact) { }
            column(TipoDeCambio; TipoDeCambio) { }
            column(Contador; contador) { }
            column(Moneda; Moneda) { }
            column(DireccionTotal; DireccionTotal) { }
            dataitem("Sales Cr. Memo Line"; "Sales Cr.Memo Line")
            {
                DataItemLink = "Document No." = field("No.");
                column(ItemNo; "No.") { }
                column(Quantity; Quantity) { }
                column(Description; Description) { }
                column(UnitPrice; FormatDecimals("Unit Price", 0.0001)) { }
                column(Line_Discount__; "Line Discount %") { }
                column(LineAmount; FormatDecimals("Line Amount", 0.0001)) { }

                trigger OnAfterGetRecord()
                var
                    SalesLines: Record "Sales Cr.Memo Line";
                    Customer: Record Customer;
                    CurrencyFactor: Decimal;
                    SalesLineCurrencyFactor: Record "Sales Cr.Memo Line";

                begin
                    SalesLines.SetRange("Document No.", "Sales Cr. Memo Line"."Document No.");
                    Amountinv := 0;
                    VatAmount := 0;
                    DiscountAmount := 0;
                    DiscountAmountinv := 0;
                    TotalInvoice := 0;

                    CurrencyFactor := 1;
                    if "Sales Cr. Memo Header"."Currency Code" <> '' then begin
                        CurrencyFactor := "Sales Cr. Memo Header"."Currency Factor";
                        SalesLineCurrencyFactor.SetRange("Document No.", "Sales Cr. Memo Line"."Document No.");
                        if SalesLineCurrencyFactor.FindSet() then
                            repeat
                                TipoDeCambio := 1 / "Sales Cr. Memo Header"."Currency Factor";
                                AmountinvCurrencyFact += SalesLineCurrencyFactor."Unit Price" * SalesLineCurrencyFactor.Quantity * TipoDeCambio;
                                VatAmountCurrencyFact += SalesLineCurrencyFactor."VAT Base Amount" * SalesLineCurrencyFactor."VAT %" / 100 * TipoDeCambio;
                                DiscountAmountCurrencyFact += SalesLineCurrencyFactor."Line Discount Amount" * TipoDeCambio;
                                DiscountAmountinvCurrencyFact += SalesLineCurrencyFactor."Inv. Discount Amount" * TipoDeCambio;
                            until SalesLineCurrencyFactor.Next() = 0;
                        TotalInvoiceCurrencyFact := AmountinvCurrencyFact + VatAmountCurrencyFact - DiscountAmountCurrencyFact - DiscountAmountinvCurrencyFact;
                    end;
                    if SalesLines.FindSet() then
                        repeat
                            contador += 1;
                            Amountinv += SalesLines."Unit Price" * SalesLines.Quantity;
                            VatAmount += SalesLines."VAT Base Amount" * SalesLines."VAT %" / 100;
                            DiscountAmount += SalesLines."Line Discount Amount";
                            DiscountAmountinv += SalesLines."Inv. Discount Amount";
                        until SalesLines.Next() = 0;
                    TotalInvoice := Amountinv + VatAmount - DiscountAmount - DiscountAmountinv;
                    Customer.get("Sales Cr. Memo Header"."Sell-to Customer No.");
                    DireccionTotal := Customer."Address" + ' ' + Customer."City" + ' ' + Customer."County" + ' ' + Customer."Post Code";
                    InvoiceNo := "Sales Cr. Memo Header"."No.";

                    if "Sales Cr. Memo Header"."Currency Code" = 'USD' then begin
                        Moneda := 'US$';
                    end;
                end;


            }
        }
    }
    local procedure FormatDecimals(DecimalField: Decimal; PrecisiOn: Decimal) DEC: Decimal
    var
    begin
        if DecimalField = 0 then begin
            DEC := 0.00;
        end else begin
            DEC := ROUND(DecimalField, PrecisiOn, '=');
        end;

        exit(DEC);
    end;

    var

        DireccionTotal: text;
        Amountinv: Decimal;
        VatAmount: Decimal;
        DiscountAmount: Decimal;
        DiscountAmountinv: Decimal;
        TotalInvoice: Decimal;
        AmountinvCurrencyFact: Decimal;
        VatAmountCurrencyFact: Decimal;
        DiscountAmountCurrencyFact: Decimal;
        DiscountAmountinvCurrencyFact: Decimal;

        TotalInvoiceCurrencyFact: Decimal;

        TipoDeCambio: Decimal;
        InvoiceNo: Code[20];
        Moneda: Text[10];
        contador: Integer;

}