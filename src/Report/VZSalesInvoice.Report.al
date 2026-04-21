report 84119 JXVZSalesInvoice
{
    Caption = 'Venezuela - Factura de Venta';
    UsageCategory = None;
    DefaultLayout = RDLC;
    RDLCLayout = 'src/ReportLayout/VZSalesInvoice.rdl';

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
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
            column(ControlNo; "Your Reference") { }
            column(InvoiceDate; "Posting Date") { }
            column(OrderNo; OrderNo) { }
            column(Due_Date; "Due Date") { }
            column(Payment_Terms_Code; "Payment Terms Code") { }
            column(Order_No_; OrderNo) { }
            column(Amountinv; FormatDecimals(Amountinv, 0.01)) { }
            column(VatAmount; FormatDecimals(VatAmount, 0.01)) { }
            column(DiscountAmount; FormatDecimals(DiscountAmount, 0.01)) { }
            column(DiscountAmountinv; FormatDecimals(DiscountAmountinv, 0.01)) { }
            column(TotalInvoice; FormatDecimals(TotalInvoice, 0.01)) { }
            column(AmountinvCurrencyFact; AmountinvCurrencyFact) { }
            column(VatAmountCurrencyFact; VatAmountCurrencyFact) { }
            column(DiscountAmountCurrencyFact; DiscountAmountCurrencyFact) { }
            column(DiscountAmountinvCurrencyFact; DiscountAmountinvCurrencyFact) { }
            column(TotalInvoiceCurrencyFact; TotalInvoiceCurrencyFact) { }
            column(TipoDeCambio; TipoDeCambio) { }
            column(DireccionTotal; DireccionTotal) { }
            column(Contador; contador) { }
            column(Moneda; Moneda) { }
            dataitem("Sales Invoice Line"; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = field("No.");
                column(ItemNo; "No.") { }
                column(Quantity; Quantity) { }
                column(Description; Description) { }
                column(UnitPrice; FormatDecimals("Unit Price", 0.0001)) { }
                column(Line_Discount__; "Line Discount %") { }
                column(LineAmount; FormatDecimals("Line Amount", 0.01)) { }
                trigger OnPreDataItem()
                begin
                    SetFilter("Type", '%1|%2', 1, 2);
                end;

                trigger OnAfterGetRecord()
                var
                    SalesLines: Record "Sales Invoice Line";
                    Customer: Record Customer;
                    SalesLineCurrencyFactor: Record "Sales Invoice Line";
                    CurrencyFactor: Decimal;
                begin
                    SalesLines.SetRange("Document No.", "Sales Invoice Line"."Document No.");
                    SalesLines.SetFilter("Type", 'Item|G/L Account');
                    Amountinv := 0;
                    VatAmount := 0;
                    DiscountAmount := 0;
                    DiscountAmountinv := 0;
                    TotalInvoice := 0;
                    contador := 0;
                    CurrencyFactor := 1;
                    if "Sales Invoice Header"."Currency Code" <> '' then begin
                        CurrencyFactor := "Sales Invoice Header"."Currency Factor";
                        SalesLineCurrencyFactor.SetRange("Document No.", "Sales Invoice Line"."Document No.");
                        if SalesLineCurrencyFactor.FindSet() then
                            repeat
                                TipoDeCambio := 1 / "Sales Invoice Header"."Currency Factor";
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
                    Customer.get("Sales Invoice Header"."Sell-to Customer No.");
                    // Payment_Terms_Code := Customer."Payment Method Code";
                    DireccionTotal := Customer."Address" + ' ' + Customer."Address 2" + ' ' + Customer."City" + ' ' + Customer."County" + ' ' + Customer."Post Code";
                    InvoiceNo := "Sales Invoice Header"."No.";
                    OrderNo := "Sales Invoice Header"."Order No.";

                    if "Sales Invoice Header"."Currency Code" = 'USD' then begin
                        Moneda := 'US$';
                    end;

                end;

            }
        }
    }
    local procedure FormatDecimals(DecimalField: Decimal; PrecisiOn: Decimal) DEC: Decimal
    var

    begin
        DEC := ROUND(DecimalField, PrecisiOn, '=');
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
        OrderNo: Code[20];
        Payment_Terms_Code: Code[10];
        UnitPrice: Text[20];
        contador: Integer;
        LineAmount: Text;
        Moneda: Text;
}