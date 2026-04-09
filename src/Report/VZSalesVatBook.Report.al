report 84105 JXVZSalesVatBook
{
    Caption = 'Sales vat book Venezuela', Comment = 'ESP=Libro IVA ventas Venezuela';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    DefaultLayout = RDLC;
    RDLCLayout = 'src/ReportLayout/VZSalesVatBook.rdl';

    dataset
    {
        dataitem(Header; Integer)
        {
            DataItemTableView = sorting(Number) order(ascending) where(Number = const(1));

            column(CompanyInfo_Number; Header.Number)
            {

            }
            column("CompanyInfo_City"; CompanyInfo.City)
            {//

            }
            column("CompanyInfo_VATRegistrationNo"; CompanyInfo."VAT Registration No.")
            {//

            }
            column("CompanyInfo_Name"; CompanyInfo.Name)
            {//

            }
            column("CompanyInfo_Address"; CompanyInfo.Address)
            {//

            }
            column(CompanyInfo_County; CompanyInfo.County)
            {//

            }
            column(CompanyInfo_PostCode; CompanyInfo."Post Code")
            {

            }
            column(FromDate; FromDate)
            {//

            }
            column(ToDate; ToDate)
            {//

            }

            column(OpenIIBB; '')
            { }

            trigger OnPreDataItem()

            begin
                CompanyInfo.reset();
                CompanyInfo.Get('');

                GenLedgerSetup.Reset();
                GenLedgerSetup.Get();
            end;
        }

        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            DataItemTableView = sorting("No.") order(ascending);

            trigger OnPreDataItem()
            begin
                "Sales Invoice Header".SetRange("Posting Date", FromDate, ToDate);
                "Sales Invoice Header".SetRange(JXVZInvoiceType, "Sales Invoice Header".JXVZInvoiceType::Invoice);
            end;

            trigger OnAfterGetRecord()
            var
                TaxJurisdictionTemp: Record "Tax Jurisdiction" temporary;
            begin
                OperNo += 1;

                "Sales Invoice Header".CalcFields("Amount Including VAT");
                JXVZSalesVatBook.Init();
                ReportKey += 1;
                JXVZSalesVatBook.JXVZKey := ReportKey;
                JXVZSalesVatBook.JXVZPostingdate := "Sales Invoice Header"."Posting Date";
                JXVZSalesVatBook.JXVZInvoiceNumber := "Sales Invoice Header"."No.";
                JXVZSalesVatBook.JXVZCompanyName := "Sales Invoice Header"."Bill-to Name";
                JXVZSalesVatBook.JXVZVATRegistrationNo := "Sales Invoice Header"."VAT Registration No.";
                JXVZSalesVatBook.JXVZTaxAreaCode := "Sales Invoice Header"."Tax Area Code";
                JXVZSalesVatBook.JXVZProvince := "Sales Invoice Header".JXVZProvinceCode;
                JXVZSalesVatBook.JXVZInvoiceType := Format("Sales Invoice Header".JXVZInvoiceType::Invoice);
                JXVZSalesVatBook.JXVZInvoiceAmount := Abs("Sales Invoice Header"."Amount Including VAT");
                JXVZSalesVatBook.JXVZCtrlDocumentNo := "Sales Invoice Header".JXVZCtrlDocumentNo;
                JXVZSalesVatBook.JXVZDocTypeLV := Format(JXVZDocTypeLVE::Reg);

                if ("Sales Invoice Header"."Currency Code" <> '') then
                    JXVZSalesVatBook.JXVZInvoiceAmountLCY := Abs("Sales Invoice Header"."Amount Including VAT") / "Sales Invoice Header"."Currency Factor"
                else
                    JXVZSalesVatBook.JXVZInvoiceAmountLCY := Abs("Sales Invoice Header"."Amount Including VAT");
                JXVZSalesVatBook.JXVZCurrency := "Sales Invoice Header"."Currency Code";

                SalesInvoiceLine.Reset();
                SalesInvoiceLine.SetRange(SalesInvoiceLine."Document No.", "Sales Invoice Header"."No.");
                if SalesInvoiceLine.FindSet() then
                    repeat
                        TaxGroup.Reset();
                        TaxGroup.SetRange(TaxGroup."Code", SalesInvoiceLine."Tax Group Code");
                        if TaxGroup.FindFirst() then
                            case TaxGroup.JXVZType of
                                TaxGroup.JXVZType::"No base":
                                    if ("Sales Invoice Header"."Currency Code" <> '') then
                                        JXVZSalesVatBook.JXVZNoBaseAmount += Abs(SalesInvoiceLine."Line Amount") / "Sales Invoice Header"."Currency Factor"
                                    else
                                        JXVZSalesVatBook.JXVZNoBaseAmount += Abs(SalesInvoiceLine."Line Amount");
                                TaxGroup.JXVZType::"Exempt base":
                                    if ("Sales Invoice Header"."Currency Code" <> '') then
                                        JXVZSalesVatBook.JXVZExemptBaseAmount += Abs(SalesInvoiceLine."Line Amount") / "Sales Invoice Header"."Currency Factor"
                                    else
                                        JXVZSalesVatBook.JXVZExemptBaseAmount += Abs(SalesInvoiceLine."Line Amount");
                            end;

                    until SalesInvoiceLine.Next() = 0;

                JXVZSalesVatBook.JXVZBaseAmount := 0;
                TaxJurisdictionTemp.DeleteAll();
                VatEntry.Reset();
                VatEntry.SetRange("Document Type", VatEntry."Document Type"::Invoice);
                VatEntry.SetRange("Document No.", "Sales Invoice Header"."No.");
                if VatEntry.FindSet() then
                    repeat
                        TaxJurisdictionTemp.Reset();
                        TaxJurisdictionTemp.SetRange(TaxJurisdictionTemp.Code, Format(VatEntry."Sales Tax Connection No."));
                        if not TaxJurisdictionTemp.FindFirst() then begin
                            JXVZSalesVatBook.JXVZBaseAmount += /*Abs*/(VatEntry.Base);

                            TaxJurisdictionTemp.Init();
                            TaxJurisdictionTemp.Code := Format(VatEntry."Sales Tax Connection No.");
                            TaxJurisdictionTemp.Insert(false);
                        end;

                        TaxJurisdiction.Reset();
                        TaxJurisdiction.SetRange(TaxJurisdiction."Code", VatEntry."Tax Jurisdiction Code");
                        if TaxJurisdiction.FindFirst() then
                            case TaxJurisdiction.JXVZTaxType of
                                TaxJurisdiction.JXVZTaxType::VAT:
                                    /*TaxJurisdiction.Reset();
                                    TaxJurisdiction.SetRange(TaxJurisdiction."Code", VatEntry."Tax Jurisdiction Code");
                                    if TaxJurisdiction.FindFirst() then*/
                                    case TaxJurisdiction.JXVZVAType of
                                        TaxJurisdiction.JXVZVAType::IVA16:
                                            JXVZSalesVatBook.JXVZVAT16 += /*Abs*/(VatEntry.Amount);

                                        TaxJurisdiction.JXVZVAType::IVA8:
                                            JXVZSalesVatBook.JXVZVAT8 += /*Abs*/(VatEntry.Amount);
                                    end;

                                TaxJurisdiction.JXVZTaxType::VATPerception:
                                    JXVZSalesVatBook.JXVZVATPercep += /*Abs*/(VatEntry.Amount);

                                TaxJurisdiction.JXVZTaxType::Withold:
                                    begin
                                        JXVZSalesVatBook.JXVZWithold += /*Abs*/(VatEntry.Amount);

                                        if TaxJurisdiction.JXVZVAType = TaxJurisdiction.JXVZVAType::ISLR then
                                            JXVZSalesVatBook.JXVZWitholdISLR += /*Abs*/(VatEntry.Amount);

                                        if TaxJurisdiction.JXVZVAType = TaxJurisdiction.JXVZVAType::Municipal then
                                            JXVZSalesVatBook.JXVZWitholdMunicipal += /*Abs*/(VatEntry.Amount);

                                    end;

                                TaxJurisdiction.JXVZTaxType::Others:
                                    JXVZSalesVatBook.JXVZSpecial += /*Abs*/(VatEntry.Amount);
                            end;
                    until VatEntry.Next() = 0;

                JXVZSalesVatBook.JXVZBaseAmount := abs(JXVZSalesVatBook.JXVZBaseAmount);
                JXVZSalesVatBook.JXVZVAT16 := abs(JXVZSalesVatBook.JXVZVAT16);
                JXVZSalesVatBook.JXVZVAT8 := abs(JXVZSalesVatBook.JXVZVAT8);
                JXVZSalesVatBook.JXVZVATPercep := abs(JXVZSalesVatBook.JXVZVATPercep);
                JXVZSalesVatBook.JXVZWithold := abs(JXVZSalesVatBook.JXVZWithold);
                JXVZSalesVatBook.JXVZWitholdISLR := abs(JXVZSalesVatBook.JXVZWitholdISLR);
                JXVZSalesVatBook.JXVZWitholdMunicipal := abs(JXVZSalesVatBook.JXVZWitholdMunicipal);
                JXVZSalesVatBook.JXVZSpecial := abs(JXVZSalesVatBook.JXVZSpecial);
                JXVZSalesVatBook.JXVZFiscalType := LTFiscalType.GetDescription(JXVZFiscalType);
                JXVZSalesVatBook.JXVZOperNo := OperNo;

                JXVZSalesVatBook.Insert();
            end;

        }
        dataitem("Sales Debit Memo Header"; "Sales Invoice Header")
        {
            DataItemTableView = sorting("No.") order(Ascending);
            ;

            trigger OnPreDataItem()
            begin
                "Sales Debit Memo Header".SetRange("Posting Date", FromDate, ToDate);
                "Sales Debit Memo Header".SetRange(JXVZInvoiceType, "Sales Debit Memo Header".JXVZInvoiceType::DebitMemo);
            end;

            trigger OnAfterGetRecord()
            var
                TaxJurisdictionTemp: Record "Tax Jurisdiction" temporary;
            begin
                OperNo += 1;

                "Sales Debit Memo Header".CalcFields("Amount Including VAT");
                JXVZSalesVatBook.Init();
                ReportKey += 1;
                JXVZSalesVatBook.JXVZKey := ReportKey;
                JXVZSalesVatBook.JXVZPostingdate := "Sales Debit Memo Header"."Posting Date";
                JXVZSalesVatBook.JXVZInvoiceNumber := "Sales Debit Memo Header"."No.";
                JXVZSalesVatBook.JXVZCompanyName := "Sales Debit Memo Header"."Bill-to Name";
                JXVZSalesVatBook.JXVZVATRegistrationNo := "Sales Debit Memo Header"."VAT Registration No.";
                JXVZSalesVatBook.JXVZTaxAreaCode := "Sales Debit Memo Header"."Tax Area Code";
                JXVZSalesVatBook.JXVZProvince := "Sales Debit Memo Header".JXVZProvinceCode;
                JXVZSalesVatBook.JXVZInvoiceType := Format("Sales Debit Memo Header".JXVZInvoiceType::DebitMemo);
                JXVZSalesVatBook.JXVZInvoiceAmount := Abs("Sales Debit Memo Header"."Amount Including VAT");
                JXVZSalesVatBook.JXVZCtrlDocumentNo := "Sales Debit Memo Header".JXVZCtrlDocumentNo;

                if ("Sales Debit Memo Header"."Applies-to Doc. Type" = "Sales Debit Memo Header"."Applies-to Doc. Type"::" ") and ("Sales Debit Memo Header"."Applies-to Doc. No." = '') then
                    JXVZSalesVatBook.JXVZDocTypeLV := Format(JXVZDocTypeLVE::Reg)
                else
                    JXVZSalesVatBook.JXVZDocTypeLV := Format(JXVZDocTypeLVE::Com);

                if ("Sales Debit Memo Header"."Currency Code" <> '') then
                    JXVZSalesVatBook.JXVZInvoiceAmountLCY := Abs("Sales Debit Memo Header"."Amount Including VAT") / "Sales Debit Memo Header"."Currency Factor"
                else
                    JXVZSalesVatBook.JXVZInvoiceAmountLCY := Abs("Sales Debit Memo Header"."Amount Including VAT");
                JXVZSalesVatBook.JXVZCurrency := "Sales Debit Memo Header"."Currency Code";

                SalesInvoiceLine.Reset();
                SalesInvoiceLine.SetRange(SalesInvoiceLine."Document No.", "Sales Debit Memo Header"."No.");
                if SalesInvoiceLine.FindSet() then
                    repeat
                        TaxGroup.Reset();
                        TaxGroup.SetRange(TaxGroup."Code", SalesInvoiceLine."Tax Group Code");
                        if TaxGroup.FindFirst() then
                            case TaxGroup.JXVZType of
                                TaxGroup.JXVZType::"No base":
                                    if ("Sales Debit Memo Header"."Currency Code" <> '') then
                                        JXVZSalesVatBook.JXVZNoBaseAmount += Abs(SalesInvoiceLine."Line Amount") / "Sales Debit Memo Header"."Currency Factor"
                                    else
                                        JXVZSalesVatBook.JXVZNoBaseAmount += Abs(SalesInvoiceLine."Line Amount");

                                TaxGroup.JXVZType::"Exempt base":
                                    if ("Sales Debit Memo Header"."Currency Code" <> '') then
                                        JXVZSalesVatBook.JXVZExemptBaseamount += Abs(SalesInvoiceLine."Line Amount") / "Sales Debit Memo Header"."Currency Factor"
                                    else
                                        JXVZSalesVatBook.JXVZExemptBaseamount += Abs(SalesInvoiceLine."Line Amount");
                            end;

                    until SalesInvoiceLine.Next() = 0;

                JXVZSalesVatBook.JXVZBaseAmount := 0;
                TaxJurisdictionTemp.deleteAll();
                VatEntry.Reset();
                VatEntry.SetRange("Document Type", VatEntry."Document Type"::Invoice);
                VatEntry.SetRange("Document No.", "Sales Debit Memo Header"."No.");
                if VatEntry.FindSet() then
                    repeat
                        TaxJurisdictionTemp.Reset();
                        TaxJurisdictionTemp.SetRange(TaxJurisdictionTemp.Code, Format(VatEntry."Sales Tax Connection No."));
                        if not TaxJurisdictionTemp.FindFirst() then begin
                            JXVZSalesVatBook.JXVZBaseAmount += Abs(VatEntry.Base);
                            TaxJurisdictionTemp.Init();
                            TaxJurisdictionTemp.Code := Format(VatEntry."Sales Tax Connection No.");
                            TaxJurisdictionTemp.Insert(false);
                        end;

                        TaxJurisdiction.Reset();
                        TaxJurisdiction.SetRange(TaxJurisdiction."Code", VatEntry."Tax Jurisdiction Code");
                        if TaxJurisdiction.FindFirst() then
                            case TaxJurisdiction.JXVZTaxType of
                                TaxJurisdiction.JXVZTaxType::VAT:
                                    /*TaxJurisdiction.Reset();
                                    TaxJurisdiction.SetRange(TaxJurisdiction."Code", VatEntry."Tax Jurisdiction Code");
                                    if TaxJurisdiction.FindFirst() then*/
                                    case TaxJurisdiction.JXVZVAType of
                                        TaxJurisdiction.JXVZVAType::IVA16:
                                            JXVZSalesVatBook.JXVZVAT16 += Abs(VatEntry.Amount);

                                        TaxJurisdiction.JXVZVAType::IVA8:
                                            JXVZSalesVatBook.JXVZVAT8 += Abs(VatEntry.Amount);
                                    end;

                                TaxJurisdiction.JXVZTaxType::VATPerception:
                                    JXVZSalesVatBook.JXVZVATPercep += Abs(VatEntry.Amount);

                                TaxJurisdiction.JXVZTaxType::Withold:
                                    begin
                                        JXVZSalesVatBook.JXVZWithold += Abs(VatEntry.Amount);

                                        if TaxJurisdiction.JXVZVAType = TaxJurisdiction.JXVZVAType::ISLR then
                                            JXVZSalesVatBook.JXVZWitholdISLR += Abs(VatEntry.Amount);

                                        if TaxJurisdiction.JXVZVAType = TaxJurisdiction.JXVZVAType::Municipal then
                                            JXVZSalesVatBook.JXVZWitholdMunicipal += Abs(VatEntry.Amount);
                                    end;

                                TaxJurisdiction.JXVZTaxType::Others:
                                    JXVZSalesVatBook.JXVZSpecial += Abs(VatEntry.Amount);
                            end;
                    until VatEntry.Next() = 0;

                JXVZSalesVatBook.JXVZFiscalType := LTFiscalType.GetDescription(JXVZFiscalType);
                JXVZSalesVatBook.JXVZOperNo := OperNo;
                JXVZSalesVatBook.Insert();
            end;
        }
        dataitem("Sales Cr.Memo Header"; "Sales Cr.Memo Header")
        {
            DataItemTableView = sorting("No.") order(Ascending);
            ;

            trigger OnPreDataItem()
            begin
                "Sales Cr.Memo Header".SetRange("Posting Date", FromDate, ToDate);
            end;

            trigger OnAfterGetRecord()
            var
                TaxJurisdictionTemp: Record "Tax Jurisdiction" temporary;
            begin
                OperNo += 1;

                "Sales Cr.Memo Header".CalcFields("Amount Including VAT");
                JXVZSalesVatBook.Init();
                ReportKey += 1;
                JXVZSalesVatBook.JXVZKey := ReportKey;
                JXVZSalesVatBook.JXVZPostingdate := "Sales Cr.Memo Header"."Posting Date";
                JXVZSalesVatBook.JXVZInvoiceNumber := "Sales Cr.Memo Header"."No.";
                JXVZSalesVatBook.JXVZCompanyName := "Sales Cr.Memo Header"."Bill-to Name";
                JXVZSalesVatBook.JXVZVATRegistrationNo := "Sales Cr.Memo Header"."VAT Registration No.";
                JXVZSalesVatBook.JXVZTaxAreaCode := "Sales Cr.Memo Header"."Tax Area Code";
                JXVZSalesVatBook.JXVZProvince := "Sales Cr.Memo Header".JXVZProvinceCode;
                JXVZSalesVatBook.JXVZInvoiceType := 'Nota de crédito';
                JXVZSalesVatBook.JXVZCtrlDocumentNo := "Sales Cr.Memo Header".JXVZCtrlDocumentNo;

                if ("Sales Cr.Memo Header"."Applies-to Doc. Type" = "Sales Cr.Memo Header"."Applies-to Doc. Type"::" ") and ("Sales Cr.Memo Header"."Applies-to Doc. No." = '') then
                    JXVZSalesVatBook.JXVZDocTypeLV := Format(JXVZDocTypeLVE::Reg)
                else
                    JXVZSalesVatBook.JXVZDocTypeLV := Format(JXVZDocTypeLVE::Com);

                JXVZSalesVatBook.JXVZInvoiceAmount := Abs("Sales Cr.Memo Header"."Amount Including VAT") * -1;

                if ("Sales Cr.Memo Header"."Currency Code" <> '') then
                    JXVZSalesVatBook.JXVZInvoiceAmountLCY := (Abs("Sales Cr.Memo Header"."Amount Including VAT") * -1) / "Sales Cr.Memo Header"."Currency Factor"
                else
                    JXVZSalesVatBook.JXVZInvoiceAmountLCY := Abs("Sales Cr.Memo Header"."Amount Including VAT") * -1;
                JXVZSalesVatBook.JXVZCurrency := "Sales Cr.Memo Header"."Currency Code";

                SalesCrMemoLine.Reset();
                SalesCrMemoLine.SetRange(SalesCrMemoLine."Document No.", "Sales Cr.Memo Header"."No.");
                if SalesCrMemoLine.FindSet() then
                    repeat
                        TaxGroup.Reset();
                        TaxGroup.SetRange(TaxGroup."Code", SalesCrMemoLine."Tax Group Code");
                        if TaxGroup.FindFirst() then
                            case TaxGroup.JXVZType of
                                TaxGroup.JXVZType::"No base":
                                    if ("Sales Cr.Memo Header"."Currency Code" <> '') then
                                        JXVZSalesVatBook.JXVZNoBaseAmount += (Abs(SalesCrMemoLine."Line Amount") * -1) / "Sales Cr.Memo Header"."Currency Factor"
                                    else
                                        JXVZSalesVatBook.JXVZNoBaseAmount += Abs(SalesCrMemoLine."Line Amount") * -1;

                                TaxGroup.JXVZType::"Exempt base":
                                    if ("Sales Cr.Memo Header"."Currency Code" <> '') then
                                        JXVZSalesVatBook.JXVZExemptBaseAmount += (Abs(SalesCrMemoLine."Line Amount") * -1) / "Sales Cr.Memo Header"."Currency Factor"
                                    else
                                        JXVZSalesVatBook.JXVZExemptBaseAmount += Abs(SalesCrMemoLine."Line Amount") * -1;
                            end;

                    until SalesCrMemoLine.Next() = 0;

                JXVZSalesVatBook.JXVZBaseAmount := 0;
                TaxJurisdictionTemp.DeleteAll();
                VatEntry.Reset();
                VatEntry.SetRange("Document Type", VatEntry."Document Type"::"Credit Memo");
                VatEntry.SetRange("Document No.", "Sales Cr.Memo Header"."No.");
                if VatEntry.FindSet() then
                    repeat
                        TaxJurisdictionTemp.Reset();
                        TaxJurisdictionTemp.SetRange(TaxJurisdictionTemp.Code, Format(VatEntry."Sales Tax Connection No."));
                        if not TaxJurisdictionTemp.FindFirst() then begin
                            JXVZSalesVatBook.JXVZBaseAmount += /*Abs*/(VatEntry.Base) /** -1*/;
                            TaxJurisdictionTemp.Init();
                            TaxJurisdictionTemp.Code := Format(VatEntry."Sales Tax Connection No.");
                            TaxJurisdictionTemp.Insert(false);
                        end;

                        TaxJurisdiction.Reset();
                        TaxJurisdiction.SetRange(TaxJurisdiction."Code", VatEntry."Tax Jurisdiction Code");
                        if TaxJurisdiction.FindFirst() then
                            case TaxJurisdiction.JXVZTaxType of
                                TaxJurisdiction.JXVZTaxType::VAT:
                                    /*TaxJurisdiction.Reset();
                                    TaxJurisdiction.SetRange(TaxJurisdiction."Code", VatEntry."Tax Jurisdiction Code");
                                    if TaxJurisdiction.FindFirst() then*/
                                    case TaxJurisdiction.JXVZVAType of
                                        TaxJurisdiction.JXVZVAType::IVA16:
                                            JXVZSalesVatBook.JXVZVAT16 += /*Abs*/(VatEntry.Amount) /** -1*/;

                                        TaxJurisdiction.JXVZVAType::IVA8:
                                            JXVZSalesVatBook.JXVZVAT8 += /*Abs*/(VatEntry.Amount) /** -1*/;
                                    end;

                                TaxJurisdiction.JXVZTaxType::VATPerception:
                                    JXVZSalesVatBook.JXVZVATPercep += /*Abs*/(VatEntry.Amount) /** -1*/;

                                TaxJurisdiction.JXVZTaxType::Withold:
                                    begin
                                        JXVZSalesVatBook.JXVZWithold += /*Abs*/(VatEntry.Amount) /** -1*/;

                                        if TaxJurisdiction.JXVZVAType = TaxJurisdiction.JXVZVAType::ISLR then
                                            JXVZSalesVatBook.JXVZWitholdISLR += /*Abs*/(VatEntry.Amount) /** -1*/;

                                        if TaxJurisdiction.JXVZVAType = TaxJurisdiction.JXVZVAType::Municipal then
                                            JXVZSalesVatBook.JXVZWitholdMunicipal += /*Abs*/(VatEntry.Amount) /** -1*/;
                                    end;

                                TaxJurisdiction.JXVZTaxType::Others:
                                    JXVZSalesVatBook.JXVZSpecial += /*Abs*/(VatEntry.Amount) /** -1*/;
                            end;
                    until VatEntry.Next() = 0;

                JXVZSalesVatBook.JXVZBaseAmount := abs(JXVZSalesVatBook.JXVZBaseAmount) * -1;
                JXVZSalesVatBook.JXVZVAT16 := abs(JXVZSalesVatBook.JXVZVAT16) * -1;
                JXVZSalesVatBook.JXVZVAT8 := abs(JXVZSalesVatBook.JXVZVAT8) * -1;
                JXVZSalesVatBook.JXVZVATPercep := abs(JXVZSalesVatBook.JXVZVATPercep) * -1;
                JXVZSalesVatBook.JXVZWithold := abs(JXVZSalesVatBook.JXVZWithold) * -1;
                JXVZSalesVatBook.JXVZWitholdISLR := abs(JXVZSalesVatBook.JXVZWitholdISLR) * -1;
                JXVZSalesVatBook.JXVZWitholdMunicipal := abs(JXVZSalesVatBook.JXVZWitholdMunicipal) * -1;
                JXVZSalesVatBook.JXVZSpecial := abs(JXVZSalesVatBook.JXVZSpecial) * -1;
                JXVZSalesVatBook.JXVZFiscalType := LTFiscalType.GetDescription(JXVZFiscalType);
                JXVZSalesVatBook.JXVZOperNo := OperNo;
                JXVZSalesVatBook.Insert();
            end;
        }

        dataitem(Temp; Integer)
        {
            DataItemTableView = sorting(Number) order(ascending);

            column(PostingDate; JXVZSalesVatBook.JXVZPostingdate)
            { }
            column(InvoiceNumber; JXVZSalesVatBook.JXVZInvoiceNumber)
            { }
            column(CompanyName; JXVZSalesVatBook.JXVZCompanyName)
            { }
            column(VATRegistrationNoo; JXVZSalesVatBook.JXVZVATRegistrationNo)
            { }
            column(Taxareacode; JXVZSalesVatBook.JXVZTaxAreaCode)
            { }
            column(Province; JXVZSalesVatBook.JXVZProvince)
            { }
            column(Invoicetype; JXVZSalesVatBook.JXVZInvoiceType)
            { }
            column(Invoiceamount; JXVZSalesVatBook.JXVZInvoiceAmount)
            { }
            column(BaseAmount; JXVZSalesVatBook.JXVZBaseAmount)
            { }
            column(NoBaseAmount; JXVZSalesVatBook.JXVZNoBaseAmount)
            { }
            column(ExemptBaseAmount; JXVZSalesVatBook.JXVZExemptBaseAmount)
            { }
            column(VAT105; JXVZSalesVatBook.JXVZVAT8)
            { }
            column(VAT21; JXVZSalesVatBook.JXVZVAT16)
            { }
            column(VATpercep; JXVZSalesVatBook.JXVZVATPercep)
            { }
            column(IIBB; JXVZSalesVatBook.JXVZWithold)
            { }
            column(Special; JXVZSalesVatBook.JXVZSpecial)
            { }
            column(FiscalType; JXVZSalesVatBook.JXVZFiscalType)
            { }
            column(CurrencyCode; JXVZSalesVatBook.JXVZCurrency)
            { }
            column(InvoiceAmountLCY; JXVZSalesVatBook.JXVZInvoiceAmountLCY)
            { }
            column(IIBBISLR; JXVZSalesVatBook.JXVZWitholdISLR)
            { }

            column(IIBBMunicipal; JXVZSalesVatBook.JXVZWitholdMunicipal)
            { }
            column(OperNo; JXVZSalesVatBook.JXVZOperNo)
            { }
            column(JXVZCtrlDocumentNo; JXVZSalesVatBook.JXVZCtrlDocumentNo)
            { }
            column(JXVZDocTypeLV; JXVZSalesVatBook.JXVZDocTypeLV)
            { }

            trigger OnPreDataItem()
            begin
                JXVZSalesVatBook.Reset();
                SetRange(Number, 1, JXVZSalesVatBook.Count());
            end;

            trigger OnAfterGetRecord()
            begin
                if (Number = 1) then
                    JXVZSalesVatBook.FindFirst()
                else
                    JXVZSalesVatBook.Next();
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Dates)
                {
                    Caption = 'Dates', Comment = 'ESP=Fechas';
                    field(FromDate; FromDate)
                    {
                        ApplicationArea = All;
                        Caption = 'From', Comment = 'ESP=Desde';
                        ToolTip = 'From', Comment = 'ESP=Desde';

                    }

                    field(ToDate; ToDate)
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
            area(processing)
            {
            }
        }
    }

    procedure SetDates(_FromDate: Date; _ToDate: Date)
    begin
        FromDate := _FromDate;
        ToDate := _ToDate;
    end;

    var
        CompanyInfo: Record "Company Information";
        JXVZSalesVatBook: Record JXVZVatBookTmp temporary;
        VatEntry: Record "VAT Entry";
        TaxJurisdiction: Record "Tax Jurisdiction";
        SalesInvoiceLine: Record "Sales Invoice Line";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        TaxGroup: Record "Tax Group";
        LTFiscalType: Record JXVZFiscalType;
        GenLedgerSetup: Record "General Ledger Setup";
        FromDate: Date;
        ToDate: Date;
        ReportKey: Integer;
        OperNo: Integer;
}