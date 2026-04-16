report 84118 JXVZSalesVatBookNew
{
    Caption = 'Venezuela - Libro ventas';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'src/ReportLayout/VZSalesVatBookNew.rdl';

    dataset
    {
        dataitem(Header; Integer)
        {
            DataItemTableView = sorting(Number) order(ascending) where(Number = const(1));
            column("CompanyInfo_VATRegistrationNo"; CompanyInfo."VAT Registration No.") { }
            column("CompanyInfo_Name"; CompanyInfo.Name) { }
            column(FromDate; FromDate) { }
            column(ToDate; ToDate) { }
            column(periodo; SetPeriod(fromDate)) { }

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
                "Sales Invoice Header".setRange(JXVZInvoiceType, JXVZInvoiceType::Invoice);
            end;

            trigger OnAfterGetRecord()
            var
                customer: Record customer;
                SalesInvLine: Record "Sales Invoice Line";
                VatProdPostingGroup: Record "VAT Product Posting Group";
            begin
                "Sales Invoice Header".CalcFields("Amount Including VAT");
                "Sales Invoice Header".CalcFields(Amount);
                tempJXVZSalesVatBook.Init();
                ReportKey += 1;
                tempJXVZSalesVatBook.JXVZKey := ReportKey;
                tempJXVZSalesVatBook.JXVZPostingDate := Format("Sales Invoice Header"."Posting Date", 0, '<Day,2>/<Month,2>/<Year>');
                tempJXVZSalesVatBook.JXVZInvoiceNumber := "Sales Invoice Header"."No.";

                //tempJXVZSalesVatBook.JXVZvatRetenNo := "Sales Invoice Header".JXVZVATRetentionNo;
                //tempJXVZSalesVatBook.JXVZVATRetention := "Sales Invoice Header".JXVZVATRetention;
                //tempJXVZSalesVatBook.JXVZEmissionDate := "Sales Invoice Header".JXVZEmissionDate;
                //tempJXVZSalesVatBook.JXVZReceptionDate := "Sales Invoice Header".JXVZReceptionDate;
                tempJXVZSalesVatBook.JXVZControlNumber := "Sales Invoice Header".JXVZCtrlDocumentNo;

                //tempJXVZSalesVatBook.JXVZExportTemplateNo := "Sales Invoice Header".JXVZExportTemplateNo;
                if customer.get("Sales Invoice Header"."Bill-to Customer No.") then;
                //tempJXVZSalesVatBook.JXVZFOBValue := "Sales Invoice Header".JXVZFOBValue;

                tempJXVZSalesVatBook.JXVZTransactionType := Format(JXVZDocTypeLVE::Reg);

                SalesInvLine.Reset();
                SalesInvLine.SetRange("Document No.", "Sales Invoice Header"."No.");
                if SalesInvLine.FindSet() then
                    repeat
                        VatProdPostingGroup.Reset();
                        VatProdPostingGroup.SetRange(Code, SalesInvLine."VAT Prod. Posting Group");
                        if VatProdPostingGroup.FindFirst() then begin
                            case VatProdPostingGroup.JXVZVatPurchReport of
                                VatProdPostingGroup.JXVZVatPurchReport::Exento:
                                    tempJXVZSalesVatBook.JXVZSalesExempt += SalesInvLine."Amount Including VAT";

                                VatProdPostingGroup.JXVZVatPurchReport::Exonerado:
                                    tempJXVZSalesVatBook.JXVZSalesExonerated += SalesInvLine."Amount Including VAT";

                                VatProdPostingGroup.JXVZVatPurchReport::Tercero:
                                    tempJXVZSalesVatBook.JXVZSalesThirdParty += SalesInvLine."Amount Including VAT";
                            end;
                        end;
                    until SalesInvLine.Next() = 0;

                //Initial values
                tempJXVZSalesVatBook.JXVZGeneralTaxBase := 0;
                tempJXVZSalesVatBook.JXVZGeneralTaxAmount := 0;
                tempJXVZSalesVatBook.JXVZGeneralTaxRate := 0;
                tempJXVZSalesVatBook.JXVZPerceivedBaseAmount := 0;
                tempJXVZSalesVatBook.JXVZPerceivedTaxAmount := 0;
                tempJXVZSalesVatBook.JXVZPerceivedTaxRate := 0;
                tempJXVZSalesVatBook.JXVZVatAmount := 0;
                tempJXVZSalesVatBook.JXVZBaseAmount := 0;
                tempJXVZSalesVatBook."JXVZVAT%" := 0;

                SetVATEntry("Sales Invoice Header"."No.", customer."No.", tempJXVZSalesVatBook);
                //tempJXVZSalesVatBook.JXVZVATRetainedBuyer := "Sales Invoice Header".JXVZVATRetention;

                if ("Sales Invoice Header"."Currency Code" <> '') then begin
                    tempJXVZSalesVatBook.JXVZTotalAmountVAT := Abs("Sales Invoice Header"."Amount Including VAT") / "Sales Invoice Header"."Currency Factor";
                end else begin
                    tempJXVZSalesVatBook.JXVZTotalAmountVAT := Abs("Sales Invoice Header"."Amount Including VAT");
                end;

                setCustomer(tempJXVZSalesVatBook, "Sales Invoice Header"."Bill-to Customer No.");
                TotalLine(tempJXVZSalesVatBook);

                tempJXVZSalesVatBook.Insert();

            end;
        }
        dataitem("Sales Cr.Memo Header"; "Sales Cr.Memo Header")
        {
            DataItemTableView = sorting("No.") order(ascending);
            trigger OnPreDataItem()
            begin
                "Sales Cr.Memo Header".SetRange("Posting Date", FromDate, ToDate);
            end;

            trigger OnAfterGetRecord()
            var
                customer: Record customer;
                SalesCRMemoLine: Record "Sales Cr.Memo Line";
                VatProdPostingGroup: Record "VAT Product Posting Group";
            begin
                "Sales Cr.Memo Header".CalcFields("Amount Including VAT");
                "Sales Cr.Memo Header".CalcFields(Amount);
                tempJXVZSalesVatBook.Init();
                ReportKey += 1;
                tempJXVZSalesVatBook.JXVZKey := ReportKey;
                tempJXVZSalesVatBook.JXVZPostingDate := Format("Sales Cr.Memo Header"."Posting Date", 0, '<Day,2>/<Month,2>/<Year>');
                tempJXVZSalesVatBook.JXVZCreditMemoNo := "Sales Cr.Memo Header"."No.";
                tempJXVZSalesVatBook.JXVZAffectedDocNo := "Sales Cr.Memo Header"."Applies-to Doc. No.";

                //tempJXVZSalesVatBook.JXVZvatRetenNo := "Sales Cr.Memo Header".JXVZVATRetentionNo;
                //tempJXVZSalesVatBook.JXVZVATRetention := "Sales Cr.Memo Header".JXVZVATRetention * -1;
                //tempJXVZSalesVatBook.JXVZEmissionDate := "Sales Cr.Memo Header".JXVZEmissionDate;
                //tempJXVZSalesVatBook.JXVZReceptionDate := "Sales Cr.Memo Header".JXVZReceptionDate;
                tempJXVZSalesVatBook.JXVZControlNumber := "Sales Cr.Memo Header".JXVZCtrlDocumentNo;

                //tempJXVZSalesVatBook.JXVZExportTemplateNo := "Sales Cr.Memo Header".JXVZExportTemplateNo;
                if customer.get("Sales Cr.Memo Header"."Bill-to Customer No.") then;

                //tempJXVZSalesVatBook.JXVZFOBValue := "Sales Cr.Memo Header".JXVZFOBValue;
                if ("Sales Cr.Memo Header"."Applies-to Doc. Type" = "Sales Cr.Memo Header"."Applies-to Doc. Type"::" ") and ("Sales Cr.Memo Header"."Applies-to Doc. No." = '') then
                    tempJXVZSalesVatBook.JXVZTransactionType := Format(JXVZDocTypeLVE::Reg)
                else
                    tempJXVZSalesVatBook.JXVZTransactionType := Format(JXVZDocTypeLVE::Com);

                SalesCRMemoLine.Reset();
                SalesCRMemoLine.SetRange("Document No.", "Sales Invoice Header"."No.");
                if SalesCRMemoLine.FindSet() then
                    repeat
                        VatProdPostingGroup.Reset();
                        VatProdPostingGroup.SetRange(Code, SalesCRMemoLine."VAT Prod. Posting Group");
                        if VatProdPostingGroup.FindFirst() then begin
                            case VatProdPostingGroup.JXVZVatPurchReport of
                                VatProdPostingGroup.JXVZVatPurchReport::Exento:
                                    tempJXVZSalesVatBook.JXVZSalesExempt += SalesCRMemoLine."Amount Including VAT";

                                VatProdPostingGroup.JXVZVatPurchReport::Exonerado:
                                    tempJXVZSalesVatBook.JXVZSalesExonerated += SalesCRMemoLine."Amount Including VAT";

                                VatProdPostingGroup.JXVZVatPurchReport::Tercero:
                                    tempJXVZSalesVatBook.JXVZSalesThirdParty += SalesCRMemoLine."Amount Including VAT";
                            end;
                        end;
                    until SalesCRMemoLine.Next() = 0;

                tempJXVZSalesVatBook.JXVZSalesExempt := tempJXVZSalesVatBook.JXVZSalesExempt * -1;
                tempJXVZSalesVatBook.JXVZSalesExonerated := tempJXVZSalesVatBook.JXVZSalesExonerated * -1;
                tempJXVZSalesVatBook.JXVZSalesThirdParty := tempJXVZSalesVatBook.JXVZSalesThirdParty * -1;

                if ("Sales Cr.Memo Header"."Currency Code" <> '') then begin
                    tempJXVZSalesVatBook.JXVZTotalAmountVAT := (Abs("Sales Cr.Memo Header"."Amount Including VAT") / "Sales Invoice Header"."Currency Factor" * -1);
                end else begin
                    tempJXVZSalesVatBook.JXVZTotalAmountVAT := (Abs("Sales Cr.Memo Header"."Amount Including VAT") * -1);
                end;

                setCustomer(tempJXVZSalesVatBook, "Sales Cr.Memo Header"."Bill-to Customer No.");

                //Initial values
                tempJXVZSalesVatBook.JXVZGeneralTaxBase := 0;
                tempJXVZSalesVatBook.JXVZGeneralTaxAmount := 0;
                tempJXVZSalesVatBook.JXVZGeneralTaxRate := 0;
                tempJXVZSalesVatBook.JXVZPerceivedBaseAmount := 0;
                tempJXVZSalesVatBook.JXVZPerceivedTaxAmount := 0;
                tempJXVZSalesVatBook.JXVZPerceivedTaxRate := 0;
                tempJXVZSalesVatBook.JXVZVatAmount := 0;
                tempJXVZSalesVatBook.JXVZBaseAmount := 0;
                tempJXVZSalesVatBook."JXVZVAT%" := 0;

                SetVATEntry("Sales Cr.Memo Header"."No.", Customer."No.", tempJXVZSalesVatBook);

                tempJXVZSalesVatBook.JXVZGeneralTaxBase := tempJXVZSalesVatBook.JXVZGeneralTaxBase * -1;
                tempJXVZSalesVatBook.JXVZGeneralTaxAmount := tempJXVZSalesVatBook.JXVZGeneralTaxAmount * -1;
                tempJXVZSalesVatBook.JXVZGeneralTaxRate := tempJXVZSalesVatBook.JXVZGeneralTaxRate * -1;
                tempJXVZSalesVatBook.JXVZPerceivedBaseAmount := tempJXVZSalesVatBook.JXVZPerceivedBaseAmount * -1;
                tempJXVZSalesVatBook.JXVZPerceivedTaxAmount := tempJXVZSalesVatBook.JXVZPerceivedTaxAmount * -1;
                tempJXVZSalesVatBook.JXVZPerceivedTaxRate := tempJXVZSalesVatBook.JXVZPerceivedTaxRate * -1;
                tempJXVZSalesVatBook.JXVZVatAmount := tempJXVZSalesVatBook.JXVZVatAmount * -1;
                tempJXVZSalesVatBook.JXVZBaseAmount := tempJXVZSalesVatBook.JXVZBaseAmount * -1;
                tempJXVZSalesVatBook."JXVZVAT%" := tempJXVZSalesVatBook."JXVZVAT%" * -1;

                TotalLine(tempJXVZSalesVatBook);

                tempJXVZSalesVatBook.Insert();
            end;
        }
        dataitem("Sales Debit Memo"; "Sales Invoice Header")
        {
            DataItemTableView = sorting("No.") order(ascending);
            trigger OnPreDataItem()
            begin
                "Sales Debit Memo".SetRange("Posting Date", FromDate, ToDate);
                "Sales Debit Memo".setRange(JXVZInvoiceType, JXVZInvoiceType::DebitMemo);
            end;

            trigger OnAfterGetRecord()
            var
                customer: Record customer;
                SalesInvLine: Record "Sales Invoice Line";
                VatProdPostingGroup: Record "VAT Product Posting Group";
            begin
                "Sales Debit Memo".CalcFields("Amount Including VAT");
                "Sales Debit Memo".CalcFields(Amount);
                tempJXVZSalesVatBook.Init();
                ReportKey += 1;
                tempJXVZSalesVatBook.JXVZKey := ReportKey;
                tempJXVZSalesVatBook.JXVZPostingDate := Format("Sales Debit Memo"."Posting Date", 0, '<Day,2>/<Month,2>/<Year>');
                tempJXVZSalesVatBook.JXVZInvoiceNumber := "Sales Debit Memo"."No.";

                //tempJXVZSalesVatBook.JXVZvatRetenNo := "Sales Debit Memo".JXVZVATRetentionNo;
                //tempJXVZSalesVatBook.JXVZVATRetention := "Sales Debit Memo".JXVZVATRetention;
                //tempJXVZSalesVatBook.JXVZEmissionDate := "Sales Debit Memo".JXVZEmissionDate;
                //tempJXVZSalesVatBook.JXVZReceptionDate := "Sales Debit Memo".JXVZReceptionDate;
                tempJXVZSalesVatBook.JXVZControlNumber := "Sales Debit Memo".JXVZCtrlDocumentNo;

                //tempJXVZSalesVatBook.JXVZExportTemplateNo := "Sales Debit Memo".JXVZExportTemplateNo;
                if customer.get("Sales Debit Memo"."Bill-to Customer No.") then;
                //tempJXVZSalesVatBook.JXVZFOBValue := "Sales Debit Memo".JXVZFOBValue;                
                tempJXVZSalesVatBook.JXVZTransactionType := Format(JXVZDocTypeLVE::Reg);

                SalesInvLine.Reset();
                SalesInvLine.SetRange("Document No.", "Sales Invoice Header"."No.");
                if SalesInvLine.FindSet() then
                    repeat
                        VatProdPostingGroup.Reset();
                        VatProdPostingGroup.SetRange(Code, SalesInvLine."VAT Prod. Posting Group");
                        if VatProdPostingGroup.FindFirst() then begin
                            case VatProdPostingGroup.JXVZVatPurchReport of
                                VatProdPostingGroup.JXVZVatPurchReport::Exento:
                                    tempJXVZSalesVatBook.JXVZSalesExempt += SalesInvLine."Amount Including VAT";

                                VatProdPostingGroup.JXVZVatPurchReport::Exonerado:
                                    tempJXVZSalesVatBook.JXVZSalesExonerated += SalesInvLine."Amount Including VAT";

                                VatProdPostingGroup.JXVZVatPurchReport::Tercero:
                                    tempJXVZSalesVatBook.JXVZSalesThirdParty += SalesInvLine."Amount Including VAT";
                            end;
                        end;
                    until SalesInvLine.Next() = 0;

                //Initial values
                tempJXVZSalesVatBook.JXVZGeneralTaxBase := 0;
                tempJXVZSalesVatBook.JXVZGeneralTaxAmount := 0;
                tempJXVZSalesVatBook.JXVZGeneralTaxRate := 0;
                tempJXVZSalesVatBook.JXVZPerceivedBaseAmount := 0;
                tempJXVZSalesVatBook.JXVZPerceivedTaxAmount := 0;
                tempJXVZSalesVatBook.JXVZPerceivedTaxRate := 0;
                tempJXVZSalesVatBook.JXVZVatAmount := 0;
                tempJXVZSalesVatBook.JXVZBaseAmount := 0;
                tempJXVZSalesVatBook."JXVZVAT%" := 0;

                SetVATEntry("Sales Debit Memo"."No.", Customer."No.", tempJXVZSalesVatBook);

                if ("Sales Debit Memo"."Currency Code" <> '') then begin
                    tempJXVZSalesVatBook.JXVZTotalAmountVAT := Abs("Sales Debit Memo"."Amount Including VAT") / "Sales Debit Memo"."Currency Factor";
                end else begin
                    tempJXVZSalesVatBook.JXVZTotalAmountVAT := Abs("Sales Debit Memo"."Amount Including VAT");
                end;

                setCustomer(tempJXVZSalesVatBook, "Sales Debit Memo"."Bill-to Customer No.");
                TotalLine(tempJXVZSalesVatBook);

                tempJXVZSalesVatBook.Insert();

            end;
        }
        dataitem(Temp; Integer)
        {
            DataItemTableView = sorting(Number) order(ascending);

            column(Comprobante; tempJXVZSalesVatBook.JXVZKey)
            { }
            column(PostingDate; tempJXVZSalesVatBook.JXVZPostingDate)
            { }
            column(VATRegistrationNo; tempJXVZSalesVatBook.JXVZVATRegistrationNo)
            { }
            column(LegalName; tempJXVZSalesVatBook.JXVZLegalName)
            { }
            column(VatRetenNo; tempJXVZSalesVatBook.JXVZVatRetenNo)
            { }
            column(EmissionDate; tempJXVZSalesVatBook.JXVZemissionDate)
            { }
            column(ReceptionDate; tempJXVZSalesVatBook.JXVZReceptionDate)
            { }
            column(ImportTemplateNo; tempJXVZSalesVatBook.JXVZImportTemplateNo)
            { }
            column(ImportFileNo; tempJXVZSalesVatBook.JXVZImportFileNo)
            { }
            column(InvoiceNumber; tempJXVZSalesVatBook.JXVZInvoiceNumber)
            { }
            column(ControlNumber; tempJXVZSalesVatBook.JXVZControlNumber)
            { }
            column(DebitMemoNo; tempJXVZSalesVatBook.JXVZDebitMemoNo)
            { }
            column(CreditMemoNo; tempJXVZSalesVatBook.JXVZCreditMemoNo)
            { }
            column(AffectedDocNo; tempJXVZSalesVatBook.JXVZAffectedDocNo)
            { }
            column(TotalAmountVAT; tempJXVZSalesVatBook.JXVZTotalAmountVAT)
            { }
            column(BaseAmount; tempJXVZSalesVatBook.JXVZBaseAmount)
            { }
            column(VAT; tempJXVZSalesVatBook."JXVZVAT%")
            { }
            column(VatAmount; tempJXVZSalesVatBook.JXVZVatAmount)
            { }
            column(VATRetention; tempJXVZSalesVatBook.JXVZVATRetention)
            { }
            column(ExportTemplateNo; tempJXVZSalesVatBook.JXVZExportTemplateNo)
            { }
            column(FOBValue; tempJXVZSalesVatBook.JXVZFOBValue)
            { }
            column(SalesThirdParty; tempJXVZSalesVatBook.JXVZSalesThirdParty)
            { }
            column(SalesExempt; tempJXVZSalesVatBook.JXVZSalesExempt)
            { }
            column(SalesExonerated; tempJXVZSalesVatBook.JXVZSalesExonerated)
            { }
            column(VATRetainedBuyer; tempJXVZSalesVatBook.JXVZVATRetainedBuyer)
            { }
            column(VATPerceived; tempJXVZSalesVatBook.JXVZVATPerceived)
            { }
            column(PerceivedBaseAmount; tempJXVZSalesVatBook.JXVZPerceivedBaseAmount)
            { }
            column(PerceivedTaxRate; tempJXVZSalesVatBook.JXVZPerceivedTaxRate)
            { }
            column(PerceivedTaxAmount; tempJXVZSalesVatBook.JXVZPerceivedTaxAmount)
            { }
            column(TransaccionType; tempJXVZSalesVatBook.JXVZTransactionType)
            {

            }
            column(GeneralTaxRate; tempJXVZSalesVatBook.JXVZGeneralTaxRate)
            { }
            column(GeneralTaxAmount; tempJXVZSalesVatBook.JXVZGeneralTaxAmount)
            { }
            column(GeneralTaxBase; tempJXVZSalesVatBook.JXVZGeneralTaxBase)
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


            trigger OnPreDataItem()
            begin
                tempJXVZSalesVatBook.Reset();
                SetRange(Number, 1, tempJXVZSalesVatBook.Count());
            end;

            trigger OnAfterGetRecord()
            begin
                if (Number = 1) then
                    tempJXVZSalesVatBook.FindFirst()
                else
                    tempJXVZSalesVatBook.Next();
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


    procedure SetDates(_FromDate: Date; _ToDate: Date)
    begin
        FromDate := _FromDate;
        ToDate := _ToDate;
    end;

    local procedure SetPeriod(pDate: Date): text
    var
        ArrayMonth: array[12] of text[10];
    begin
        ArrayMonth[1] := 'Enero';
        ArrayMonth[2] := 'Febrero';
        ArrayMonth[3] := 'Marzo';
        ArrayMonth[4] := 'Abril';
        ArrayMonth[5] := 'Mayo';
        ArrayMonth[6] := 'Junio';
        ArrayMonth[7] := 'Julio';
        ArrayMonth[8] := 'Agosto';
        ArrayMonth[9] := 'Septiembre';
        ArrayMonth[10] := 'Octubre';
        ArrayMonth[11] := 'Noviembre';
        ArrayMonth[12] := 'Diciembre';

        exit(StrSubstNo('%1 - %2', ArrayMonth[Date2DMY(pDate, 2)], Date2DMY(pDate, 3)));
    end;

    local procedure SetVATEntry(_No: Code[20]; _CustNo: Code[20]; var SalesVatBook: Record JXVZVatBookTemp)
    var
        VATEntry: Record "VAT Entry";
        Customer: Record Customer;
        FiscalType: Record JXVZFiscalType;
        VatProdPostGroup: Record "VAT Product Posting Group";
    begin
        Customer.Reset();
        Customer.SetRange("No.", _CustNo);
        if Customer.FindFirst() then begin
            FiscalType.Reset();
            FiscalType.SetRange("No.", Customer.JXVZFiscalType);
            if FiscalType.FindFirst() then;
        end;

        VATEntry.Reset();
        VATEntry.SetRange(VATEntry."Document No.", _No);
        if VATEntry.FindSet() then
            repeat
                VatProdPostGroup.Reset();
                VatProdPostGroup.SetRange(Code, VATEntry."VAT Prod. Posting Group");
                if VatProdPostGroup.FindFirst() then
                    if (VatProdPostGroup.JXVZVatPurchReport = VatProdPostGroup.JXVZVatPurchReport::Internas) or (VatProdPostGroup.JXVZVatPurchReport = VatProdPostGroup.JXVZVatPurchReport::"Internas Gravadas Aliciota Reducida") then begin
                        case FiscalType.JXVZFiscalType of
                            FiscalType.JXVZFiscalType::EX:
                                begin
                                    SalesVatBook.JXVZGeneralTaxBase += abs(VATEntry.Amount);
                                    SalesVatBook.JXVZGeneralTaxAmount += abs(VATEntry.Base);
                                    if VATEntry.Base <> 0 then
                                        SalesVatBook.JXVZGeneralTaxRate := abs(Round((SalesVatBook.JXVZVatAmount * -100) / SalesVatBook.JXVZBaseAmount, 0.01))
                                    else
                                        SalesVatBook.JXVZGeneralTaxRate := 0;
                                end;

                            FiscalType.JXVZFiscalType::TE:
                                begin
                                    SalesVatBook.JXVZPerceivedBaseAmount += abs(VATEntry.Amount);
                                    SalesVatBook.JXVZPerceivedTaxAmount += abs(VATEntry.Base);
                                    if VATEntry.Base <> 0 then
                                        SalesVatBook.JXVZPerceivedTaxRate := abs(Round((SalesVatBook.JXVZVatAmount * -100) / SalesVatBook.JXVZBaseAmount, 0.01))
                                    else
                                        SalesVatBook.JXVZPerceivedTaxRate := 0;
                                end;

                            else begin
                                SalesVatBook.JXVZVatAmount += abs(VATEntry.Amount);
                                SalesVatBook.JXVZBaseAmount += abs(VATEntry.Base);
                                if VATEntry.Base <> 0 then
                                    SalesVatBook."JXVZVAT%" := abs(Round((SalesVatBook.JXVZVatAmount * -100) / SalesVatBook.JXVZBaseAmount, 0.01))
                                else
                                    SalesVatBook."JXVZVAT%" := 0;
                            end;
                        end;
                    end;
            until VATEntry.Next() = 0;
    end;

    local procedure TotalLine(var
                                  SalesVatBook: Record JXVZVatBookTemp)
    begin
        TotalInvoiceAmountLCY += SalesVatBook.JXVZTotalAmountVAT;
        TotalVAT += SalesVatBook.JXVZVatAmount;
        TotalBaseAmount += SalesVatBook.JXVZBaseAmount;
        TotalVatRetention += SalesVatBook.JXVZVATRetention;
    end;

    local procedure setCustomer(var SalesVatBook: Record JXVZVatBookTemp; _NoCustomer: code[20])
    var
        Customer: Record customer;
    begin
        customer.reset();
        Customer.SetRange("No.", _NoCustomer);
        if customer.FindFirst() then begin
            SalesVatBook.JXVZVATRegistrationNo := Customer."VAT Registration No.";
            SalesVatBook.JXVZLegalName := customer.name;
        end;
    end;


    var
        CompanyInfo: Record "Company Information";
        tempJXVZSalesVatBook: Record JXVZVatBookTemp temporary;
        GenLedgerSetup: Record "General Ledger Setup";
        FromDate: Date;
        ToDate: Date;
        ReportKey: Integer;

        //Lineas totales
        TotalInvoiceAmountLCY: Decimal;
        TotalBaseAmount: Decimal;
        TotalVAT: Decimal;
        TotalVatRetention: Decimal;



}