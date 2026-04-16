report 84108 JXVZPurchVatBookNew
{
    Caption = 'Venezuela - Libro Compras';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    FormatRegion = 'ES';
    RDLCLayout = 'src/ReportLayout/VZPurchVatBookNew.rdl';

    dataset
    {
        dataitem(Header; Integer)
        {
            DataItemTableView = sorting(Number) order(ascending) where(Number = const(1));
            column(CompanyInfo_Number; Header.Number) { }
            column("CompanyInfo_VATRegistrationNo"; CompanyInfo."VAT Registration No.") { }
            column("CompanyInfo_Name"; CompanyInfo.Name) { }
            column(FromDate; FromDate) { }
            column(ToDate; ToDate) { }
            column(periodo; SetPeriod(FromDate, ToDate)) { }
            column(direccionfiscal; companyInfo."Address")
            {

            }
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

            trigger OnPreDataItem()
            begin
                "Purch. Inv. Header".SetRange("Posting Date", FromDate, ToDate);
                "Purch. Inv. Header".setRange(JXVZInvoiceType, JXVZInvoiceType::Invoice);
            end;

            trigger OnAfterGetRecord()
            var
                Vendor: Record Vendor;
            begin
                "Purch. Inv. Header".CalcFields("Amount Including VAT");
                "Purch. Inv. Header".CalcFields(Amount);
                tempJXVZPurchVatBook.Init();
                ReportKey += 1;

                tempJXVZPurchVatBook.JXVZKey := ReportKey;
                tempJXVZPurchVatBook.JXVZPostingDate := Format("Purch. Inv. Header"."Posting Date", 0, '<Day,2>/<Month,2>/<Year,4>');
                tempJXVZPurchVatBook.JXVZVATRegistrationNo := "Purch. Inv. Header"."VAT Registration No.";
                tempJXVZPurchVatBook.JXVZLegalName := "Purch. Inv. Header"."Pay-to Name";
                tempJXVZPurchVatBook.JXVZInvoiceNumber := "Purch. Inv. Header"."No.";

                //IVA retención (contribuyente especial)
                GetIVARet(JXVZWithholdLedgerEntry, "Purch. Inv. Header"."No.", "Purch. Inv. Header"."Buy-from Vendor No.");
                tempJXVZPurchVatBook.JXVZVatRetenNo := JXVZWithholdLedgerEntry.JXVZWitholdingCertificateNo;
                tempJXVZPurchVatBook.JXVZEmissionDate := JXVZWithholdLedgerEntry.JXVZWitholdingDate;
                tempJXVZPurchVatBook.JXVZVATRetention := JXVZWithholdLedgerEntry.JXVZWitholdingAmount;

                tempJXVZPurchVatBook.JXVZControlNumber := "Purch. Inv. Header".JXVZCtrlDocumentNo;
                tempJXVZPurchVatBook.JXVZimportTemplateNo := "Purch. Inv. Header"."Vendor Order No.";
                //tempJXVZPurchVatBook.JXVZImportFileNo := "Purch. Inv. Header".JXVZImportFileNo;
                tempJXVZPurchVatBook.JXVZTransactionType := Format(JXVZDocTypeLVE::Reg);
                tempJXVZPurchVatBook.JXVZExemptPurchases := 0;
                tempJXVZPurchVatBook.JXVZPurchasesWithoutCredit := 0;
                Vendor.get("Purch. Inv. Header"."Buy-from Vendor No.");
                if Vendor."Partner Type" = Vendor."Partner Type"::Company then begin
                    tempJXVZPurchVatBook."Partner Type" := 'PJD';

                end;
                if Vendor."Partner Type" = Vendor."Partner Type"::Person then begin
                    tempJXVZPurchVatBook."Partner Type" := 'PNR';
                end;
                tempJXVZPurchVatBook.JXVZVATRetainedThirdParty := 0;
                if ("Purch. Inv. Header"."Currency Code" <> '') then
                    tempJXVZPurchVatBook.JXVZTotalAmountVAT := Abs("Purch. Inv. Header"."Amount Including VAT") / "Purch. Inv. Header"."Currency Factor"
                else
                    tempJXVZPurchVatBook.JXVZTotalAmountVAT := Abs("Purch. Inv. Header"."Amount Including VAT");
                SetVendor(tempJXVZPurchVatBook, "Purch. Inv. Header"."Pay-to Vendor No.");
                SetVATEntry("Purch. Inv. Header"."No.", tempJXVZPurchVatBook);
                SetPayments(tempJXVZPurchVatBook, "Purch. Inv. Header"."No.");
                TotalLine(tempJXVZPurchVatBook);

                tempJXVZPurchVatBook.Insert();
            end;
        }

        dataitem("Purch. Cr. Memo Hdr."; "Purch. Cr. Memo Hdr.")
        {
            DataItemTableView = sorting("No.") order(ascending);
            trigger OnPreDataItem()
            begin
                "Purch. Cr. Memo Hdr.".SetRange("Posting Date", FromDate, ToDate);
            end;

            trigger OnAfterGetRecord()
            var
                Vendor: Record Vendor;
            begin
                "Purch. Cr. Memo Hdr.".CalcFields("Amount Including VAT");
                "Purch. Cr. Memo Hdr.".CalcFields(Amount);
                tempJXVZPurchVatBook.Init();
                ReportKey += 1;
                tempJXVZPurchVatBook.JXVZKey := ReportKey;
                tempJXVZPurchVatBook.JXVZPostingDate := Format("Purch. Cr. Memo Hdr."."Posting Date", 0, '<Day,2>/<Month,2>/<Year>');
                tempJXVZPurchVatBook.JXVZCreditMemoNo := "Purch. Cr. Memo Hdr."."No.";
                tempJXVZPurchVatBook.JXVZAffectedDocNo := "Purch. Cr. Memo Hdr."."Applies-to Doc. No.";

                //IVA retención (contribuyente especial)
                GetIVARet(JXVZWithholdLedgerEntry, "Purch. Inv. Header"."No.", "Purch. Inv. Header"."Buy-from Vendor No.");
                tempJXVZPurchVatBook.JXVZVatRetenNo := JXVZWithholdLedgerEntry.JXVZWitholdingCertificateNo;
                tempJXVZPurchVatBook.JXVZEmissionDate := JXVZWithholdLedgerEntry.JXVZWitholdingDate;
                tempJXVZPurchVatBook.JXVZVATRetention := JXVZWithholdLedgerEntry.JXVZWitholdingAmount;

                tempJXVZPurchVatBook.JXVZControlNumber := "Purch. Cr. Memo Hdr.".JXVZCtrlDocumentNo;
                //tempJXVZPurchVatBook.JXVZimportTemplateNo := "Purch. Cr. Memo Hdr.".JXVZImportTemplateNo;
                //tempJXVZPurchVatBook.JXVZImportFileNo := "Purch. Cr. Memo Hdr.".JXVZImportFileNo;

                if ("Purch. Cr. Memo Hdr."."Applies-to Doc. Type" = "Purch. Cr. Memo Hdr."."Applies-to Doc. Type"::" ") and ("Purch. Cr. Memo Hdr."."Applies-to Doc. No." = '') then
                    tempJXVZPurchVatBook.JXVZTransactionType := Format(JXVZDocTypeLVE::Reg)
                else
                    tempJXVZPurchVatBook.JXVZTransactionType := Format(JXVZDocTypeLVE::Com);

                tempJXVZPurchVatBook.JXVZExemptPurchases := 0;
                tempJXVZPurchVatBook.JXVZPurchasesWithoutCredit := 0;
                Vendor.get("Purch. Cr. Memo Hdr."."Buy-from Vendor No.");
                if Vendor."Partner Type" = Vendor."Partner Type"::Company then begin
                    tempJXVZPurchVatBook."Partner Type" := 'PJD';
                end;
                if Vendor."Partner Type" = Vendor."Partner Type"::Person then begin
                    tempJXVZPurchVatBook."Partner Type" := 'PNR';
                end;
                if ("Purch. Cr. Memo Hdr."."Currency Code" <> '') then
                    tempJXVZPurchVatBook.JXVZTotalAmountVAT := (Abs("Purch. Cr. Memo Hdr."."Amount Including VAT") / "Purch. Cr. Memo Hdr."."Currency Factor") * -1
                else
                    tempJXVZPurchVatBook.JXVZTotalAmountVAT := (Abs("Purch. Cr. Memo Hdr."."Amount Including VAT") * -1);

                SetVendor(tempJXVZPurchVatBook, "Purch. Cr. Memo Hdr."."Pay-to Vendor No.");
                SetVATEntry("Purch. Cr. Memo Hdr."."No.", tempJXVZPurchVatBook);
                SetPayments(tempJXVZPurchVatBook, "Purch. Cr. Memo Hdr."."No.");
                TotalLine(tempJXVZPurchVatBook);

                tempJXVZPurchVatBook.Insert();
            end;
        }
        dataitem("Purch. Debit Memo"; "Purch. Inv. Header")
        {
            DataItemTableView = sorting("No.") order(ascending);
            trigger OnPreDataItem()
            var
                myInt: Integer;
            begin
                "Purch. Debit Memo".SetRange("Posting Date", FromDate, ToDate);
                "Purch. Debit Memo".setRange(JXVZInvoiceType, JXVZInvoiceType::DebitMemo);
            end;

            trigger OnAfterGetRecord()
            var
                Vendor: Record Vendor;
            begin
                "Purch. Debit Memo".CalcFields("Amount Including VAT");
                "Purch. Debit Memo".CalcFields(Amount);
                tempJXVZPurchVatBook.Init();
                ReportKey += 1;

                tempJXVZPurchVatBook.JXVZKey := ReportKey;
                tempJXVZPurchVatBook.JXVZPostingDate := Format("Purch. Debit Memo"."Posting Date", 0, '<Day,2>/<Month,2>/<Year,4>');
                tempJXVZPurchVatBook.JXVZVATRegistrationNo := "Purch. Debit Memo"."VAT Registration No.";
                tempJXVZPurchVatBook.JXVZLegalName := "Purch. Debit Memo"."Pay-to Name";
                tempJXVZPurchVatBook.JXVZInvoiceNumber := "Purch. Debit Memo"."No.";

                //IVA retención (contribuyente especial)
                GetIVARet(JXVZWithholdLedgerEntry, "Purch. Debit Memo"."No.", "Purch. Debit Memo"."Buy-from Vendor No.");
                tempJXVZPurchVatBook.JXVZVatRetenNo := JXVZWithholdLedgerEntry.JXVZWitholdingCertificateNo;
                tempJXVZPurchVatBook.JXVZEmissionDate := JXVZWithholdLedgerEntry.JXVZWitholdingDate;
                tempJXVZPurchVatBook.JXVZVATRetention := JXVZWithholdLedgerEntry.JXVZWitholdingAmount;

                tempJXVZPurchVatBook.JXVZControlNumber := "Purch. Debit Memo".JXVZCtrlDocumentNo;
                tempJXVZPurchVatBook.JXVZimportTemplateNo := "Purch. Debit Memo"."Vendor Order No.";
                //tempJXVZPurchVatBook.JXVZImportFileNo := "Purch. Debit Memo".JXVZImportFileNo;
                if ("Purch. Debit Memo"."Applies-to Doc. Type" = "Purch. Debit Memo"."Applies-to Doc. Type"::" ") and ("Purch. Debit Memo"."Applies-to Doc. No." = '') then
                    tempJXVZPurchVatBook.JXVZTransactionType := Format(JXVZDocTypeLVE::Reg)
                else
                    tempJXVZPurchVatBook.JXVZTransactionType := Format(JXVZDocTypeLVE::Com);

                tempJXVZPurchVatBook.JXVZExemptPurchases := 0;
                tempJXVZPurchVatBook.JXVZPurchasesWithoutCredit := 0;
                Vendor.get("Purch. Debit Memo"."Buy-from Vendor No.");
                if Vendor."Partner Type" = Vendor."Partner Type"::Company then begin
                    tempJXVZPurchVatBook."Partner Type" := 'PJD';

                end;
                if Vendor."Partner Type" = Vendor."Partner Type"::Person then begin
                    tempJXVZPurchVatBook."Partner Type" := 'PNR';
                end;
                tempJXVZPurchVatBook.JXVZVATRetainedThirdParty := 0;
                if ("Purch. Debit Memo"."Currency Code" <> '') then
                    tempJXVZPurchVatBook.JXVZTotalAmountVAT := Abs("Purch. Debit Memo"."Amount Including VAT") / "Purch. Debit Memo"."Currency Factor"
                else
                    tempJXVZPurchVatBook.JXVZTotalAmountVAT := Abs("Purch. Debit Memo"."Amount Including VAT");
                SetVendor(tempJXVZPurchVatBook, "Purch. Debit Memo"."Pay-to Vendor No.");
                SetVATEntry("Purch. Debit Memo"."No.", tempJXVZPurchVatBook);
                SetPayments(tempJXVZPurchVatBook, "Purch. Debit Memo"."No.");
                TotalLine(tempJXVZPurchVatBook);

                tempJXVZPurchVatBook.Insert();
            end;
        }

        dataitem(Temp; Integer)
        {
            DataItemTableView = sorting(Number) order(ascending);
            column(Comprobante; tempJXVZPurchVatBook.JXVZKey)
            { }
            column(PostingDate; tempJXVZPurchVatBook.JXVZPostingDate)
            { }
            column(VATRegistrationNo; tempJXVZPurchVatBook.JXVZVATRegistrationNo)
            { }
            column(LegalName; tempJXVZPurchVatBook.JXVZLegalName)
            { }
            column(VatRetenNo; tempJXVZPurchVatBook.JXVZVatRetenNo)
            { }
            column(EmissionDate; tempJXVZPurchVatBook.JXVZemissionDate)
            { }
            column(ImportTemplateNo; tempJXVZPurchVatBook.JXVZImportTemplateNo)
            { }
            column(ImportFileNo; tempJXVZPurchVatBook.JXVZImportFileNo)
            { }
            column(InvoiceNumber; tempJXVZPurchVatBook.JXVZInvoiceNumber)
            { }
            column(ControlNumber; tempJXVZPurchVatBook.JXVZControlNumber)
            { }
            column(DebitMemoNo; tempJXVZPurchVatBook.JXVZDebitMemoNo)
            { }
            column(CreditMemoNo; tempJXVZPurchVatBook.JXVZCreditMemoNo)
            { }
            column(AffectedDocNo; tempJXVZPurchVatBook.JXVZAffectedDocNo)
            { }
            column(TotalAmountVAT; tempJXVZPurchVatBook.JXVZTotalAmountVAT)
            { }
            column(PaymentMethod; tempJXVZPurchVatBook.JXVZPaymentMethod)
            { }
            column(SupportNo; TempJXVZPurchVatBook.JXVZSupportNo)
            { }
            column(Bank; tempJXVZPurchVatBook.JXVZBank)
            { }
            column(BaseAmount; TempJXVZPurchVatBook.JXVZBaseAmount)
            { }
            column(VAT; TempJXVZPurchVatBook."JXVZVAT%")
            { }
            column(VatAmount; TempJXVZPurchVatBook.JXVZVatAmount)
            { }
            column(VATRetVendor; tempJXVZPurchVatBook.JXVZVATRetention)
            { }

            //Totales
            column(TotalInvoiceAmountLCY; TotalInvoiceAmountLCY)
            { }
            column(TotalBaseAmount; TotalBaseAmount)
            { }
            column(TotalVAT; TotalVAT)
            { }
            column(TotalVATRetention; TotalVATRetention)
            { }

            column(TransactionType; tempJXVZPurchVatBook.JXVZTransactionType)
            { }
            column(AffectedInvoiceNo; tempJXVZPurchVatBook.JXVZAffectedInvoiceNo)
            { }
            column(TotalPurchasesIncludingVAT; tempJXVZPurchVatBook.JXVZTotalAmountVAT)
            { }
            column(ExemptPurchases; tempJXVZPurchVatBook.JXVZExemptPurchases)
            { }
            column(PurchasesWithoutCredit; tempJXVZPurchVatBook.JXVZPurchasesWithoutCredit)
            { }
            column(ExoneratedPurchases; tempJXVZPurchVatBook.JXVZExoneratedPurchases)
            { }
            column(TaxableBase; tempJXVZPurchVatBook.JXVZTaxableBase)
            { }
            column(TaxRate; tempJXVZPurchVatBook.JXVZTaxRate)
            { }
            column(TaxAmount; tempJXVZPurchVatBook.JXVZTaxAmount)
            { }
            column(ExemptOrExonerated; tempJXVZPurchVatBook.JXVZExemptOrExonerated)
            { }
            column(ExoneratedBase; tempJXVZPurchVatBook.JXVZExoneratedBase)
            { }
            column(ExoneratedRate; tempJXVZPurchVatBook.JXVZExoneratedRate)
            { }
            column(ExoneratedTax; tempJXVZPurchVatBook.JXVZExoneratedTax)
            { }
            column(VATRetainedVendor; tempJXVZPurchVatBook.JXVZVATRetainedVendor)
            { }
            column(VATRetainedThirdParty; tempJXVZPurchVatBook.JXVZVATRetainedThirdParty)
            { }
            column(TipoProvedor; tempJXVZPurchVatBook."Partner Type")
            { }
            column(BaseComprasInternas; tempJXVZPurchVatBook.BaseComprasInternas)
            { }
            column(AlicuotaComprasInternas; tempJXVZPurchVatBook.AlicuotaComprasInternas)
            { }
            column(ImpuestoIVAComprasInternas; tempJXVZPurchVatBook.ImpuestoIVAComprasInternas)
            { }
            column(BaseComprasImportaciones; tempJXVZPurchVatBook.BaseComprasImportaciones)
            { }
            column(AlicuotaComprasImportaciones; tempJXVZPurchVatBook.AlicuotaComprasImportaciones)
            { }
            column(ImpIVAComprasImportaciones; tempJXVZPurchVatBook.ImpIVAComprasImportaciones)
            { }
            column(BaseCompraInterGrav; tempJXVZPurchVatBook.BaseCompraInterGrav)
            { }
            column(AlicuotaCompraInterGrav; tempJXVZPurchVatBook.AlicuotaCompraInterGrav)
            { }
            column(ImpIVACompraInterGrav; tempJXVZPurchVatBook.ImpIVACompraInterGrav)
            { }
            column(exento; tempJXVZPurchVatBook.Exento)
            {

            }
            trigger OnPreDataItem()
            begin
                tempJXVZPurchVatBook.Reset();
                SetRange(Number, 1, tempJXVZPurchVatBook.Count());
            end;

            trigger OnAfterGetRecord()
            begin
                if (Number = 1) then
                    tempJXVZPurchVatBook.FindFirst()
                else
                    tempJXVZPurchVatBook.Next();

                // if StrPos(tempJXVZPurchVatBook.JXVZVATRegistrationNo, '-') = 0 then
                // tempJXVZPurchVatBook.JXVZVATRegistrationNo := InsStr((InsStr(tempJXVZPurchVatBook.JXVZVATRegistrationNo, '-', 3)), '-', 12)
                tempJXVZPurchVatBook.JXVZVATRegistrationNo := tempJXVZPurchVatBook.JXVZVATRegistrationNo;
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
    }

    local procedure SetPayments(var PurchVatBook: Record JXVZVatBookTemp; _No: Code[20])
    var
        VendorLedgEntry: record "Vendor Ledger Entry";
        VendorLedgEntry2: Record "Vendor Ledger Entry";
        BankAccLedgEntry: Record "Bank Account Ledger Entry";
        PaymentMethod: Record "Payment Method";

    begin
        VendorLedgEntry.reset();
        VendorLedgEntry.setRange("Document No.", _No);
        if VendorLedgEntry.findFirst() then begin

            VendorLedgEntry2.reset();
            VendorLedgEntry2.SetRange("Entry No.", VendorLedgEntry."Closed by Entry No.");
            if VendorLedgEntry2.FindFirst() then begin

                PurchVatBook.JXVZSupportNo := VendorLedgEntry2."Payment Reference";

                PaymentMethod.reset();
                PaymentMethod.SetRange(Code, VendorLedgEntry2."Payment Method Code");
                if PaymentMethod.FindFirst() then
                    PurchVatBook.JXVZPaymentMethod := PaymentMethod.Description;

                bankAccLedgEntry.reset();
                BankAccLedgEntry.SetRange("Document No.", VendorLedgEntry2."Document No.");
                if BankAccLedgEntry.FindFirst() then
                    PurchVatBook.JXVZBank := BankAccLedgEntry."Bank Account No.";
            end;
        end;
    end;

    local procedure SetVATEntry(_No: Code[20]; var PurchVatBook: Record JXVZVatBookTemp)
    var
        VATEntry: Record "VAT Entry";
    begin
        VATEntry.Reset();
        VATEntry.SetRange(VATEntry."Document No.", _No);
        if VATEntry.FindSet() then
            repeat
                VatProductPostingGroup.Reset();
                VatProductPostingGroup.SetRange(Code, VATEntry."VAT Prod. Posting Group");

                if VatProductPostingGroup.FindSet() then begin
                    VATPostingSetup.Reset();
                    VATPostingSetup.SetRange("VAT Prod. Posting Group", VATEntry."VAT Prod. Posting Group");
                    VATPostingSetup.FindFirst();
                    if VatProductPostingGroup.JXVZVatPurchReport = VatProductPostingGroup.JXVZVatPurchReport::Internas then begin
                        PurchVatBook.BaseComprasInternas += VATEntry.Base;
                        PurchVatBook.AlicuotaComprasInternas := VATPostingSetup."VAT %";
                        PurchVatBook.ImpuestoIVAComprasInternas += VATEntry.Amount;
                    end;
                    if VatProductPostingGroup.JXVZVatPurchReport = VatProductPostingGroup.JXVZVatPurchReport::Importaciones then begin
                        PurchVatBook.BaseComprasImportaciones += VATEntry.Base;
                        PurchVatBook.AlicuotaComprasImportaciones := VATPostingSetup."VAT %";
                        PurchVatBook.ImpIVAComprasImportaciones += VATEntry.Amount;
                    end;
                    if VatProductPostingGroup.JXVZVatPurchReport = VatProductPostingGroup.JXVZVatPurchReport::"Internas Gravadas Aliciota Reducida" then begin
                        PurchVatBook.BaseCompraInterGrav += VATEntry.Base;
                        PurchVatBook.AlicuotaCompraInterGrav := VATPostingSetup."VAT %";
                        PurchVatBook.ImpIVACompraInterGrav += VATEntry.Amount;
                    end;
                    if VatProductPostingGroup.JXVZVatPurchReport = VatProductPostingGroup.JXVZVatPurchReport::Exento then begin
                        PurchVatBook.Exento += VATEntry.Base;
                    end;
                end;
            until VATEntry.Next() = 0;

    end;

    procedure SetDates(_FromDate: Date;
        _ToDate: Date)
    begin
        FromDate := _FromDate;
        ToDate := _ToDate;
    end;

    local procedure TotalLine(var PurchVatBook: record JXVZVatBookTemp)
    begin
        TotalInvoiceAmountLCY += PurchVatBook.JXVZTotalAmountVAT;
        TotalVAT += PurchVatBook.JXVZVatAmount;
        TotalBaseAmount += PurchVatBook.JXVZBaseAmount;
        TotalVatRetention += PurchVatBook.JXVZVATRetention;
    end;

    local procedure SetVendor(Var PurchVatBook: Record JXVZVatBookTemp; _NoVendor: Code[20])
    var
        Vendor: Record Vendor;
    begin
        vendor.reset();
        Vendor.SetRange("No.", _NoVendor);
        if vendor.FindFirst() then begin
            tempJXVZPurchVatBook.JXVZVATRegistrationNo := vendor."VAT Registration No.";
            tempJXVZPurchVatBook.JXVZLegalName := vendor.Name;
        end;
    end;

    local procedure SetPeriod(FromDate: Date; ToDate: Date): Text
    var
        ArrayMonth: array[12] of Text[10];
        MonthNameFrom: Text[10];
        MonthNameTo: Text[10];
        YearFrom: Integer;
        YearTo: Integer;
    begin
        ArrayMonth[1] := 'ENERO';
        ArrayMonth[2] := 'FEBRERO';
        ArrayMonth[3] := 'MARZO';
        ArrayMonth[4] := 'ABRIL';
        ArrayMonth[5] := 'MAYO';
        ArrayMonth[6] := 'JUNIO';
        ArrayMonth[7] := 'JULIO';
        ArrayMonth[8] := 'AGOSTO';
        ArrayMonth[9] := 'SEPTIEMBRE';
        ArrayMonth[10] := 'OCTUBRE';
        ArrayMonth[11] := 'NOVIEMBRE';
        ArrayMonth[12] := 'DICIEMBRE';

        MonthNameFrom := ArrayMonth[Date2DMY(FromDate, 2)];
        MonthNameTo := ArrayMonth[Date2DMY(ToDate, 2)];
        YearFrom := Date2DMY(FromDate, 3);
        YearTo := Date2DMY(ToDate, 3);

        if (YearFrom = YearTo) and (Date2DMY(FromDate, 2) = Date2DMY(ToDate, 2)) then
            // Mismo mes y año
            exit(StrSubstNo('COMPRAS CORRESPONDIENTES 1 AL %1 DE %2 DEL AÑO %3',
            Date2DMY(ToDate, 1), MonthNameTo, YearTo))
        else
            if (YearFrom = YearTo) and (Date2DMY(FromDate, 2) = 1) and (Date2DMY(ToDate, 2) = 12) and (Date2DMY(FromDate, 1) = 1) and (Date2DMY(ToDate, 1) = 31) then
                // Todo el año
                exit(StrSubstNo('COMPRAS CORRESPONDIENTES 1 DE ENERO AL 31 DE DICIEMBRE DEL AÑO %1', YearTo))
            else
                if (YearFrom = YearTo) then
                    // Rango dentro del mismo año, pero meses diferentes
                    exit(StrSubstNo('COMPRAS CORRESPONDIENTES 1 DE %1 AL %2 DE %3 DEL AÑO %4',
                    MonthNameFrom, Date2DMY(ToDate, 1), MonthNameTo, YearTo))
                else
                    // Rango de años diferentes
                    exit(StrSubstNo('COMPRAS CORRESPONDIENTES 1 DE ENERO DEL %1 AL 31 DE DICIEMBRE DEL %2',
                    YearFrom, YearTo));
    end;

    local procedure GetIVARet(var _WithholdLedgerEntry: Record JXVZWithholdLedgerEntry; _DocumentNo: Code[20]; _VendorNo: Code[20])
    var
        JXVZWithholdingTax: Record JXVZWithholdingTax;
    begin
        JXVZWithholdingTax.Reset();
        JXVZWithholdingTax.SetRange(JXVZTaxType, JXVZWithholdingTax.JXVZTaxType::IVA);
        if JXVZWithholdingTax.FindFirst() then begin
            _WithholdLedgerEntry.Reset();
            _WithholdLedgerEntry.SetRange(JXVZVoucherNo, _DocumentNo);
            _WithholdLedgerEntry.SetRange(JXVZVendorCode, _VendorNo);
            _WithholdLedgerEntry.SetRange(JXVZTaxCode, JXVZWithholdingTax.JXVZTaxCode);
            if _WithholdLedgerEntry.FindFirst() then;
        end;
    end;

    var
        CompanyInfo: Record "Company Information";
        GenLedgerSetup: Record "General Ledger Setup";
        JXVZWithholdLedgerEntry: Record JXVZWithholdLedgerEntry;
        VatProductPostingGroup: Record "VAT Product Posting Group";
        VATPostingSetup: Record "VAT Posting Setup";
        tempJXVZPurchVatBook: Record JXVZVatBookTemp temporary;
        FromDate: Date;
        ToDate: Date;
        ReportKey: Integer;

        //Lineas totales
        TotalInvoiceAmountLCY: Decimal;
        TotalBaseAmount: Decimal;
        TotalVAT: Decimal;
        TotalVatRetention: Decimal;
}