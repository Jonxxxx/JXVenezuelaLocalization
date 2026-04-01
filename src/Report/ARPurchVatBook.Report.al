report 84106 JXVZPurchVatBook
{
    Caption = 'Purch VAT book', Comment = 'ESP=Libro IVA compras';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    DefaultLayout = RDLC;
    RDLCLayout = 'ReportLayout/ARPurchVatBook.rdl';

    dataset
    {
        dataitem(Header; Integer)
        {
            DataItemTableView = sorting(Number) order(ascending) where(Number = const(1));

            column(CompanyInfo_Number; Header.Number)
            {

            }
            column("CompanyInfo_City"; CompanyInfo.City)
            {

            }
            column("CompanyInfo_VATRegistrationNo"; CompanyInfo."VAT Registration No.")
            {

            }
            column("CompanyInfo_Name"; CompanyInfo.Name)
            {

            }
            column("CompanyInfo_Address"; CompanyInfo.Address)
            {

            }
            column(CompanyInfo_County; CompanyInfo.County)
            {

            }
            column(CompanyInfo_PostCode; CompanyInfo."Post Code")
            {

            }
            column(FromDate; FromDate)
            {

            }
            column(ToDate; ToDate)
            {

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

        dataitem("Purch. Inv. Header"; "Purch. Inv. Header")
        {
            DataItemTableView = sorting("No.") order(ascending);
            ;

            trigger OnPreDataItem()
            begin
                "Purch. Inv. Header".SetRange("Posting Date", FromDate, ToDate);
                "Purch. Inv. Header".SetRange(JXInvoiceType, "Purch. Inv. Header".JXInvoiceType::Invoice);
            end;

            trigger OnAfterGetRecord()
            var
                TaxJurisdictionTemp: Record "Tax Jurisdiction" temporary;
                GLAccount: Record "G/L Account";
            begin
                "Purch. Inv. Header".CalcFields("Amount Including VAT");
                JXVZPurchVatBook.Init();
                ReportKey += 1;
                JXVZPurchVatBook.JXVZKey := ReportKey;
                JXVZPurchVatBook.JXVZPostingDate := "Purch. Inv. Header"."Posting Date";
                JXVZPurchVatBook.JXVZDocumentDate := "Purch. Inv. Header"."Document Date";
                JXVZPurchVatBook.JXVZInvoiceNumber := "Purch. Inv. Header"."Vendor Invoice No.";
                JXVZPurchVatBook.JXVZCompanyName := "Purch. Inv. Header"."Pay-to Name";
                JXVZPurchVatBook.JXVZVATRegistrationNo := "Purch. Inv. Header"."VAT Registration No.";
                JXVZPurchVatBook.JXVZTaxAreaCode := "Purch. Inv. Header"."Tax Area Code";
                JXVZPurchVatBook.JXVZProvince := "Purch. Inv. Header".JXVZProvince;
                JXVZPurchVatBook.JXVZInvoiceType := Format("Purch. Inv. Header".JXInvoiceType::Invoice);
                JXVZPurchVatBook.JXVZInvoiceAmount := Abs("Purch. Inv. Header"."Amount Including VAT");

                if ("Purch. Inv. Header"."Currency Code" <> '') then
                    JXVZPurchVatBook.JXVZInvoiceAmountLCY := Abs("Purch. Inv. Header"."Amount Including VAT") / "Purch. Inv. Header"."Currency Factor"
                else
                    JXVZPurchVatBook.JXVZInvoiceAmountLCY := Abs("Purch. Inv. Header"."Amount Including VAT");
                JXVZPurchVatBook.JXVZCurrency := "Purch. Inv. Header"."Currency Code";

                PurchInvLine.Reset();
                PurchInvLine.SetRange(PurchInvLine."Document No.", "Purch. Inv. Header"."No.");
                if PurchInvLine.FindSet() then
                    repeat
                        TaxGroup.Reset();
                        TaxGroup.SetRange(TaxGroup."Code", PurchInvLine."Tax Group Code");
                        if TaxGroup.FindFirst() then
                            case TaxGroup.JXVZType of
                                TaxGroup.JXVZType::"No base":
                                    if "Purch. Inv. Header"."Currency Code" <> '' then
                                        JXVZPurchVatBook.JXVZNoBaseAmount += Abs(PurchInvLine."Line Amount") / "Purch. Inv. Header"."Currency Factor"
                                    else
                                        JXVZPurchVatBook.JXVZNoBaseAmount += Abs(PurchInvLine."Line Amount");
                                TaxGroup.JXVZType::"Exempt base":
                                    if "Purch. Inv. Header"."Currency Code" <> '' then
                                        JXVZPurchVatBook.JXVZExemptBaseAmount += Abs(PurchInvLine."Line Amount") / "Purch. Inv. Header"."Currency Factor"
                                    else
                                        JXVZPurchVatBook.JXVZExemptBaseAmount += Abs(PurchInvLine."Line Amount");
                                else
                                    if PurchInvLine.Type = PurchInvLine.Type::"G/L Account" then begin
                                        GLAccount.reset();
                                        GLAccount.SetRange("No.", PurchInvLine."No.");
                                        if GLAccount.FindFirst() then begin
                                            if GLAccount.JXVZPercepLineGAN then
                                                if "Purch. Inv. Header"."Currency Code" <> '' then
                                                    JXVZPurchVatBook.JXVZSpecial += Abs(PurchInvLine."Line Amount") / "Purch. Inv. Header"."Currency Factor"
                                                else
                                                    JXVZPurchVatBook.JXVZSpecial += Abs(PurchInvLine."Line Amount");

                                            if GLAccount.JXVZPercepLineIIBB then
                                                if "Purch. Inv. Header"."Currency Code" <> '' then begin
                                                    JXVZPurchVatBook.JXVZIIBB += Abs(PurchInvLine."Line Amount") / "Purch. Inv. Header"."Currency Factor";
                                                    JXVZPurchVatBook.JXVZIIBBArba += Abs(PurchInvLine."Line Amount") / "Purch. Inv. Header"."Currency Factor";
                                                end else begin
                                                    JXVZPurchVatBook.JXVZIIBB += Abs(PurchInvLine."Line Amount");
                                                    JXVZPurchVatBook.JXVZIIBBArba += Abs(PurchInvLine."Line Amount");
                                                end;

                                            if GLAccount.JXVZPercepLineIIBBCaba then
                                                if "Purch. Inv. Header"."Currency Code" <> '' then begin
                                                    JXVZPurchVatBook.JXVZIIBB += Abs(PurchInvLine."Line Amount") / "Purch. Inv. Header"."Currency Factor";
                                                    JXVZPurchVatBook.JXVZIIBBCaba += Abs(PurchInvLine."Line Amount") / "Purch. Inv. Header"."Currency Factor";
                                                end else begin
                                                    JXVZPurchVatBook.JXVZIIBB += Abs(PurchInvLine."Line Amount");
                                                    JXVZPurchVatBook.JXVZIIBBCaba += Abs(PurchInvLine."Line Amount");
                                                end;

                                            if GLAccount.JXVZPercepLineIIBBOthers then
                                                if "Purch. Inv. Header"."Currency Code" <> '' then
                                                    JXVZPurchVatBook.JXVZIIBB += Abs(PurchInvLine."Line Amount") / "Purch. Inv. Header"."Currency Factor"
                                                else
                                                    JXVZPurchVatBook.JXVZIIBB += Abs(PurchInvLine."Line Amount");

                                            if GLAccount.JXVZPercepLineVAT then
                                                if "Purch. Inv. Header"."Currency Code" <> '' then
                                                    JXVZPurchVatBook.JXVZVATPercep := Abs(PurchInvLine."Line Amount") / "Purch. Inv. Header"."Currency Factor"
                                                else
                                                    JXVZPurchVatBook.JXVZVATPercep += Abs(PurchInvLine."Line Amount");
                                        end;
                                    end;
                            end;
                    until PurchInvLine.Next() = 0;

                TaxJurisdictionTemp.DeleteAll();
                VatEntry.Reset();
                VatEntry.SetRange("Document Type", VatEntry."Document Type"::Invoice);
                VatEntry.SetRange("Document No.", "Purch. Inv. Header"."No.");
                if VatEntry.FindSet() then
                    repeat
                        TaxJurisdictionTemp.Reset();
                        TaxJurisdictionTemp.SetRange(TaxJurisdictionTemp.Code, Format(VatEntry."Sales Tax Connection No."));
                        if not TaxJurisdictionTemp.FindFirst() then begin
                            JXVZPurchVatBook.JXVZBaseAmount += Abs(VatEntry.Base);

                            TaxJurisdictionTemp.Init();
                            TaxJurisdictionTemp.Code := Format(VatEntry."Sales Tax Connection No.");
                            TaxJurisdictionTemp.Insert(false);
                        end;

                        TaxJurisdiction.Reset();
                        TaxJurisdiction.SetRange(TaxJurisdiction."Code", VatEntry."Tax Jurisdiction Code");
                        if TaxJurisdiction.FindFirst() then
                            case TaxJurisdiction.JXTaxType of
                                TaxJurisdiction.JXTaxType::VAT:
                                    case TaxJurisdiction.JXVAType of
                                        TaxJurisdiction.JXVAType::IVA21:
                                            JXVZPurchVatBook.JXVZVAT21 += Abs(VatEntry.Amount);

                                        TaxJurisdiction.JXVAType::IVA27:
                                            JXVZPurchVatBook.JXVZVAT27 += Abs(VatEntry.Amount);

                                        TaxJurisdiction.JXVAType::IVA105:
                                            JXVZPurchVatBook.JXVZVAT105 += Abs(VatEntry.Amount);
                                    end;

                                TaxJurisdiction.JXTaxType::VATPerception:
                                    JXVZPurchVatBook.JXVZVATPercep += Abs(VatEntry.Amount);

                                TaxJurisdiction.JXTaxType::GrossIncome:
                                    begin
                                        JXVZPurchVatBook.JXVZIIBB += Abs(VatEntry.Amount);

                                        if TaxJurisdiction.JXVAType = TaxJurisdiction.JXVAType::ARBA then
                                            JXVZPurchVatBook.JXVZIIBBArba += Abs(VatEntry.Amount);

                                        if TaxJurisdiction.JXVAType = TaxJurisdiction.JXVAType::CABA then
                                            JXVZPurchVatBook.JXVZIIBBCaba += Abs(VatEntry.Amount);

                                    end;
                                TaxJurisdiction.JXTaxType::Others:
                                    JXVZPurchVatBook.JXVZSpecial += Abs(VatEntry.Amount);
                            end;
                    until VatEntry.Next() = 0;

                JXVZPurchVatBook.JXVZFiscalType := LTFiscalType.GetDescription(JXVZFiscalType);

                //Check dif amount
                JXVZPaymentSetup.Get();
                if JXVZPaymentSetup.JXVZCheckAmountVAT then begin
                    CheckAmount := (JXVZPurchVatBook.JXVZBaseAmount + JXVZPurchVatBook.JXVZNoBaseAmount + JXVZPurchVatBook.JXVZExemptBaseAmount + JXVZPurchVatBook.JXVZVAT105 + JXVZPurchVatBook.JXVZVAT21 + JXVZPurchVatBook.JXVZVAT27 + JXVZPurchVatBook.JXVZVATPercep + JXVZPurchVatBook.JXVZIIBB + JXVZPurchVatBook.JXVZSpecial);
                    if ((JXVZPurchVatBook.JXVZInvoiceAmountLCY - CheckAmount) <> 0) then
                        JXVZPurchVatBook.JXVZBaseAmount += (JXVZPurchVatBook.JXVZInvoiceAmountLCY - CheckAmount);
                end;
                //Check dif amount END

                JXVZPurchVatBook.Insert();
            end;

        }
        dataitem("Purch. Debit Memo Header";
        "Purch. Inv. Header")
        {
            DataItemTableView = sorting("No.") order(Ascending);
            ;

            trigger OnPreDataItem()
            begin
                "Purch. Debit Memo Header".SetRange("Posting Date", FromDate, ToDate);
                "Purch. Debit Memo Header".SetRange(JXInvoiceType, "Purch. Debit Memo Header".JXInvoiceType::DebitMemo);
            end;

            trigger OnAfterGetRecord()
            var
                TaxJurisdictionTemp: Record "Tax Jurisdiction" temporary;
                GLAccount: Record "G/L Account";
            begin
                "Purch. Debit Memo Header".CalcFields("Amount Including VAT");
                JXVZPurchVatBook.Init();
                ReportKey += 1;
                JXVZPurchVatBook.JXVZKey := ReportKey;
                JXVZPurchVatBook.JXVZPostingDate := "Purch. Debit Memo Header"."Posting Date";
                JXVZPurchVatBook.JXVZDocumentDate := "Purch. Debit Memo Header"."Document Date";
                JXVZPurchVatBook.JXVZInvoiceNumber := "Purch. Debit Memo Header"."Vendor Invoice No.";
                JXVZPurchVatBook.JXVZCompanyName := "Purch. Debit Memo Header"."Pay-to Name";
                JXVZPurchVatBook.JXVZVATRegistrationNo := "Purch. Debit Memo Header"."VAT Registration No.";
                JXVZPurchVatBook.JXVZTaxAreaCode := "Purch. Debit Memo Header"."Tax Area Code";
                JXVZPurchVatBook.JXVZProvince := "Purch. Debit Memo Header".JXVZProvince;
                JXVZPurchVatBook.JXVZInvoiceType := Format("Purch. Debit Memo Header".JXInvoiceType::DebitMemo);
                JXVZPurchVatBook.JXVZInvoiceAmount := Abs("Purch. Debit Memo Header"."Amount Including VAT");

                if ("Purch. Debit Memo Header"."Currency Code" <> '') then
                    JXVZPurchVatBook.JXVZInvoiceAmountLCY := Abs("Purch. Debit Memo Header"."Amount Including VAT") / "Purch. Debit Memo Header"."Currency Factor"
                else
                    JXVZPurchVatBook.JXVZInvoiceAmountLCY := Abs("Purch. Debit Memo Header"."Amount Including VAT");
                JXVZPurchVatBook.JXVZCurrency := "Purch. Debit Memo Header"."Currency Code";

                PurchInvLine.Reset();
                PurchInvLine.SetRange(PurchInvLine."Document No.", "Purch. Debit Memo Header"."No.");
                if PurchInvLine.FindSet() then
                    repeat
                        TaxGroup.Reset();
                        TaxGroup.SetRange(TaxGroup."Code", PurchInvLine."Tax Group Code");
                        if TaxGroup.FindFirst() then
                            case TaxGroup.JXVZType of
                                TaxGroup.JXVZType::"No base":
                                    if "Purch. Debit Memo Header"."Currency Code" <> '' then
                                        JXVZPurchVatBook.JXVZNoBaseAmount += Abs(PurchInvLine."Line Amount") / "Purch. Debit Memo Header"."Currency Factor"
                                    else
                                        JXVZPurchVatBook.JXVZNoBaseAmount += Abs(PurchInvLine."Line Amount");
                                TaxGroup.JXVZType::"Exempt base":
                                    if "Purch. Debit Memo Header"."Currency Code" <> '' then
                                        JXVZPurchVatBook.JXVZExemptBaseAmount += Abs(PurchInvLine."Line Amount") / "Purch. Debit Memo Header"."Currency Factor"
                                    else
                                        JXVZPurchVatBook.JXVZExemptBaseAmount += Abs(PurchInvLine."Line Amount");
                                else
                                    if PurchInvLine.Type = PurchInvLine.Type::"G/L Account" then begin
                                        GLAccount.reset();
                                        GLAccount.SetRange("No.", PurchInvLine."No.");
                                        if GLAccount.FindFirst() then begin
                                            if GLAccount.JXVZPercepLineGAN then
                                                if "Purch. Debit Memo Header"."Currency Code" <> '' then
                                                    JXVZPurchVatBook.JXVZSpecial += Abs(PurchInvLine."Line Amount") / "Purch. Debit Memo Header"."Currency Factor"
                                                else
                                                    JXVZPurchVatBook.JXVZSpecial += Abs(PurchInvLine."Line Amount");

                                            if GLAccount.JXVZPercepLineIIBB then
                                                if "Purch. Debit Memo Header"."Currency Code" <> '' then begin
                                                    JXVZPurchVatBook.JXVZIIBB += JXVZPurchVatBook.JXVZIIBB / "Purch. Debit Memo Header"."Currency Factor";
                                                    JXVZPurchVatBook.JXVZIIBBArba += JXVZPurchVatBook.JXVZIIBBArba / "Purch. Debit Memo Header"."Currency Factor";
                                                end else begin
                                                    JXVZPurchVatBook.JXVZIIBB += Abs(PurchInvLine."Line Amount");
                                                    JXVZPurchVatBook.JXVZIIBBArba += Abs(PurchInvLine."Line Amount");
                                                end;

                                            if GLAccount.JXVZPercepLineIIBBCaba then
                                                if "Purch. Debit Memo Header"."Currency Code" <> '' then begin
                                                    JXVZPurchVatBook.JXVZIIBB += Abs(PurchInvLine."Line Amount") / "Purch. Debit Memo Header"."Currency Factor";
                                                    JXVZPurchVatBook.JXVZIIBBCaba += Abs(PurchInvLine."Line Amount") / "Purch. Debit Memo Header"."Currency Factor";
                                                end else begin
                                                    JXVZPurchVatBook.JXVZIIBB += Abs(PurchInvLine."Line Amount");
                                                    JXVZPurchVatBook.JXVZIIBBCaba += Abs(PurchInvLine."Line Amount");
                                                end;

                                            if GLAccount.JXVZPercepLineIIBBOthers then
                                                if "Purch. Debit Memo Header"."Currency Code" <> '' then
                                                    JXVZPurchVatBook.JXVZIIBB += Abs(PurchInvLine."Line Amount") / "Purch. Debit Memo Header"."Currency Factor"
                                                else
                                                    JXVZPurchVatBook.JXVZIIBB += Abs(PurchInvLine."Line Amount");

                                            if GLAccount.JXVZPercepLineVAT then
                                                if "Purch. Debit Memo Header"."Currency Code" <> '' then
                                                    JXVZPurchVatBook.JXVZVATPercep += Abs(PurchInvLine."Line Amount") / "Purch. Debit Memo Header"."Currency Factor"
                                                else
                                                    JXVZPurchVatBook.JXVZVATPercep += Abs(PurchInvLine."Line Amount");
                                        end;
                                    end;
                            end;
                    until PurchInvLine.Next() = 0;

                TaxJurisdictionTemp.DeleteAll();
                VatEntry.Reset();
                VatEntry.SetRange("Document Type", VatEntry."Document Type"::Invoice);
                VatEntry.SetRange("Document No.", "Purch. Debit Memo Header"."No.");
                if VatEntry.FindSet() then
                    repeat
                        TaxJurisdictionTemp.Reset();
                        TaxJurisdictionTemp.SetRange(TaxJurisdictionTemp.Code, Format(VatEntry."Sales Tax Connection No."));
                        if not TaxJurisdictionTemp.FindFirst() then begin
                            JXVZPurchVatBook.JXVZBaseAmount += Abs(VatEntry.Base);

                            TaxJurisdictionTemp.Init();
                            TaxJurisdictionTemp.Code := Format(VatEntry."Sales Tax Connection No.");
                            TaxJurisdictionTemp.Insert(false);
                        end;

                        TaxJurisdiction.Reset();
                        TaxJurisdiction.SetRange(TaxJurisdiction."Code", VatEntry."Tax Jurisdiction Code");
                        if TaxJurisdiction.FindFirst() then
                            case TaxJurisdiction.JXTaxType of
                                TaxJurisdiction.JXTaxType::VAT:
                                    case TaxJurisdiction.JXVAType of
                                        TaxJurisdiction.JXVAType::IVA21:
                                            JXVZPurchVatBook.JXVZVAT21 += Abs(VatEntry.Amount);

                                        TaxJurisdiction.JXVAType::IVA27:
                                            JXVZPurchVatBook.JXVZVAT27 += Abs(VatEntry.Amount);

                                        TaxJurisdiction.JXVAType::IVA105:
                                            JXVZPurchVatBook.JXVZVAT105 += Abs(VatEntry.Amount);
                                    end;

                                TaxJurisdiction.JXTaxType::VATPerception:
                                    JXVZPurchVatBook.JXVZVATPercep += Abs(VatEntry.Amount);

                                TaxJurisdiction.JXTaxType::GrossIncome:
                                    begin
                                        JXVZPurchVatBook.JXVZIIBB += Abs(VatEntry.Amount);

                                        if TaxJurisdiction.JXVAType = TaxJurisdiction.JXVAType::ARBA then
                                            JXVZPurchVatBook.JXVZIIBBArba += Abs(VatEntry.Amount);

                                        if TaxJurisdiction.JXVAType = TaxJurisdiction.JXVAType::CABA then
                                            JXVZPurchVatBook.JXVZIIBBCaba += Abs(VatEntry.Amount);
                                    end;
                                TaxJurisdiction.JXTaxType::Others:
                                    JXVZPurchVatBook.JXVZSpecial += Abs(VatEntry.Amount);
                            end;
                    until VatEntry.Next() = 0;

                JXVZPurchVatBook.JXVZFiscalType := LTFiscalType.GetDescription(JXVZFiscalType);

                //Check dif amount
                JXVZPaymentSetup.Get();
                if JXVZPaymentSetup.JXVZCheckAmountVAT then begin
                    CheckAmount := (JXVZPurchVatBook.JXVZBaseAmount + JXVZPurchVatBook.JXVZNoBaseAmount + JXVZPurchVatBook.JXVZExemptBaseAmount + JXVZPurchVatBook.JXVZVAT105 + JXVZPurchVatBook.JXVZVAT21 + JXVZPurchVatBook.JXVZVAT27 + JXVZPurchVatBook.JXVZVATPercep + JXVZPurchVatBook.JXVZIIBB + JXVZPurchVatBook.JXVZSpecial);
                    if ((JXVZPurchVatBook.JXVZInvoiceAmountLCY - CheckAmount) <> 0) then
                        JXVZPurchVatBook.JXVZBaseAmount += (JXVZPurchVatBook.JXVZInvoiceAmountLCY - CheckAmount);
                end;
                //Check dif amount END

                JXVZPurchVatBook.Insert();
            end;
        }
        dataitem("Purch. Cr. Memo Hdr."; "Purch. Cr. Memo Hdr.")
        {
            DataItemTableView = sorting("No.") order(Ascending);
            ;

            trigger OnPreDataItem()
            begin
                "Purch. Cr. Memo Hdr.".SetRange("Posting Date", FromDate, ToDate);
            end;

            trigger OnAfterGetRecord()
            var
                TaxJurisdictionTemp: Record "Tax Jurisdiction" temporary;
                GLAccount: Record "G/L Account";
            begin
                "Purch. Cr. Memo Hdr.".CalcFields("Amount Including VAT");
                JXVZPurchVatBook.Init();
                ReportKey += 1;
                JXVZPurchVatBook.JXVZKey := ReportKey;
                JXVZPurchVatBook.JXVZPostingDate := "Purch. Cr. Memo Hdr."."Posting Date";
                JXVZPurchVatBook.JXVZDocumentDate := "Purch. Cr. Memo Hdr."."Document Date";
                JXVZPurchVatBook.JXVZInvoiceNumber := "Purch. Cr. Memo Hdr."."Vendor Cr. Memo No.";
                JXVZPurchVatBook.JXVZCompanyName := "Purch. Cr. Memo Hdr."."Pay-to Name";
                JXVZPurchVatBook.JXVZVATRegistrationNo := "Purch. Cr. Memo Hdr."."VAT Registration No.";
                JXVZPurchVatBook.JXVZTaxAreaCode := "Purch. Cr. Memo Hdr."."Tax Area Code";
                JXVZPurchVatBook.JXVZProvince := "Purch. Cr. Memo Hdr.".JXVZProvince;
                JXVZPurchVatBook.JXVZInvoiceType := 'Nota de crédito';
                JXVZPurchVatBook.JXVZInvoiceAmount := Abs("Purch. Cr. Memo Hdr."."Amount Including VAT") * -1;

                if ("Purch. Cr. Memo Hdr."."Currency Code" <> '') then
                    JXVZPurchVatBook.JXVZInvoiceAmountLCY := (Abs("Purch. Cr. Memo Hdr."."Amount Including VAT") * -1) / "Purch. Cr. Memo Hdr."."Currency Factor"
                else
                    JXVZPurchVatBook.JXVZInvoiceAmountLCY := Abs("Purch. Cr. Memo Hdr."."Amount Including VAT") * -1;
                JXVZPurchVatBook.JXVZCurrency := "Purch. Cr. Memo Hdr."."Currency Code";

                PurchCrMemoLine.Reset();
                PurchCrMemoLine.SetRange(PurchCrMemoLine."Document No.", "Purch. Cr. Memo Hdr."."No.");
                if PurchCrMemoLine.FindSet() then
                    repeat
                        TaxGroup.Reset();
                        TaxGroup.SetRange(TaxGroup."Code", PurchCrMemoLine."Tax Group Code");
                        if TaxGroup.FindFirst() then
                            case TaxGroup.JXVZType of
                                TaxGroup.JXVZType::"No base":
                                    if "Purch. Cr. Memo Hdr."."Currency Code" <> '' then
                                        JXVZPurchVatBook.JXVZNoBaseAmount := (Abs(PurchCrMemoLine."Line Amount") * -1) / "Purch. Cr. Memo Hdr."."Currency Factor"
                                    else
                                        JXVZPurchVatBook.JXVZNoBaseAmount += Abs(PurchCrMemoLine."Line Amount") * -1;
                                TaxGroup.JXVZType::"Exempt base":
                                    if "Purch. Cr. Memo Hdr."."Currency Code" <> '' then
                                        JXVZPurchVatBook.JXVZExemptBaseAmount := (Abs(PurchCrMemoLine."Line Amount") * -1) / "Purch. Cr. Memo Hdr."."Currency Factor"
                                    else
                                        JXVZPurchVatBook.JXVZExemptBaseAmount += Abs(PurchCrMemoLine."Line Amount") * -1;
                                else
                                    if PurchCrMemoLine.Type = PurchCrMemoLine.Type::"G/L Account" then begin
                                        GLAccount.reset();
                                        GLAccount.SetRange("No.", PurchCrMemoLine."No.");
                                        if GLAccount.FindFirst() then begin
                                            if GLAccount.JXVZPercepLineGAN then
                                                if "Purch. Cr. Memo Hdr."."Currency Code" <> '' then
                                                    JXVZPurchVatBook.JXVZSpecial := (Abs(PurchCrMemoLine."Line Amount") * -1) / "Purch. Cr. Memo Hdr."."Currency Factor"
                                                else
                                                    JXVZPurchVatBook.JXVZSpecial += Abs(PurchCrMemoLine."Line Amount") * -1;

                                            if GLAccount.JXVZPercepLineIIBB then
                                                if "Purch. Cr. Memo Hdr."."Currency Code" <> '' then begin
                                                    JXVZPurchVatBook.JXVZIIBB := (Abs(PurchCrMemoLine."Line Amount") * -1) / "Purch. Cr. Memo Hdr."."Currency Factor";
                                                    JXVZPurchVatBook.JXVZIIBBArba := (Abs(PurchCrMemoLine."Line Amount") * -1) / "Purch. Cr. Memo Hdr."."Currency Factor";
                                                end else begin
                                                    JXVZPurchVatBook.JXVZIIBB += Abs(PurchCrMemoLine."Line Amount") * -1;
                                                    JXVZPurchVatBook.JXVZIIBBArba += Abs(PurchCrMemoLine."Line Amount") * -1;
                                                end;

                                            if GLAccount.JXVZPercepLineIIBBCaba then
                                                if "Purch. Cr. Memo Hdr."."Currency Code" <> '' then begin
                                                    JXVZPurchVatBook.JXVZIIBB := (Abs(PurchCrMemoLine."Line Amount") * -1) / "Purch. Cr. Memo Hdr."."Currency Factor";
                                                    JXVZPurchVatBook.JXVZIIBBCaba := (Abs(PurchCrMemoLine."Line Amount") * -1) / "Purch. Cr. Memo Hdr."."Currency Factor";
                                                end else begin
                                                    JXVZPurchVatBook.JXVZIIBB += Abs(PurchCrMemoLine."Line Amount") * -1;
                                                    JXVZPurchVatBook.JXVZIIBBCaba += Abs(PurchCrMemoLine."Line Amount") * -1;
                                                end;

                                            if GLAccount.JXVZPercepLineIIBBOthers then
                                                if "Purch. Cr. Memo Hdr."."Currency Code" <> '' then
                                                    JXVZPurchVatBook.JXVZIIBB += (Abs(PurchCrMemoLine."Line Amount") * -1) / "Purch. Cr. Memo Hdr."."Currency Factor"
                                                else
                                                    JXVZPurchVatBook.JXVZIIBB += Abs(PurchCrMemoLine."Line Amount") * -1;

                                            if GLAccount.JXVZPercepLineVAT then
                                                if "Purch. Cr. Memo Hdr."."Currency Code" <> '' then
                                                    JXVZPurchVatBook.JXVZVATPercep := (Abs(PurchCrMemoLine."Line Amount") * -1) / "Purch. Cr. Memo Hdr."."Currency Factor"
                                                else
                                                    JXVZPurchVatBook.JXVZVATPercep += Abs(PurchCrMemoLine."Line Amount") * -1;
                                        end;
                                    end;
                            end;

                    until PurchCrMemoLine.Next() = 0;

                TaxJurisdictionTemp.deleteAll();
                VatEntry.Reset();
                VatEntry.SetRange("Document Type", VatEntry."Document Type"::"Credit Memo");
                VatEntry.SetRange("Document No.", "Purch. Cr. Memo Hdr."."No.");
                if VatEntry.FindSet() then
                    repeat
                        TaxJurisdictionTemp.Reset();
                        TaxJurisdictionTemp.SetRange(TaxJurisdictionTemp.Code, Format(VatEntry."Sales Tax Connection No."));
                        if not TaxJurisdictionTemp.FindFirst() then begin
                            JXVZPurchVatBook.JXVZBaseAmount += Abs(VatEntry.Base) * -1;
                            TaxJurisdictionTemp.Init();
                            TaxJurisdictionTemp.Code := Format(VatEntry."Sales Tax Connection No.");
                            TaxJurisdictionTemp.Insert(false);
                        end;

                        TaxJurisdiction.Reset();
                        TaxJurisdiction.SetRange(TaxJurisdiction."Code", VatEntry."Tax Jurisdiction Code");
                        if TaxJurisdiction.FindFirst() then
                            case TaxJurisdiction.JXTaxType of
                                TaxJurisdiction.JXTaxType::VAT:
                                    case TaxJurisdiction.JXVAType of
                                        TaxJurisdiction.JXVAType::IVA21:
                                            JXVZPurchVatBook.JXVZVAT21 += Abs(VatEntry.Amount) * -1;

                                        TaxJurisdiction.JXVAType::IVA27:
                                            JXVZPurchVatBook.JXVZVAT27 += Abs(VatEntry.Amount) * -1;

                                        TaxJurisdiction.JXVAType::IVA105:
                                            JXVZPurchVatBook.JXVZVAT105 += Abs(VatEntry.Amount) * -1;
                                    end;

                                TaxJurisdiction.JXTaxType::VATPerception:
                                    JXVZPurchVatBook.JXVZVATPercep += Abs(VatEntry.Amount) * -1;

                                TaxJurisdiction.JXTaxType::GrossIncome:
                                    begin
                                        JXVZPurchVatBook.JXVZIIBB += Abs(VatEntry.Amount) * -1;

                                        if TaxJurisdiction.JXVAType = TaxJurisdiction.JXVAType::ARBA then
                                            JXVZPurchVatBook.JXVZIIBBArba += Abs(VatEntry.Amount) * -1;

                                        if TaxJurisdiction.JXVAType = TaxJurisdiction.JXVAType::CABA then
                                            JXVZPurchVatBook.JXVZIIBBCaba += Abs(VatEntry.Amount) * -1;
                                    end;

                                TaxJurisdiction.JXTaxType::Others:
                                    JXVZPurchVatBook.JXVZSpecial += Abs(VatEntry.Amount) * -1;
                            end;
                    until VatEntry.Next() = 0;

                JXVZPurchVatBook.JXVZFiscalType := LTFiscalType.GetDescription(JXVZFiscalType);

                //Check dif amount
                /*
                JXVZPaymentSetup.Get();
                if JXVZPaymentSetup.JXVZCheckAmountVAT then begin
                    CheckAmount := (JXVZPurchVatBook.JXVZBaseAmount + JXVZPurchVatBook.JXVZNoBaseAmount + JXVZPurchVatBook.JXVZExemptBaseAmount + JXVZPurchVatBook.JXVZVAT105 + JXVZPurchVatBook.JXVZVAT21 + JXVZPurchVatBook.JXVZVAT27 + JXVZPurchVatBook.JXVZVATPercep + JXVZPurchVatBook.JXVZIIBB + JXVZPurchVatBook.JXVZSpecial);
                    if ((JXVZPurchVatBook.JXVZInvoiceAmountLCY - CheckAmount) <> 0) then
                        JXVZPurchVatBook.JXVZBaseAmount += (JXVZPurchVatBook.JXVZInvoiceAmountLCY - CheckAmount);
                end;
                */
                //Check dif amount END

                JXVZPurchVatBook.Insert();
            end;
        }

        dataitem(Temp; Integer)
        {
            DataItemTableView = sorting(Number) order(ascending);

            column(PostingDate; JXVZPurchVatBook.JXVZPostingDate)
            { }
            column(InvoiceNumber; JXVZPurchVatBook.JXVZInvoiceNumber)
            { }
            column(CompanyName; JXVZPurchVatBook.JXVZCompanyName)
            { }
            column(VATRegistrationNoo; JXVZPurchVatBook.JXVZVATRegistrationNo)
            { }
            column(Taxareacode; JXVZPurchVatBook.JXVZTaxAreaCode)
            { }
            column(Province; JXVZPurchVatBook.JXVZProvince)
            { }
            column(Invoicetype; JXVZPurchVatBook.JXVZInvoiceType)
            { }
            column(Invoiceamount; JXVZPurchVatBook.JXVZInvoiceAmount)
            { }
            column(Baseamount; JXVZPurchVatBook.JXVZBaseAmount)
            { }
            column(NoBaseamount; JXVZPurchVatBook.JXVZNoBaseAmount)
            { }
            column(ExemptBaseamount; JXVZPurchVatBook.JXVZExemptBaseAmount)
            { }
            column(VAT105; JXVZPurchVatBook.JXVZVAT105)
            { }
            column(VAT21; JXVZPurchVatBook.JXVZVAT21)
            { }
            column(VAT27; JXVZPurchVatBook.JXVZVAT27)
            { }
            column(VATpercep; JXVZPurchVatBook.JXVZVATPercep)
            { }
            column(IIBB; JXVZPurchVatBook.JXVZIIBB)
            { }
            column(Special; JXVZPurchVatBook.JXVZSpecial)
            { }
            column(FiscalType; JXVZPurchVatBook.JXVZFiscalType)
            { }
            column(CurrencyCode; JXVZPurchVatBook.JXVZCurrency)
            { }
            column(InvoiceAmountLCY; JXVZPurchVatBook.JXVZInvoiceAmountLCY)
            { }

            column(IIBBArba; JXVZPurchVatBook.JXVZIIBBArba)
            { }

            column(IIBBCaba; JXVZPurchVatBook.JXVZIIBBCaba)
            { }

            column(DocumentDate; JXVZPurchVatBook.JXVZDocumentDate)
            { }

            trigger OnPreDataItem()
            begin
                JXVZPurchVatBook.Reset();
                SetRange(Number, 1, JXVZPurchVatBook.Count());
            end;

            trigger OnAfterGetRecord()
            begin
                if (Number = 1) then
                    JXVZPurchVatBook.FindFirst()
                else
                    JXVZPurchVatBook.Next();

                if StrPos(JXVZPurchVatBook.JXVZVATRegistrationNo, '-') = 0 then
                    JXVZPurchVatBook.JXVZVATRegistrationNo := InsStr((InsStr(JXVZPurchVatBook.JXVZVATRegistrationNo, '-', 3)), '-', 12)
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
        JXVZPurchVatBook: Record JXVZVatBookTmp temporary;
        VatEntry: Record "VAT Entry";
        TaxJurisdiction: Record "Tax Jurisdiction";
        PurchInvLine: Record "Purch. Inv. Line";
        PurchCrMemoLine: Record "Purch. Cr. Memo Line";
        TaxGroup: Record "Tax Group";
        LTFiscalType: Record JXVZFiscalType;
        GenLedgerSetup: Record "General Ledger Setup";
        JXVZPaymentSetup: Record JXVZPaymentSetup;
        FromDate: Date;
        ToDate: Date;
        ReportKey: Integer;
        CheckAmount: Decimal;
}