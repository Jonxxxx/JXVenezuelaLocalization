codeunit 84104 JXVZWithholdings
{
    trigger OnRun()
    begin
    end;

    var
        GenJournalLine: Record "Gen. Journal Line";
        GenJournalLineTmpProcess: Record "Gen. Journal Line" temporary;
        PurchInvLine: Record "Purch. Inv. Line";
        JXVZWithholdAreaLine: Record JXVZWithholdAreaLine;
        JXVZWithholdDetailEntry: Record JXVZWithholdDetailEntry;
        JXVZWithholdCalcLines: Record JXVZWithholdCalcLines;
        PurchInvHeader: Record "Purch. Inv. Header";
        JXVZWithholdScale: Record JXVZWithholdScale;
        JXVZWithholdingTax: Record JXVZWithholdingTax;
        JXVZVendorWithholdCondition: Record JXVZVendorWithholdCondition;
        JXVZWithholdLedgerEntry: Record JXVZWithholdLedgerEntry;
        JXVZVendorExemption: Record JXVZVendorExemption;
        JXVZHistoryPaymOrder: Record JXVZHistoryPaymOrder;
        JXVZHistPaymVoucherLine: Record JXVZHistPaymVoucherLine;
        PurchInvoiceLine: Record "Purch. Inv. Line";
        PurchInvoiceHeader: Record "Purch. Inv. Header";
        PurchCrMemoLine: Record "Purch. Cr. Memo Line";
        PurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.";
        JXVZWithholdCalcDocument: Record JXVZWithholdCalcDocument;
        JXVZWithholdAccumCalc: Record JXVZWithholdAccumCalc;
        JXVZVendorWithholdCondition2: Record JXVZVendorWithholdCondition;
        JXVZWithholdingTax2: Record JXVZWithholdingTax;
        VendorControl: Boolean;
        ConditionCode: Code[20];
        PercentageAmount: Decimal;
        RegistrationDate: Date;
        VendorNro: Code[20];
        AdditionalAmount: Decimal;
        AdditionalControl: Boolean;
        StartPeriod: Date;
        EndPeriod: Date;
        BaseCalculation: Decimal;
        Text004Lbl: Label 'No se definió el período de acumulación para el Impuesto %1, Régimen %2';
        GlobDocumentDate: Date;
        GlobVendor: Code[20];
        GlobPaymentOrderNro: Code[20];

    procedure "#FindInvoices"(var _PaymentOrderNro: Code[20]; var _DocumentDate: Date; var _Vendor: Code[20])
    var
        LocalJXVZWithholdAccumCalc: Record JXVZWithholdAccumCalc;
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        NoSeriesManagement: Codeunit "No. Series";
        LineNo: Integer;
    begin

        "#DeleteTempTables"(_PaymentOrderNro);
        Commit();
        GlobDocumentDate := _DocumentDate;
        GlobVendor := _Vendor;
        GlobPaymentOrderNro := _PaymentOrderNro;

        //Complete tmp process
        GenJournalLineTmpProcess.Reset();
        if GenJournalLineTmpProcess.FindSet() then
            repeat
                GenJournalLineTmpProcess.Delete(false);
            until GenJournalLineTmpProcess.Next() = 0;

        //Applies manual lines
        GenJournalLine.Reset();
        GenJournalLine.SetRange(GenJournalLine."Document No.", _PaymentOrderNro);
        GenJournalLine.SetFilter(GenJournalLine."Applies-to Doc. Type", '<>%1', GenJournalLine."Applies-to Doc. Type"::" ");
        if GenJournalLine.FindSet() then
            repeat
                LineNo += 1000;
                GenJournalLineTmpProcess.Init();
                GenJournalLineTmpProcess.TransferFields(GenJournalLine);
                GenJournalLineTmpProcess."Line No." := LineNo;
                GenJournalLineTmpProcess.Insert(false);
            until GenJournalLine.Next() = 0;
        //Applies manual lines END

        //Applies process lines
        GenJournalLine.Reset();
        GenJournalLine.SetRange("Document No.", _PaymentOrderNro);
        GenJournalLine.SetRange("Account Type", GenJournalLine."Account Type"::Vendor);
        if GenJournalLine.FindFirst() then begin
            VendorLedgerEntry.SetRange("Applies-to ID", _PaymentOrderNro);
            if VendorLedgerEntry.FindSet() then
                repeat
                    LineNo += 1000;
                    GenJournalLineTmpProcess.Init();
                    GenJournalLineTmpProcess.TransferFields(GenJournalLine);
                    GenJournalLineTmpProcess."Applies-to Doc. Type" := VendorLedgerEntry."Document Type";
                    GenJournalLineTmpProcess."Applies-to Doc. No." := VendorLedgerEntry."Document No.";
                    GenJournalLineTmpProcess.Validate("Currency Code", VendorLedgerEntry."Currency Code");
                    GenJournalLineTmpProcess.Validate(Amount, VendorLedgerEntry."Amount to Apply");
                    GenJournalLineTmpProcess."Line No." := LineNo;
                    GenJournalLineTmpProcess.Insert(false);
                until VendorLedgerEntry.Next() = 0;
        end;
        //Applies process lines END
        //Complete tmp process END

        GenJournalLineTmpProcess.Reset();
        GenJournalLineTmpProcess.SetRange(GenJournalLineTmpProcess."Document No.", _PaymentOrderNro);
        GenJournalLineTmpProcess.SetFilter(GenJournalLineTmpProcess."Document Type", '<>%1', GenJournalLineTmpProcess."Document Type"::"Credit Memo");
        GenJournalLineTmpProcess.SetFilter(GenJournalLineTmpProcess."Applies-to Doc. Type", '<>%1', GenJournalLineTmpProcess."Applies-to Doc. Type"::" ");
        if GenJournalLineTmpProcess.FindSet(false, false) then
            repeat
                if Abs(GenJournalLineTmpProcess."Amount (LCY)") <> 0 then
                    PercentageAmount := ((Abs(GenJournalLineTmpProcess."Amount (LCY)") * 100) / Abs(GenJournalLineTmpProcess."Amount (LCY)"))//*-1
                else
                    PercentageAmount := 1;

                JXVZWithholdCalcLines.Reset();
                JXVZWithholdCalcLines.SetRange(JXVZWithholdCalcLines.JXVZPaymentOrderNo, _PaymentOrderNro);
                if (JXVZWithholdCalcLines.FindSet()) then
                    repeat
                        JXVZWithholdCalcLines.JXVZApplyCreditMemo := false;
                        JXVZWithholdCalcLines.Modify();
                    until JXVZWithholdCalcLines.Next() = 0;

                PurchInvLine.Reset();
                PurchInvLine.SetRange("Document No.", GenJournalLineTmpProcess."Applies-to Doc. No.");
                if PurchInvLine.FindSet(false, false) then
                    repeat
                        JXVZWithholdAreaLine.Reset();
                        JXVZWithholdAreaLine.SetRange(JXVZWithholdAreaLine.JXVZWithholdingCode, PurchInvLine.JXVZWithholdingCode);
                        if (JXVZWithholdAreaLine.FindSet()) then
                            repeat
                                JXVZWithholdDetailEntry.Reset();
                                JXVZWithholdDetailEntry.SetRange(JXVZWithholdDetailEntry.JXVZWitholdingNo, JXVZWithholdAreaLine.JXVZWithholdingNo);
                                if JXVZWithholdDetailEntry.FindSet(false, false) then begin
                                    JXVZWithholdingTax.Reset();
                                    JXVZWithholdingTax.SetRange(JXVZWithholdingTax.JXVZTaxCode, JXVZWithholdDetailEntry.JXVZTaxCode);
                                    JXVZWithholdingTax.SetRange(JXVZRetains, true);
                                    if JXVZWithholdingTax.FindFirst() then begin
                                        PurchInvHeader.Reset();
                                        PurchInvHeader.SetRange("No.", GenJournalLineTmpProcess."Applies-to Doc. No.");
                                        if PurchInvHeader.FindFirst() then begin
                                            VendorControl := false;
                                            if (JXVZWithholdingTax.JXVZProvince = '') then
                                                VendorControl := true
                                            else
                                                if (PurchInvHeader.JXVZProvince <> '') and (PurchInvHeader.JXVZProvince = JXVZWithholdingTax.JXVZProvince) then
                                                    VendorControl := true
                                                else
                                                    if PurchInvHeader.JXVZProvince = '' then begin
                                                        JXVZVendorWithholdCondition2.Reset();
                                                        JXVZVendorWithholdCondition2.SetRange(JXVZVendorCode, PurchInvHeader."Buy-from Vendor No.");
                                                        JXVZVendorWithholdCondition2.SetRange(JXVZTaxCode, JXVZWithholdDetailEntry.JXVZTaxCode);
                                                        if JXVZVendorWithholdCondition2.FindFirst() then begin
                                                            JXVZWithholdingTax2.Reset();
                                                            JXVZWithholdingTax2.SetRange(JXVZTaxCode, JXVZVendorWithholdCondition2.JXVZTaxCode);
                                                            if JXVZWithholdingTax2.FindFirst() then
                                                                if JXVZWithholdingTax2.JXVZProvince <> '' then
                                                                    VendorControl := true;
                                                        end;
                                                    end;
                                        end;
                                    end;

                                    JXVZVendorWithholdCondition.Reset();
                                    JXVZVendorWithholdCondition.SetRange(JXVZVendorWithholdCondition.JXVZTaxCode, JXVZWithholdDetailEntry.JXVZTaxCode);
                                    JXVZVendorWithholdCondition.SetRange(JXVZVendorWithholdCondition.JXVZVendorCode, GenJournalLineTmpProcess."Account No.");
                                    if (JXVZVendorWithholdCondition.FindFirst()) then
                                        ConditionCode := JXVZVendorWithholdCondition.JXVZTaxConditionCode;

                                    AdditionalAmount := 0;
                                    AdditionalControl := true;

                                    if VendorControl then begin
                                        JXVZWithholdScale.Reset();
                                        JXVZWithholdScale.SetRange(JXVZWithholdScale.JXVZScaleCode, JXVZWithholdDetailEntry.JXVZScaleCode);
                                        JXVZWithholdScale.SetRange(JXVZWithholdScale.JXVZWitholdingCondition, ConditionCode);
                                        if JXVZWithholdScale.FindFirst() then begin
                                            JXVZWithholdCalcLines.Reset();
                                            JXVZWithholdCalcLines.SetRange(JXVZWithholdCalcLines.JXVZWitholdingNo, JXVZWithholdAreaLine.JXVZWithholdingNo);
                                            JXVZWithholdCalcLines.SetRange(JXVZWithholdCalcLines.JXVZPaymentOrderNo, _PaymentOrderNro);
                                            if not (JXVZWithholdCalcLines.Find('-')) then begin
                                                JXVZWithholdCalcLines.Init();
                                                JXVZWithholdCalcLines.JXVZTaxCode := JXVZWithholdDetailEntry.JXVZTaxCode;
                                                JXVZWithholdCalcLines.JXVZRegime := JXVZWithholdDetailEntry.JXVZRegime;
                                                JXVZWithholdCalcLines.JXVZDescription := JXVZWithholdDetailEntry.JXVZDescription;
                                                JXVZWithholdCalcLines.JXVZBaseWitholdingType := JXVZWithholdDetailEntry.JXVZWitholdingBaseType;
                                                JXVZWithholdCalcLines.JXVZAccumulativeCalculation := JXVZWithholdDetailEntry.JXVZAccumulativeCalculation;
                                                JXVZWithholdCalcLines.JXVZMinimumWitholding := JXVZWithholdDetailEntry.JXVZMinimumWitholding;
                                                JXVZWithholdCalcLines.JXVZScaleCode := JXVZWithholdDetailEntry.JXVZScaleCode;
                                                JXVZWithholdCalcLines.JXVZWitholdingNo := JXVZWithholdDetailEntry.JXVZWitholdingNo;
                                                JXVZWithholdCalcLines.JXVZCalculatedWitholding := 0;
                                                JXVZWithholdCalcLines.JXVZWitholdingCondition := ConditionCode;
                                                JXVZWithholdCalcLines.JXVZPaymentOrderNo := _PaymentOrderNro;
                                                Clear(NoSeriesManagement);
                                                JXVZWithholdDetailEntry.testfield(JXVZSeriescode);
                                                JXVZWithholdCalcLines.JXVZWithholdingNumber := NoSeriesManagement.GetNextNo(JXVZWithholdDetailEntry.JXVZSeriesCode, Today(), true);
                                                JXVZWithholdCalcLines.JXVZPaymentMethodCode := JXVZWithholdDetailEntry.JXVZPaymentMethodCode;
                                                JXVZWithholdCalcLines.JXVZAccountNo := JXVZWithholdDetailEntry.JXVZAccountNo;
                                                JXVZWithholdCalcLines.JXVZDocumentDate := _DocumentDate;
                                                JXVZWithholdCalcLines.JXVZDescription := 'Retención - ' + JXVZWithholdingTax.JXVZDescription;
                                                if JXVZWithholdDetailEntry.JXVZAccumulativeCalculation then
                                                    JXVZWithholdCalcLines.JXVZAccumulationPeriod := JXVZWithholdDetailEntry.JXVZAccumulationPeriod
                                                else
                                                    JXVZWithholdCalcLines.JXVZAccumulationPeriod := JXVZWithholdCalcLines.JXVZAccumulationPeriod::" ";

                                                JXVZWithholdCalcLines.JXVZGeneralWitholdingDescription := JXVZWithholdDetailEntry.JXVZDescription;
                                                JXVZWithholdCalcLines.JXVZDistinctPerDocument := JXVZWithholdDetailEntry.JXVZDiscriminatesPerDocument;
                                                JXVZWithholdCalcLines.JXVZDeterminationPerMonthlyInv := JXVZWithholdDetailEntry.JXVZMonthInvoiceDeter;
                                                JXVZWithholdCalcLines.JXVZMinimumAmountInvPerMonth := JXVZWithholdDetailEntry.JXVZMonthInvoiceMinimunAmt;
                                                JXVZWithholdCalcLines.JXVZWitholdingMode := JXVZWithholdDetailEntry.JXVZWitholdingMode;
                                                JXVZWithholdCalcLines.JXVZAccumulativePayments := JXVZWithholdDetailEntry.JXVZAccumulativePayments;
                                                JXVZWithholdCalcLines.JXVZRetainAllInFirstPayment := JXVZWithholdDetailEntry.JXVZRetainsAllInFirstPayment;
                                                JXVZWithholdCalcLines.JXVZMonotributo := JXVZWithholdDetailEntry.JXVZMonotributo;

                                                JXVZWithholdCalcLines.Insert();
                                            end;

                                            if JXVZWithholdCalcLines.JXVZDistinctPerDocument then
                                                DiscriminaRetencionFACT(JXVZWithholdCalcLines, PurchInvLine)
                                            else
                                                if JXVZWithholdCalcLines.JXVZAccumulativePayments then
                                                    PagoAcumulativoRetencionFACT(JXVZWithholdCalcLines, PurchInvLine)
                                                else
                                                    case JXVZWithholdCalcLines.JXVZBaseWitholdingType of

                                                        JXVZWithholdCalcLines.JXVZBaseWitholdingType::"Sin Impuestos":
                                                            BaseCalculation := PurchInvLine."VAT Base Amount";

                                                        JXVZWithholdCalcLines.JXVZBaseWitholdingType::"Importe Impuestos":
                                                            BaseCalculation := PurchInvLine."Amount Including VAT";

                                                        JXVZWithholdCalcLines.JXVZBaseWitholdingType::"Importe Total":
                                                            BaseCalculation := PurchInvLine."Amount Including VAT";

                                                        JXVZWithholdCalcLines.JXVZBaseWitholdingType::"Total menos IVA-IVA Perc-IIBB":
                                                            BaseCalculation := PurchInvLine.Amount;

                                                        JXVZWithholdCalcLines.JXVZBaseWitholdingType::"Total menos IVA":
                                                            begin
                                                                BaseCalculation := PurchInvLine."Amount Including VAT" -
                                                                                CalcTaxPerLine(PurchInvLine."Tax Area Code", PurchInvLine."Tax Group Code", PurchInvLine."Tax Liable", PurchInvLine."Posting Date",
                                                                                            PurchInvLine.Amount, 0, getExchangeRate(PurchInvLine."Document No."), true, false);
                                                            end;

                                                        JXVZWithholdCalcLines.JXVZBaseWitholdingType::"Total menos IVA menos IVA Percep":
                                                            begin
                                                                BaseCalculation := PurchInvLine."Amount Including VAT" -
                                                                                CalcTaxPerLine(PurchInvLine."Tax Area Code", PurchInvLine."Tax Group Code", PurchInvLine."Tax Liable", PurchInvLine."Posting Date",
                                                                                            PurchInvLine.Amount, 0, getExchangeRate(PurchInvLine."Document No."), true, true);
                                                            end;

                                                        JXVZWithholdCalcLines.JXVZBaseWitholdingType::"Solo IVA":
                                                            begin
                                                                BaseCalculation := CalcTaxPerLine(PurchInvLine."Tax Area Code", PurchInvLine."Tax Group Code", PurchInvLine."Tax Liable", PurchInvLine."Posting Date",
                                                                                            PurchInvLine.Amount, 0, getExchangeRate(PurchInvLine."Document No."), true, false);
                                                            end;
                                                    end;

                                            if (GenJournalLineTmpProcess."Applies-to Doc. Type" = GenJournalLineTmpProcess."Applies-to Doc. Type"::"Credit Memo") then begin
                                                if (GenJournalLineTmpProcess."Currency Factor" <> 0) then
                                                    BaseCalculation := BaseCalculation / GenJournalLineTmpProcess."Currency Factor";
                                                if not (JXVZWithholdCalcLines.JXVZApplyCreditMemo) then
                                                    BaseCalculation := BaseCalculation - FindApplicCreditMemo(PurchInvLine."Document No.", JXVZWithholdAreaLine.JXVZWithholdingCode);
                                                JXVZWithholdCalcLines.JXVZApplyCreditMemo := true;
                                            end else begin
                                                if GenJournalLineTmpProcess."Currency Factor" <> 0 then
                                                    BaseCalculation := BaseCalculation / GenJournalLineTmpProcess."Currency Factor";

                                                if JXVZWithholdCalcLines.JXVZWitholdingMode = JXVZWithholdCalcLines.JXVZWitholdingMode::"Proporcional al pago" then
                                                    BaseCalculation := (BaseCalculation * PercentageAmount) / 100;
                                            end;

                                            JXVZWithholdCalcLines.JXVZAccumulative += BaseCalculation;
                                        end;
                                        JXVZWithholdCalcLines.JXVZBase := JXVZWithholdCalcLines.JXVZAccumulative;
                                        if (JXVZWithholdCalcLines.JXVZPaymentOrderNo <> '') then begin
                                            JXVZWithholdCalcLines.Modify();
                                            FillWitholdLedgerEntryDoc(JXVZWithholdCalcLines, PurchInvHeader."No.", true, 0, PurchInvLine."Line No.", BaseCalculation);
                                        end else begin
                                            if JXVZWithholdCalcLines.Delete() then;
                                            DeleteWitholdLedgerEntryDoc(JXVZWithholdCalcLines.JXVZPaymentOrderNo, PurchInvHeader."No.", 0);
                                        end;
                                    end;
                                end;
                            until JXVZWithholdAreaLine.Next() = 0;
                    until PurchInvLine.Next() = 0;
            until GenJournalLineTmpProcess.Next() = 0;

        GenJournalLineTmpProcess.Reset();
        GenJournalLineTmpProcess.SetRange(GenJournalLineTmpProcess."Document No.", _PaymentOrderNro);
        GenJournalLineTmpProcess.SetRange(GenJournalLineTmpProcess."Applies-to Doc. Type", GenJournalLineTmpProcess."Applies-to Doc. Type"::"Credit Memo");
        if (GenJournalLineTmpProcess.FindSet()) then
            repeat
                if Abs(GenJournalLineTmpProcess."Amount (LCY)") <> 0 then
                    PercentageAmount := ((Abs(GenJournalLineTmpProcess."Amount (LCY)") * 100) / Abs(GenJournalLineTmpProcess."Amount (LCY)"))//*-1;
                else
                    PercentageAmount := 1;

                PurchCrMemoLine.Reset();
                PurchCrMemoLine.SetRange("Document No.", GenJournalLineTmpProcess."Applies-to Doc. No.");
                if PurchCrMemoLine.FindSet() then
                    repeat
                        JXVZWithholdAreaLine.Reset();
                        JXVZWithholdCalcLines.Reset();
                        JXVZWithholdCalcLines.SetRange(JXVZWithholdCalcLines.JXVZPaymentOrderNo, _PaymentOrderNro);
                        if (JXVZWithholdCalcLines.FindSet()) then
                            repeat
                                JXVZWithholdAreaLine.SetRange(JXVZWithholdingNo, JXVZWithholdCalcLines.JXVZWitholdingNo);
                                JXVZWithholdAreaLine.SetRange(JXVZWithholdingCode, PurchCrMemoLine.JXVZWithholdingCode);
                                if JXVZWithholdAreaLine.FindFirst() then begin
                                    //if (JXVZWithholdAreaLine.Get(PurchCrMemoLine.JXVZWithholdingCode, JXVZWithholdCalcLines.JXVZWitholdingNo)) then begin
                                    if not (JXVZWithholdCalcLines.JXVZDistinctPerDocument) then begin
                                        if (JXVZWithholdCalcLines.JXVZAccumulativePayments) then
                                            PagoAcumulativoRetencionNC(JXVZWithholdCalcLines, PurchCrMemoLine)
                                        else
                                            case JXVZWithholdCalcLines.JXVZBaseWitholdingType of
                                                JXVZWithholdCalcLines.JXVZBaseWitholdingType::"Sin Impuestos":
                                                    BaseCalculation := PurchCrMemoLine."VAT Base Amount";

                                                JXVZWithholdCalcLines.JXVZBaseWitholdingType::"Importe Impuestos":
                                                    BaseCalculation := PurchCrMemoLine."Amount Including VAT";

                                                JXVZWithholdCalcLines.JXVZBaseWitholdingType::"Importe Total":
                                                    BaseCalculation := PurchCrMemoLine."Amount Including VAT";

                                                JXVZWithholdCalcLines.JXVZBaseWitholdingType::"Total menos IVA-IVA Perc-IIBB":
                                                    BaseCalculation := PurchCrMemoLine.Amount;

                                                JXVZWithholdCalcLines.JXVZBaseWitholdingType::"Total menos IVA":
                                                    begin
                                                        BaseCalculation := PurchCrMemoLine."Amount Including VAT" -
                                                                        CalcTaxPerLine(PurchCrMemoLine."Tax Area Code", PurchCrMemoLine."Tax Group Code", PurchCrMemoLine."Tax Liable", PurchCrMemoLine."Posting Date",
                                                                                    PurchCrMemoLine.Amount, 0, getExchangeRate(PurchCrMemoLine."Document No."), true, false);
                                                    end;

                                                JXVZWithholdCalcLines.JXVZBaseWitholdingType::"Total menos IVA menos IVA Percep":
                                                    begin
                                                        BaseCalculation := PurchCrMemoLine."Amount Including VAT" -
                                                                        CalcTaxPerLine(PurchCrMemoLine."Tax Area Code", PurchCrMemoLine."Tax Group Code", PurchCrMemoLine."Tax Liable", PurchCrMemoLine."Posting Date",
                                                                                    PurchCrMemoLine.Amount, 0, getExchangeRate(PurchCrMemoLine."Document No."), true, true);
                                                    end;

                                                JXVZWithholdCalcLines.JXVZBaseWitholdingType::"Solo IVA":
                                                    begin
                                                        BaseCalculation := CalcTaxPerLine(PurchCrMemoLine."Tax Area Code", PurchCrMemoLine."Tax Group Code", PurchCrMemoLine."Tax Liable", PurchCrMemoLine."Posting Date",
                                                                                    PurchCrMemoLine.Amount, 0, getExchangeRate(PurchCrMemoLine."Document No."), true, false);
                                                    end;
                                            end;

                                        if GenJournalLineTmpProcess."Currency Factor" <> 0 then
                                            BaseCalculation := BaseCalculation / GenJournalLineTmpProcess."Currency Factor";
                                        if JXVZWithholdCalcLines.JXVZWitholdingMode = JXVZWithholdCalcLines.JXVZWitholdingMode::"Proporcional al pago" then
                                            BaseCalculation := (BaseCalculation * PercentageAmount) / 100;
                                        JXVZWithholdCalcLines.JXVZAccumulative -= BaseCalculation;

                                    end else
                                        DiscriminaRetencionNC(JXVZWithholdCalcLines, PurchCrMemoLine);

                                    JXVZWithholdCalcLines.JXVZBase := JXVZWithholdCalcLines.JXVZAccumulative;
                                    JXVZWithholdCalcLines.Modify();
                                    FillWitholdLedgerEntryDoc(JXVZWithholdCalcLines, PurchCrMemoLine."Document No.", true, 0, PurchCrMemoLine."Line No.", BaseCalculation);
                                end;
                            until JXVZWithholdCalcLines.Next() = 0;
                    until PurchCrMemoLine.Next() = 0;
            until GenJournalLineTmpProcess.Next() = 0;


        "#AcumulatedCalc"();
        "#OneTributeAcumulatedCalc"();

        JXVZWithholdCalcLines.Reset();
        JXVZWithholdCalcLines.SetRange(JXVZWithholdCalcLines.JXVZPaymentOrderNo, _PaymentOrderNro);
        JXVZWithholdCalcLines.SetRange(JXVZWithholdCalcLines.JXVZDistinctPerDocument, false);
        JXVZWithholdCalcLines.SetRange(JXVZWithholdCalcLines.JXVZAccumulativePayments, false);
        if (JXVZWithholdCalcLines.FindFirst()) then
            repeat
                JXVZWithholdScale.Reset();
                JXVZWithholdScale.SetRange(JXVZWithholdScale.JXVZScaleCode, JXVZWithholdCalcLines.JXVZScaleCode);
                JXVZWithholdScale.SetRange(JXVZWithholdScale.JXVZWitholdingCondition, JXVZWithholdCalcLines.JXVZWitholdingCondition);
                JXVZWithholdScale.SetRange(JXVZWithholdScale.JXVZTaxCode, JXVZWithholdCalcLines.JXVZTaxCode);
                if JXVZWithholdScale.FindSet() then
                    repeat
                        if JXVZWithholdScale.JXVZTo = 0 then begin
                            if (JXVZWithholdScale.JXVZFrom <= JXVZWithholdCalcLines.JXVZAccumulative) then begin
                                if JXVZWithholdScale.JXVZMonotributoIVA then
                                    JXVZWithholdCalcLines.JXVZCalculatedWitholding := JXVZWithholdScale.JXVZFixedAmount + ((JXVZWithholdCalcLines.JXVZAccumulative) * (JXVZWithholdScale.JXVZSurplus / 100))
                                else
                                    JXVZWithholdCalcLines.JXVZCalculatedWitholding := JXVZWithholdScale.JXVZFixedAmount + ((JXVZWithholdCalcLines.JXVZAccumulative - JXVZWithholdScale.JXVZBaseAmount) *
                                                                                  (JXVZWithholdScale.JXVZSurplus / 100));

                                JXVZWithholdCalcLines."JXVZWitholding%" := JXVZWithholdScale.JXVZSurplus;
                                JXVZWithholdCalcLines.Modify();
                            end
                        end else
                            if (JXVZWithholdScale.JXVZFrom <= JXVZWithholdCalcLines.JXVZAccumulative) and (JXVZWithholdScale.JXVZTo > JXVZWithholdCalcLines.JXVZAccumulative) then begin
                                if JXVZWithholdScale.JXVZMonotributoIVA then
                                    JXVZWithholdCalcLines.JXVZCalculatedWitholding := JXVZWithholdScale.JXVZFixedAmount + ((JXVZWithholdCalcLines.JXVZAccumulative) * (JXVZWithholdScale.JXVZSurplus / 100))
                                else
                                    JXVZWithholdCalcLines.JXVZCalculatedWitholding := JXVZWithholdScale.JXVZFixedAmount + ((JXVZWithholdCalcLines.JXVZAccumulative - JXVZWithholdScale.JXVZBaseAmount) *
                                                                                  (JXVZWithholdScale.JXVZSurplus / 100));
                                JXVZWithholdCalcLines."JXVZWitholding%" := JXVZWithholdScale.JXVZSurplus;
                                JXVZWithholdCalcLines.Modify();
                            end;

                    until JXVZWithholdScale.Next() = 0;
            until JXVZWithholdCalcLines.Next() = 0;

        JXVZWithholdCalcLines.Reset();
        JXVZWithholdCalcLines.SetRange(JXVZWithholdCalcLines.JXVZPaymentOrderNo, _PaymentOrderNro);
        JXVZWithholdCalcLines.SetRange(JXVZWithholdCalcLines.JXVZDistinctPerDocument, true);
        if JXVZWithholdCalcLines.FindSet() then
            repeat
                JXVZWithholdCalcDocument.Reset();
                JXVZWithholdCalcDocument.SetRange(JXVZWithholdCalcDocument.JXVZPaymentOrderNo, _PaymentOrderNro);
                JXVZWithholdCalcDocument.SetRange(JXVZWithholdCalcDocument.JXVZWitholdingNo, JXVZWithholdCalcLines.JXVZWitholdingNo);
                if (JXVZWithholdCalcDocument.FindSet()) then
                    repeat
                        JXVZWithholdScale.Reset();
                        JXVZWithholdScale.SetRange(JXVZWithholdScale.JXVZScaleCode, JXVZWithholdCalcLines.JXVZScaleCode);
                        JXVZWithholdScale.SetRange(JXVZWithholdScale.JXVZWitholdingCondition, JXVZWithholdCalcLines.JXVZWitholdingCondition);
                        JXVZWithholdScale.SetRange(JXVZWithholdScale.JXVZTaxCode, JXVZWithholdCalcLines.JXVZTaxCode);
                        if JXVZWithholdScale.FindSet() then
                            repeat
                                if JXVZWithholdScale.JXVZTo = 0 then begin
                                    if (JXVZWithholdScale.JXVZFrom <= Abs(JXVZWithholdCalcDocument.JXVZCalculationBase)) then begin
                                        JXVZWithholdCalcDocument.JXVZWitholdingTotalAmount := JXVZWithholdScale.JXVZFixedAmount
                                                                                                  + ((JXVZWithholdCalcDocument.JXVZCalculationBase - JXVZWithholdScale.JXVZBaseAmount) * (JXVZWithholdScale.JXVZSurplus / 100));
                                        JXVZWithholdCalcDocument.Modify();
                                        JXVZWithholdCalcLines."JXVZWitholding%" := JXVZWithholdScale.JXVZSurplus;
                                    end
                                end else
                                    if (JXVZWithholdScale.JXVZFrom <= Abs(JXVZWithholdCalcDocument.JXVZCalculationBase)) and (JXVZWithholdScale.JXVZTo > Abs(JXVZWithholdCalcDocument.JXVZCalculationBase)) then begin
                                        JXVZWithholdCalcDocument.JXVZWitholdingTotalAmount := JXVZWithholdScale.JXVZFixedAmount
                                                                                                  + ((JXVZWithholdCalcDocument.JXVZCalculationBase - JXVZWithholdScale.JXVZBaseAmount) * (JXVZWithholdScale.JXVZSurplus / 100));
                                        JXVZWithholdCalcDocument.Modify();
                                        JXVZWithholdCalcLines."JXVZWitholding%" := JXVZWithholdScale.JXVZSurplus;
                                    end;
                            until JXVZWithholdScale.Next() = 0;


                        JXVZWithholdCalcDocument.JXVZWitholdingAmount := JXVZWithholdCalcDocument.JXVZWitholdingTotalAmount - JXVZWithholdCalcDocument.JXVZAccumulatedWitholdings;
                        JXVZWithholdCalcDocument.Modify();

                        if (JXVZWithholdCalcDocument.JXVZWitholdingTotalAmount * JXVZWithholdCalcDocument.JXVZWitholdingAmount <= 0) or (Abs(JXVZWithholdCalcDocument.JXVZWitholdingAmount) > Abs(JXVZWithholdCalcDocument.JXVZWitholdingTotalAmount)) then
                            JXVZWithholdCalcDocument.Mark(true);
                    until JXVZWithholdCalcDocument.Next() = 0;

                JXVZWithholdCalcDocument.MarkedOnly(true);
                JXVZWithholdCalcDocument.DeleteAll();

                JXVZWithholdCalcLines.CalcFields(JXVZDiscriminatedCalcWitholding, JXVZDiscriminationCalcBase);
                JXVZWithholdCalcLines.JXVZCalculatedWitholding := JXVZWithholdCalcLines.JXVZDiscriminatedCalcWitholding;
                JXVZWithholdCalcLines.JXVZBase := JXVZWithholdCalcLines.JXVZDiscriminationCalcBase;
                JXVZWithholdCalcLines.JXVZAccumulative := JXVZWithholdCalcLines.JXVZDiscriminationCalcBase;
                JXVZWithholdCalcLines.Modify();

            until JXVZWithholdCalcLines.Next() = 0;

        JXVZWithholdCalcLines.Reset();
        JXVZWithholdCalcLines.SetRange(JXVZWithholdCalcLines.JXVZPaymentOrderNo, _PaymentOrderNro);
        JXVZWithholdCalcLines.SetRange(JXVZWithholdCalcLines.JXVZAccumulativePayments, true);
        if JXVZWithholdCalcLines.FindSet() then
            repeat
                JXVZWithholdAccumCalc.Reset();
                JXVZWithholdAccumCalc.SetRange(JXVZPaymentOrderNo, _PaymentOrderNro);
                JXVZWithholdAccumCalc.SetRange(JXVZWitholdingNo, JXVZWithholdCalcLines.JXVZWitholdingNo);
                if (JXVZWithholdCalcLines.JXVZMonotributo) then
                    JXVZWithholdAccumCalc.SetRange(JXVZAccumulativePayments, true);

                if (JXVZWithholdAccumCalc.FindSet()) then
                    JXVZWithholdAccumCalc.CalcSums(JXVZWithholdAccumCalc.JXVZCalculationBase);

                LocalJXVZWithholdAccumCalc.Reset();
                LocalJXVZWithholdAccumCalc.SetRange(JXVZPaymentOrderNo, _PaymentOrderNro);
                LocalJXVZWithholdAccumCalc.SetRange(JXVZWitholdingNo, JXVZWithholdCalcLines.JXVZWitholdingNo);
                LocalJXVZWithholdAccumCalc.SetRange(JXVZAccumulativePayments, true);
                if (LocalJXVZWithholdAccumCalc.FindSet()) then
                    LocalJXVZWithholdAccumCalc.CalcSums(LocalJXVZWithholdAccumCalc.JXVZCalculationBase);

                JXVZWithholdScale.Reset();
                JXVZWithholdScale.SetRange(JXVZWithholdScale.JXVZScaleCode, JXVZWithholdCalcLines.JXVZScaleCode);
                JXVZWithholdScale.SetRange(JXVZWithholdScale.JXVZWitholdingCondition, JXVZWithholdCalcLines.JXVZWitholdingCondition);
                JXVZWithholdScale.SetRange(JXVZWithholdScale.JXVZTaxCode, JXVZWithholdCalcLines.JXVZTaxCode);
                if JXVZWithholdScale.Find('-') then
                    repeat
                        if JXVZWithholdScale.JXVZTo = 0 then begin
                            if (JXVZWithholdScale.JXVZFrom <= JXVZWithholdAccumCalc.JXVZCalculationBase) then begin
                                JXVZWithholdAccumCalc.Reset();
                                JXVZWithholdAccumCalc.SetRange(JXVZPaymentOrderNo, _PaymentOrderNro);
                                JXVZWithholdAccumCalc.SetRange(JXVZWitholdingNo, JXVZWithholdCalcLines.JXVZWitholdingNo);
                                JXVZWithholdAccumCalc.SetRange(JXVZWithholdAccumCalc.JXVZAccumulativePayments, false);
                                if (JXVZWithholdAccumCalc.FindSet()) then
                                    JXVZWithholdAccumCalc.CalcSums(JXVZWithholdAccumCalc.JXVZCalculationBase);

                                JXVZWithholdCalcLines.JXVZCalculatedWitholding := JXVZWithholdScale.JXVZFixedAmount + ((JXVZWithholdAccumCalc.JXVZCalculationBase - JXVZWithholdScale.JXVZBaseAmount)
                                                                                  * (JXVZWithholdScale.JXVZSurplus / 100));
                                JXVZWithholdCalcLines."JXVZWitholding%" := JXVZWithholdScale.JXVZSurplus;
                                JXVZWithholdCalcLines.Modify();
                            end
                        end else
                            if (JXVZWithholdScale.JXVZFrom <= JXVZWithholdAccumCalc.JXVZCalculationBase) and (JXVZWithholdScale.JXVZTo > JXVZWithholdAccumCalc.JXVZCalculationBase) then begin
                                if (JXVZWithholdScale.JXVZFixedAmount <> 0) and (JXVZWithholdScale.JXVZSurplus <> 0) then begin
                                    JXVZWithholdAccumCalc.Reset();
                                    JXVZWithholdAccumCalc.SetRange(JXVZPaymentOrderNo, _PaymentOrderNro);
                                    JXVZWithholdAccumCalc.SetRange(JXVZWitholdingNo, JXVZWithholdCalcLines.JXVZWitholdingNo);
                                    JXVZWithholdAccumCalc.SetRange(JXVZWithholdAccumCalc.JXVZAccumulativePayments, false);
                                    if (JXVZWithholdAccumCalc.FindSet()) then
                                        JXVZWithholdAccumCalc.CalcSums(JXVZWithholdAccumCalc.JXVZCalculationBase);
                                end;
                                JXVZWithholdCalcLines.JXVZCalculatedWitholding := JXVZWithholdScale.JXVZFixedAmount + ((JXVZWithholdAccumCalc.JXVZCalculationBase - JXVZWithholdScale.JXVZBaseAmount)
                                                                                  * (JXVZWithholdScale.JXVZSurplus / 100));
                                JXVZWithholdCalcLines."JXVZWitholding%" := JXVZWithholdScale.JXVZSurplus;
                                JXVZWithholdCalcLines.Modify();
                            end;

                    until JXVZWithholdScale.Next() = 0;

                JXVZWithholdCalcLines.JXVZPreviousPayments := LocalJXVZWithholdAccumCalc.JXVZCalculationBase;
                JXVZWithholdCalcLines.JXVZBase := JXVZWithholdAccumCalc.JXVZCalculationBase;
                JXVZWithholdCalcLines.JXVZAccumulative := JXVZWithholdAccumCalc.JXVZCalculationBase;
                JXVZWithholdCalcLines.Modify();
            until JXVZWithholdCalcLines.Next() = 0;

        JXVZWithholdCalcLines.Reset();
        JXVZWithholdCalcLines.SetRange(JXVZWithholdCalcLines.JXVZPaymentOrderNo, _PaymentOrderNro);
        if JXVZWithholdCalcLines.FindSet() then
            repeat
                JXVZVendorExemption.Reset();
                JXVZVendorExemption.SetRange(JXVZVendorCode, _Vendor);
                JXVZVendorExemption.SetRange(JXVZTaxCode, JXVZWithholdCalcLines.JXVZTaxCode);
                JXVZVendorExemption.SetRange(JXVZRegime, JXVZWithholdCalcLines.JXVZRegime);
                if JXVZVendorExemption.FindSet() then
                    repeat
                        if (JXVZVendorExemption.JXVZFromDate <= _DocumentDate) and (JXVZVendorExemption.JXVZToDate >= _DocumentDate) then begin
                            JXVZWithholdCalcLines.JXVZCalculatedWitholding := JXVZWithholdCalcLines.JXVZCalculatedWitholding - ((JXVZWithholdCalcLines.JXVZCalculatedWitholding * JXVZVendorExemption.JXVZExemptionPercent) / 100);
                            JXVZWithholdCalcLines."JXVZExemption%" := JXVZVendorExemption.JXVZExemptionPercent;
                            JXVZWithholdCalcLines.JXVZCertificateDate := JXVZVendorExemption.JXVZCertificateDate;
                            JXVZWithholdCalcLines.Modify();
                        end;
                    until JXVZVendorExemption.Next() = 0;

            until JXVZWithholdCalcLines.Next() = 0;

        JXVZWithholdCalcLines.Reset();
        JXVZWithholdCalcLines.SetRange(JXVZWithholdCalcLines.JXVZPaymentOrderNo, _PaymentOrderNro);
        if JXVZWithholdCalcLines.FindSet() then
            repeat
                if JXVZWithholdCalcLines.JXVZAccumulativeCalculation then
                    if not (JXVZWithholdCalcLines.JXVZAccumulativePayments) then begin
                        JXVZWithholdCalcLines.JXVZPreviousWitholdings := JXVZWithholdCalcLines.JXVZMothlyWitholding;
                        JXVZWithholdCalcLines.JXVZCalculatedWitholding := JXVZWithholdCalcLines.JXVZCalculatedWitholding - JXVZWithholdCalcLines.JXVZMothlyWitholding;
                        JXVZWithholdCalcLines.Modify();
                    end else begin
                        JXVZWithholdCalcLines.JXVZPreviousWitholdings := JXVZWithholdCalcLines.JXVZMothlyWitholding;
                        JXVZWithholdCalcLines.Modify();
                    end;

            until JXVZWithholdCalcLines.Next() = 0;

        AjustaRetenciones(_PaymentOrderNro);

        JXVZWithholdCalcLines.SetRange(JXVZDistinctPerDocument, false);
        JXVZWithholdCalcLines.SetRange(JXVZAccumulativePayments, true);
        if JXVZWithholdCalcLines.FindFirst() then
            repeat
                JXVZWithholdAccumCalc.Reset();
                JXVZWithholdAccumCalc.SetRange(JXVZPaymentOrderNo, JXVZWithholdCalcLines.JXVZPaymentOrderNo);
                JXVZWithholdAccumCalc.SetRange(JXVZWitholdingNo, JXVZWithholdCalcLines.JXVZWitholdingNo);
                if not (JXVZWithholdAccumCalc.FindSet()) then
                    JXVZWithholdCalcLines.Delete(true);
                if (JXVZWithholdCalcLines.JXVZCalculatedWitholding = 0) then
                    if (JXVZWithholdCalcLines.Delete(true)) then;
            until JXVZWithholdCalcLines.Next() = 0;


        JXVZWithholdCalcLines.Reset();
        JXVZWithholdCalcLines.SetRange(JXVZWithholdCalcLines.JXVZPaymentOrderNo, _PaymentOrderNro);
        JXVZWithholdCalcLines.SetRange(JXVZDistinctPerDocument, false);
        JXVZWithholdCalcLines.SetRange(JXVZAccumulativePayments, false);
        if JXVZWithholdCalcLines.Find('-') then
            repeat
                if (JXVZWithholdCalcLines.JXVZCalculatedWitholding < JXVZWithholdCalcLines.JXVZMinimumWitholding) or (JXVZWithholdCalcLines.JXVZCalculatedWitholding = 0) then
                    JXVZWithholdCalcLines.Delete(true);

                if JXVZWithholdCalcLines.JXVZAccumulative < JXVZWithholdCalcLines.JXVZMinimumAmountInvPerMonth then
                    if (JXVZWithholdCalcLines.Delete(true)) then;
            until JXVZWithholdCalcLines.Next() = 0;


        JXVZWithholdCalcLines.SetRange(JXVZDistinctPerDocument, true);
        JXVZWithholdCalcLines.SetRange(JXVZAccumulativePayments, false);
        if JXVZWithholdCalcLines.Find('-') then begin
            JXVZWithholdCalcDocument.Reset();
            JXVZWithholdCalcDocument.SetRange(JXVZPaymentOrderNo, JXVZWithholdCalcLines.JXVZPaymentOrderNo);
            repeat
                JXVZWithholdCalcDocument.SetRange(JXVZWitholdingNo, JXVZWithholdCalcLines.JXVZWitholdingNo);
                if not (JXVZWithholdCalcDocument.FindSet()) then
                    JXVZWithholdCalcLines.Delete(true);
            until JXVZWithholdCalcLines.Next() = 0;
        end;
    end;

    procedure "#AcumulatedCalc"()
    var
        baseToCalc: Decimal;
    begin
        JXVZWithholdCalcLines.Reset();
        JXVZWithholdCalcLines.SetRange(JXVZWithholdCalcLines.JXVZPaymentOrderNo, GlobPaymentOrderNro);
        if JXVZWithholdCalcLines.FindSet() then
            repeat
                if JXVZWithholdCalcLines.JXVZAccumulativeCalculation then begin
                    //if PaymentOrderHeader.Get(GlobPaymentOrderNro) then
                    //    RegistrationDate := PaymentOrderHeader."Posting Date"
                    //else

                    //Comment for error, correct date posting date from GenJournalLine (line of payment)
                    //RegistrationDate := WorkDate();
                    GenJournalLine.TestField("Posting Date");
                    RegistrationDate := GenJournalLine."Posting Date";

                    StartPeriod := 0D;
                    case JXVZWithholdCalcLines.JXVZAccumulationPeriod of
                        JXVZWithholdCalcLines.JXVZAccumulationPeriod::"Mes Calendario":
                            begin
                                StartPeriod := DMY2Date(1, Date2DMY(RegistrationDate, 2), Date2DMY(RegistrationDate, 3));
                                EndPeriod := CalcDate('<CM>', RegistrationDate);
                            end;

                        JXVZWithholdCalcLines.JXVZAccumulationPeriod::"Año Calendario":
                            begin
                                StartPeriod := DMY2Date(1, 1, Date2DMY(RegistrationDate, 3));
                                EndPeriod := CalcDate('<CY>', RegistrationDate);
                            end;

                        JXVZWithholdCalcLines.JXVZAccumulationPeriod::"Año Corrido":
                            begin
                                StartPeriod := CalcDate('<-1Y+1D>', RegistrationDate);
                                EndPeriod := RegistrationDate;
                            end;
                    end;

                    if StartPeriod = 0D then
                        Error(Text004Lbl, JXVZWithholdCalcLines.JXVZTaxCode, JXVZWithholdCalcLines.JXVZRegime);

                    JXVZWithholdLedgerEntry.Reset();
                    JXVZWithholdLedgerEntry.SetCurrentKey(JXVZTaxCode, JXVZVendorCode, JXVZRegime);
                    JXVZWithholdLedgerEntry.SetRange(JXVZWithholdLedgerEntry.JXVZTaxCode, JXVZWithholdCalcLines.JXVZTaxCode);
                    JXVZWithholdLedgerEntry.SetRange(JXVZWithholdLedgerEntry.JXVZVendorCode, GlobVendor);
                    JXVZWithholdLedgerEntry.SetRange(JXVZWithholdLedgerEntry.JXVZRegime, JXVZWithholdCalcLines.JXVZRegime);
                    JXVZWithholdLedgerEntry.SetRange(JXVZWithholdLedgerEntry.JXVZWitholdingDate, StartPeriod, EndPeriod);
                    JXVZWithholdLedgerEntry.CalcSums(JXVZWithholdLedgerEntry.JXVZWitholdingAmount, JXVZWithholdLedgerEntry.JXVZVoucherAmount, JXVZWithholdLedgerEntry.JXVZBase);

                    JXVZWithholdCalcLines.JXVZMothlyWitholding := JXVZWithholdCalcLines.JXVZMothlyWitholding + JXVZWithholdLedgerEntry.JXVZWitholdingAmount;

                    JXVZHistoryPaymOrder.Reset();
                    JXVZHistoryPaymOrder.SetRange(JXVZHistoryPaymOrder.JXVZPostingDate, StartPeriod, EndPeriod);
                    JXVZHistoryPaymOrder.SetRange(JXVZHistoryPaymOrder.JXVZVendorNo, GlobVendor);
                    //Only post and not cancelled hist paym orders
                    JXVZHistoryPaymOrder.SetRange(JXVZStatus, JXVZHistoryPaymOrder.JXVZStatus::Registered);
                    if (JXVZHistoryPaymOrder.FindSet()) then
                        repeat
                            JXVZHistPaymVoucherLine.Reset();
                            JXVZHistPaymVoucherLine.SetRange(JXVZHistPaymVoucherLine.JXVZPaymentOrderNo, JXVZHistoryPaymOrder.JXVZNo);
                            if (JXVZHistPaymVoucherLine.FindSet()) then
                                repeat
                                    PurchInvoiceHeader.Reset();
                                    PurchInvoiceHeader.SetRange(PurchInvoiceHeader."No.", JXVZHistPaymVoucherLine.JXVZVoucherNo);
                                    if PurchInvoiceHeader.Find('-') then
                                        PurchInvoiceHeader.CalcFields(PurchInvoiceHeader."Amount Including VAT");

                                    //Add for prevent an error if amount including vat is 0
                                    if PurchInvoiceHeader."Amount Including VAT" <> 0 then begin
                                        if JXVZHistPaymVoucherLine.JXVZCurrencyFactor <> 0 then
                                            PercentageAmount := ((JXVZHistPaymVoucherLine.JXVZCancelledAmount / JXVZHistPaymVoucherLine.JXVZCurrencyFactor) * 100) /
                                                      (PurchInvoiceHeader."Amount Including VAT" / JXVZHistPaymVoucherLine.JXVZCurrencyFactor)
                                        else
                                            PercentageAmount := (JXVZHistPaymVoucherLine.JXVZCancelledAmount * 100) / PurchInvoiceHeader."Amount Including VAT";
                                    end;

                                    if (JXVZHistPaymVoucherLine.JXVZApplyingCreditMemoExists) then
                                        PercentageAmount := 100;

                                    PurchInvoiceLine.Reset();
                                    PurchInvoiceLine.SetRange(PurchInvoiceLine."Document No.", JXVZHistPaymVoucherLine.JXVZVoucherNo);
                                    if PurchInvoiceLine.FindSet(false, false) then
                                        repeat
                                            JXVZWithholdAreaLine.Reset();
                                            JXVZWithholdAreaLine.SetRange(JXVZWithholdingNo, JXVZWithholdCalcLines.JXVZWitholdingNo);
                                            JXVZWithholdAreaLine.SetRange(JXVZWithholdingCode, PurchInvoiceLine.JXVZWithholdingCode);
                                            if JXVZWithholdAreaLine.FindFirst() then
                                                case JXVZWithholdCalcLines.JXVZBaseWitholdingType of

                                                    JXVZWithholdCalcLines.JXVZBaseWitholdingType::"Sin Impuestos":

                                                        if PurchInvoiceHeader.Get(PurchInvoiceLine."Document No.") then
                                                            if PurchInvoiceHeader."Currency Factor" <> 0 then begin
                                                                if (JXVZWithholdCalcLines.JXVZRetainAllInFirstPayment) then begin
                                                                    JXVZWithholdCalcLines.JXVZAccumulative += ((100 * (PurchInvoiceLine."VAT Base Amount" / PurchInvoiceHeader."Currency Factor")) / 100)
                                                                                                          - (FindApplicCreditMemo2(PurchInvoiceLine."Document No.", JXVZWithholdAreaLine.JXVZWithholdingCode));

                                                                    JXVZWithholdCalcLines.JXVZPreviousPayments += ((100 * (PurchInvoiceLine."VAT Base Amount" / PurchInvoiceHeader."Currency Factor")) / 100)
                                                                                                                  - (FindApplicCreditMemo2(PurchInvoiceLine."Document No.", JXVZWithholdAreaLine.JXVZWithholdingCode));
                                                                end else begin
                                                                    JXVZWithholdCalcLines.JXVZPreviousPayments += ((PercentageAmount * (PurchInvoiceLine."VAT Base Amount" / PurchInvoiceHeader."Currency Factor")) / 100)
                                                                                                                - (FindApplicCreditMemo2(PurchInvoiceLine."Document No.", JXVZWithholdAreaLine.JXVZWithholdingCode));
                                                                    JXVZWithholdCalcLines.JXVZAccumulative += ((PercentageAmount * (PurchInvoiceLine."VAT Base Amount" / PurchInvoiceHeader."Currency Factor")) / 100)
                                                                                                          - (FindApplicCreditMemo2(PurchInvoiceLine."Document No.", JXVZWithholdAreaLine.JXVZWithholdingCode));
                                                                end;

                                                                if (JXVZWithholdCalcLines.JXVZAccumulativePayments) then
                                                                    CargaDocPagoAcumulativo(JXVZWithholdCalcLines, PurchInvoiceHeader."Posting Date", PurchInvoiceLine."Document No.", '3',
                                                                                            ((PercentageAmount * (PurchInvoiceLine."VAT Base Amount" / PurchInvoiceHeader."Currency Factor")) / 100)
                                                                                            - (FindApplicCreditMemo2(PurchInvoiceLine."Document No.", JXVZWithholdAreaLine.JXVZWithholdingCode)), PurchInvoiceLine."Line No.");

                                                            end else begin
                                                                if (JXVZWithholdCalcLines.JXVZRetainAllInFirstPayment) then begin
                                                                    JXVZWithholdCalcLines.JXVZPreviousPayments += ((100 * PurchInvoiceLine."VAT Base Amount") / 100)
                                                                                                                  - (FindApplicCreditMemo2(PurchInvoiceLine."Document No.", JXVZWithholdAreaLine.JXVZWithholdingCode));
                                                                    JXVZWithholdCalcLines.JXVZAccumulative += ((100 * PurchInvoiceLine."VAT Base Amount") / 100)
                                                                                                          - (FindApplicCreditMemo2(PurchInvoiceLine."Document No.", JXVZWithholdAreaLine.JXVZWithholdingCode));
                                                                end else begin
                                                                    JXVZWithholdCalcLines.JXVZPreviousPayments += ((PercentageAmount * PurchInvoiceLine."VAT Base Amount") / 100)
                                                                                                                  - (FindApplicCreditMemo2(PurchInvoiceLine."Document No.",
                                                                                                                    JXVZWithholdAreaLine.JXVZWithholdingCode));
                                                                    JXVZWithholdCalcLines.JXVZAccumulative += ((PercentageAmount * PurchInvoiceLine."VAT Base Amount") / 100)
                                                                                                          - (FindApplicCreditMemo2(PurchInvoiceLine."Document No.",
                                                                                                            JXVZWithholdAreaLine.JXVZWithholdingCode));
                                                                end;

                                                                if (JXVZWithholdCalcLines.JXVZAccumulativePayments) then
                                                                    CargaDocPagoAcumulativo(JXVZWithholdCalcLines, PurchInvoiceHeader."Posting Date", PurchInvoiceLine."Document No.", '3',
                                                                                            ((PercentageAmount * PurchInvoiceLine."VAT Base Amount") / 100)
                                                                                              - (FindApplicCreditMemo2(PurchInvoiceLine."Document No.", JXVZWithholdAreaLine.JXVZWithholdingCode)), PurchInvoiceLine."Line No.");

                                                            end;

                                                    JXVZWithholdCalcLines.JXVZBaseWitholdingType::"Importe Impuestos":
                                                        if PurchInvoiceHeader.Get(PurchInvoiceLine."Document No.") then
                                                            if PurchInvoiceHeader."Currency Factor" <> 0 then
                                                                JXVZWithholdCalcLines.JXVZAccumulative += ((PercentageAmount *
                                                                      ((PurchInvoiceLine."Amount Including VAT" / PurchInvoiceHeader."Currency Factor")
                                                                                    - (PurchInvoiceLine."VAT Base Amount" / GenJournalLineTmpProcess."Currency Factor"))) / 100)
                                                            else
                                                                JXVZWithholdCalcLines.JXVZAccumulative += ((PercentageAmount * (PurchInvoiceLine."Amount Including VAT"
                                                                                                     - PurchInvoiceLine."VAT Base Amount")) / 100);


                                                    JXVZWithholdCalcLines.JXVZBaseWitholdingType::"Importe Total":
                                                        if PurchInvoiceHeader.Get(PurchInvoiceLine."Document No.") then
                                                            if PurchInvoiceHeader."Currency Factor" <> 0 then
                                                                JXVZWithholdCalcLines.JXVZAccumulative += ((PercentageAmount
                                                                      * (PurchInvoiceLine."Amount Including VAT" / PurchInvoiceHeader."Currency Factor")) / 100)
                                                            else
                                                                JXVZWithholdCalcLines.JXVZAccumulative += ((PercentageAmount * PurchInvoiceLine."Amount Including VAT") / 100);


                                                    JXVZWithholdCalcLines.JXVZBaseWitholdingType::"Total menos IVA-IVA Perc-IIBB":
                                                        if PurchInvoiceHeader.Get(PurchInvoiceLine."Document No.") then
                                                            if PurchInvoiceHeader."Currency Factor" <> 0 then
                                                                JXVZWithholdCalcLines.JXVZAccumulative += ((PercentageAmount *
                                                                    (PurchInvoiceLine.Amount / JXVZHistPaymVoucherLine.JXVZCurrencyFactor)) / 100)
                                                            else
                                                                JXVZWithholdCalcLines.JXVZAccumulative += ((PercentageAmount * PurchInvoiceLine.Amount) / 100);

                                                    JXVZWithholdCalcLines.JXVZBaseWitholdingType::"Total menos IVA":
                                                        begin
                                                            baseToCalc := PurchInvLine."Amount Including VAT" -
                                                                            CalcTaxPerLine(PurchInvLine."Tax Area Code", PurchInvLine."Tax Group Code", PurchInvLine."Tax Liable", PurchInvLine."Posting Date",
                                                                                        PurchInvLine.Amount, 0, getExchangeRate(PurchInvLine."Document No."), true, false);

                                                            if PurchInvoiceHeader.Get(PurchInvoiceLine."Document No.") then
                                                                if PurchInvoiceHeader."Currency Factor" <> 0 then
                                                                    JXVZWithholdCalcLines.JXVZAccumulative += ((PercentageAmount *
                                                                        (baseToCalc / JXVZHistPaymVoucherLine.JXVZCurrencyFactor)) / 100)
                                                                else
                                                                    JXVZWithholdCalcLines.JXVZAccumulative += ((PercentageAmount * baseToCalc) / 100);
                                                        end;

                                                    JXVZWithholdCalcLines.JXVZBaseWitholdingType::"Total menos IVA menos IVA Percep":
                                                        begin
                                                            baseToCalc := PurchInvLine."Amount Including VAT" -
                                                                            CalcTaxPerLine(PurchInvLine."Tax Area Code", PurchInvLine."Tax Group Code", PurchInvLine."Tax Liable", PurchInvLine."Posting Date",
                                                                                        PurchInvLine.Amount, 0, getExchangeRate(PurchInvLine."Document No."), true, true);

                                                            if PurchInvoiceHeader.Get(PurchInvoiceLine."Document No.") then
                                                                if PurchInvoiceHeader."Currency Factor" <> 0 then
                                                                    JXVZWithholdCalcLines.JXVZAccumulative += ((PercentageAmount *
                                                                        (baseToCalc / JXVZHistPaymVoucherLine.JXVZCurrencyFactor)) / 100)
                                                                else
                                                                    JXVZWithholdCalcLines.JXVZAccumulative += ((PercentageAmount * baseToCalc) / 100);
                                                        end;

                                                    JXVZWithholdCalcLines.JXVZBaseWitholdingType::"Solo IVA":
                                                        begin
                                                            baseToCalc := CalcTaxPerLine(PurchInvLine."Tax Area Code", PurchInvLine."Tax Group Code", PurchInvLine."Tax Liable", PurchInvLine."Posting Date",
                                                                                        PurchInvLine.Amount, 0, getExchangeRate(PurchInvLine."Document No."), true, false);

                                                            if PurchInvoiceHeader.Get(PurchInvoiceLine."Document No.") then
                                                                if PurchInvoiceHeader."Currency Factor" <> 0 then
                                                                    JXVZWithholdCalcLines.JXVZAccumulative += ((PercentageAmount *
                                                                        (baseToCalc / JXVZHistPaymVoucherLine.JXVZCurrencyFactor)) / 100)
                                                                else
                                                                    JXVZWithholdCalcLines.JXVZAccumulative += ((PercentageAmount * baseToCalc) / 100);
                                                        end;
                                                end;
                                        until PurchInvoiceLine.Next() = 0;


                                    if (JXVZHistPaymVoucherLine.JXVZDocumentType = JXVZHistPaymVoucherLine.JXVZDocumentType::"Nota d/c") then begin
                                        PurchCrMemoHeader.Reset();
                                        PurchCrMemoHeader.SetRange(PurchCrMemoHeader."No.", JXVZHistPaymVoucherLine.JXVZVoucherNo);
                                        if PurchCrMemoHeader.FindFirst() then begin
                                            PurchCrMemoHeader.CalcFields(PurchCrMemoHeader."Amount Including VAT");
                                            if JXVZHistPaymVoucherLine.JXVZCurrencyFactor <> 0 then
                                                PercentageAmount := ((JXVZHistPaymVoucherLine.JXVZCancelledAmount / JXVZHistPaymVoucherLine.JXVZCurrencyFactor) * 100) /
                                                            (PurchCrMemoHeader."Amount Including VAT" / JXVZHistPaymVoucherLine.JXVZCurrencyFactor)
                                            else
                                                PercentageAmount := (JXVZHistPaymVoucherLine.JXVZCancelledAmount * 100) / PurchCrMemoHeader."Amount Including VAT";


                                            PercentageAmount := Abs(PercentageAmount);
                                            PurchCrMemoLine.Reset();
                                            PurchCrMemoLine.SetRange(PurchCrMemoLine."Document No.", JXVZHistPaymVoucherLine.JXVZVoucherNo);
                                            if (PurchCrMemoLine.FindSet()) then
                                                repeat
                                                    JXVZWithholdAreaLine.Reset();
                                                    if JXVZWithholdAreaLine.Get(PurchCrMemoLine.JXVZWithholdingCode, JXVZWithholdCalcLines.JXVZWitholdingNo) then
                                                        case JXVZWithholdCalcLines.JXVZBaseWitholdingType of
                                                            JXVZWithholdCalcLines.JXVZBaseWitholdingType::"Sin Impuestos":

                                                                if PurchCrMemoHeader."Currency Factor" <> 0 then begin
                                                                    if (JXVZWithholdCalcLines.JXVZRetainAllInFirstPayment) then begin
                                                                        JXVZWithholdCalcLines.JXVZAccumulative -= ((100 * (PurchCrMemoLine."VAT Base Amount" / PurchCrMemoHeader."Currency Factor")) / 100);
                                                                        JXVZWithholdCalcLines.JXVZPreviousPayments -= ((100 * (PurchCrMemoLine."VAT Base Amount" / PurchCrMemoHeader."Currency Factor")) / 100);
                                                                    end else begin
                                                                        JXVZWithholdCalcLines.JXVZAccumulative -= ((PercentageAmount * (PurchCrMemoLine."VAT Base Amount" / PurchCrMemoHeader."Currency Factor")) / 100);
                                                                        JXVZWithholdCalcLines.JXVZPreviousPayments -= ((PercentageAmount * (PurchCrMemoLine."VAT Base Amount" / PurchCrMemoHeader."Currency Factor")) / 100);
                                                                    end;
                                                                    if (JXVZWithholdCalcLines.JXVZAccumulativePayments) then
                                                                        CargaDocPagoAcumulativo(JXVZWithholdCalcLines, PurchCrMemoHeader."Posting Date", PurchCrMemoLine."Document No.", '4',
                                                                                                ((PercentageAmount * (PurchCrMemoLine."VAT Base Amount" / PurchCrMemoHeader."Currency Factor")) / 100),
                                                                                                PurchCrMemoLine."Line No.")

                                                                end else begin
                                                                    if (JXVZWithholdCalcLines.JXVZRetainAllInFirstPayment) then begin
                                                                        JXVZWithholdCalcLines.JXVZAccumulative -= ((100 * PurchCrMemoLine."VAT Base Amount") / 100);
                                                                        JXVZWithholdCalcLines.JXVZPreviousPayments -= ((100 * PurchCrMemoLine."VAT Base Amount") / 100);
                                                                    end else begin
                                                                        JXVZWithholdCalcLines.JXVZAccumulative -= ((PercentageAmount * PurchCrMemoLine."VAT Base Amount") / 100);
                                                                        JXVZWithholdCalcLines.JXVZPreviousPayments -= ((PercentageAmount * PurchCrMemoLine."VAT Base Amount") / 100);
                                                                    end;
                                                                    if (JXVZWithholdCalcLines.JXVZAccumulativePayments) then
                                                                        CargaDocPagoAcumulativo(JXVZWithholdCalcLines, PurchCrMemoHeader."Posting Date", PurchCrMemoLine."Document No.", '4',
                                                                                                ((PercentageAmount * PurchCrMemoLine."VAT Base Amount") / 100), PurchCrMemoLine."Line No.")

                                                                end;


                                                            JXVZWithholdCalcLines.JXVZBaseWitholdingType::"Importe Impuestos":

                                                                if GenJournalLineTmpProcess."Currency Factor" <> 0 then
                                                                    JXVZWithholdCalcLines.JXVZAccumulative := ((PercentageAmount * ((PurchCrMemoLine."Amount Including VAT" / GenJournalLineTmpProcess."Currency Factor")
                                                                                                          - (PurchCrMemoLine."VAT Base Amount" / GenJournalLineTmpProcess."Currency Factor"))) / 100)
                                                                                                          + JXVZWithholdCalcLines.JXVZAccumulative
                                                                else
                                                                    JXVZWithholdCalcLines.JXVZAccumulative := ((PercentageAmount * (PurchCrMemoLine."Amount Including VAT"
                                                                                                          - PurchCrMemoLine."VAT Base Amount")) / 100) + JXVZWithholdCalcLines.JXVZAccumulative;



                                                            JXVZWithholdCalcLines.JXVZBaseWitholdingType::"Importe Total":

                                                                if GenJournalLineTmpProcess."Currency Factor" <> 0 then
                                                                    JXVZWithholdCalcLines.JXVZAccumulative := ((PercentageAmount * (PurchCrMemoLine."Amount Including VAT" / GenJournalLineTmpProcess."Currency Factor"))
                                                                                                        / 100) + JXVZWithholdCalcLines.JXVZAccumulative
                                                                else
                                                                    JXVZWithholdCalcLines.JXVZAccumulative := ((PercentageAmount * PurchCrMemoLine."Amount Including VAT") / 100) + JXVZWithholdCalcLines.JXVZAccumulative;



                                                            JXVZWithholdCalcLines.JXVZBaseWitholdingType::"Total menos IVA-IVA Perc-IIBB":
                                                                if GenJournalLineTmpProcess."Currency Factor" <> 0 then
                                                                    JXVZWithholdCalcLines.JXVZAccumulative := ((PercentageAmount * (PurchCrMemoLine.Amount / GenJournalLineTmpProcess."Currency Factor"))
                                                                                                          / 100) + JXVZWithholdCalcLines.JXVZAccumulative
                                                                else
                                                                    JXVZWithholdCalcLines.JXVZAccumulative := ((PercentageAmount * PurchCrMemoLine.Amount) / 100) + JXVZWithholdCalcLines.JXVZAccumulative;

                                                            JXVZWithholdCalcLines.JXVZBaseWitholdingType::"Total menos IVA":
                                                                begin
                                                                    baseToCalc := PurchCrMemoLine."Amount Including VAT" -
                                                                        CalcTaxPerLine(PurchCrMemoLine."Tax Area Code", PurchCrMemoLine."Tax Group Code", PurchCrMemoLine."Tax Liable", PurchCrMemoLine."Posting Date",
                                                                                    PurchCrMemoLine.Amount, 0, getExchangeRate(PurchCrMemoLine."Document No."), true, false);

                                                                    if GenJournalLineTmpProcess."Currency Factor" <> 0 then
                                                                        JXVZWithholdCalcLines.JXVZAccumulative := ((PercentageAmount * (PurchCrMemoLine.Amount / GenJournalLineTmpProcess."Currency Factor"))
                                                                                                              / 100) + JXVZWithholdCalcLines.JXVZAccumulative
                                                                    else
                                                                        JXVZWithholdCalcLines.JXVZAccumulative := ((PercentageAmount * PurchCrMemoLine.Amount) / 100) + JXVZWithholdCalcLines.JXVZAccumulative;
                                                                end;

                                                            JXVZWithholdCalcLines.JXVZBaseWitholdingType::"Total menos IVA menos IVA Percep":
                                                                begin
                                                                    baseToCalc := PurchCrMemoLine."Amount Including VAT" -
                                                                        CalcTaxPerLine(PurchCrMemoLine."Tax Area Code", PurchCrMemoLine."Tax Group Code", PurchCrMemoLine."Tax Liable", PurchCrMemoLine."Posting Date",
                                                                                    PurchCrMemoLine.Amount, 0, getExchangeRate(PurchCrMemoLine."Document No."), true, true);

                                                                    if GenJournalLineTmpProcess."Currency Factor" <> 0 then
                                                                        JXVZWithholdCalcLines.JXVZAccumulative := ((PercentageAmount * (PurchCrMemoLine.Amount / GenJournalLineTmpProcess."Currency Factor"))
                                                                                                              / 100) + JXVZWithholdCalcLines.JXVZAccumulative
                                                                    else
                                                                        JXVZWithholdCalcLines.JXVZAccumulative := ((PercentageAmount * PurchCrMemoLine.Amount) / 100) + JXVZWithholdCalcLines.JXVZAccumulative;
                                                                end;

                                                            JXVZWithholdCalcLines.JXVZBaseWitholdingType::"Solo IVA":
                                                                begin
                                                                    baseToCalc := CalcTaxPerLine(PurchCrMemoLine."Tax Area Code", PurchCrMemoLine."Tax Group Code", PurchCrMemoLine."Tax Liable", PurchCrMemoLine."Posting Date",
                                                                                    PurchCrMemoLine.Amount, 0, getExchangeRate(PurchCrMemoLine."Document No."), true, false);

                                                                    if GenJournalLineTmpProcess."Currency Factor" <> 0 then
                                                                        JXVZWithholdCalcLines.JXVZAccumulative := ((PercentageAmount * (PurchCrMemoLine.Amount / GenJournalLineTmpProcess."Currency Factor"))
                                                                                                              / 100) + JXVZWithholdCalcLines.JXVZAccumulative
                                                                    else
                                                                        JXVZWithholdCalcLines.JXVZAccumulative := ((PercentageAmount * PurchCrMemoLine.Amount) / 100) + JXVZWithholdCalcLines.JXVZAccumulative;
                                                                end;
                                                        end;
                                                until PurchCrMemoLine.Next() = 0;

                                        end;
                                    end;
                                until JXVZHistPaymVoucherLine.Next() = 0;

                        until JXVZHistoryPaymOrder.Next() = 0;

                    JXVZWithholdCalcLines.Modify();
                end;
            until JXVZWithholdCalcLines.Next() = 0;

    end;

    procedure "#OneTributeAcumulatedCalc"()
    var
    begin

        JXVZWithholdCalcLines.Reset();
        JXVZWithholdCalcLines.SetRange(JXVZWithholdCalcLines.JXVZPaymentOrderNo, GlobPaymentOrderNro);
        JXVZWithholdCalcLines.SetRange(JXVZWithholdCalcLines.JXVZMonotributo, true);
        if JXVZWithholdCalcLines.FindSet() then
            repeat
                RegistrationDate := WorkDate();


                StartPeriod := 0D;
                StartPeriod := CalcFechaMonotributo(RegistrationDate);
                EndPeriod := CalcDate('<-1D>', RegistrationDate);

                if StartPeriod = 0D then
                    Error(Text004Lbl, JXVZWithholdCalcLines.JXVZTaxCode, JXVZWithholdCalcLines.JXVZRegime);

                PurchInvoiceHeader.Reset();
                PurchInvoiceHeader.SetFilter(PurchInvoiceHeader."Document Date", '%1..%2', StartPeriod, EndPeriod);
                PurchInvoiceHeader.SetRange(PurchInvoiceHeader."Buy-from Vendor No.", GlobVendor);
                if PurchInvoiceHeader.FindSet() then
                    repeat
                        PurchInvoiceLine.Reset();
                        PurchInvoiceLine.SetRange(PurchInvoiceLine."Document No.", PurchInvoiceHeader."No.");
                        if PurchInvoiceLine.FindSet(false, false) then
                            repeat
                                JXVZWithholdAreaLine.Reset();
                                JXVZWithholdAreaLine.SetRange(JXVZWithholdingNo, JXVZWithholdCalcLines.JXVZWitholdingNo);
                                JXVZWithholdAreaLine.SetRange(JXVZWithholdingCode, PurchInvoiceLine.JXVZWithholdingCode);
                                if JXVZWithholdAreaLine.FindFirst() then
                                    if PurchInvoiceHeader."Currency Factor" <> 0 then
                                        CargaDocPagoAcumulativo(JXVZWithholdCalcLines, PurchInvoiceHeader."Posting Date", PurchInvoiceLine."Document No.", '3',
                                                                ((100 * (PurchInvoiceLine."VAT Base Amount" / PurchInvoiceHeader."Currency Factor")) / 100)
                                                                - FindApplicCreditMemo2(PurchInvoiceLine."Document No.",
                                                                JXVZWithholdAreaLine.JXVZWithholdingCode), PurchInvoiceLine."Line No.")

                                    else
                                        CargaDocPagoAcumulativo(JXVZWithholdCalcLines, PurchInvoiceHeader."Posting Date", PurchInvoiceLine."Document No.", '3',
                                                                ((100 * PurchInvoiceLine."VAT Base Amount") / 100)
                                                                - FindApplicCreditMemo2(PurchInvoiceLine."Document No.",
                                                                JXVZWithholdAreaLine.JXVZWithholdingCode), PurchInvoiceLine."Line No.");


                            until PurchInvoiceLine.Next() = 0;

                    until PurchInvoiceHeader.Next() = 0;


                PurchCrMemoHeader.Reset();
                PurchCrMemoHeader.SetFilter("Document Date", '%1..%2', StartPeriod, EndPeriod);
                PurchCrMemoHeader.SetRange("Buy-from Vendor No.", GlobVendor);
                if PurchCrMemoHeader.FindSet() then
                    repeat
                        PurchCrMemoLine.Reset();
                        PurchCrMemoLine.SetRange(PurchCrMemoLine."Document No.", PurchCrMemoHeader."No.");
                        if (PurchCrMemoLine.FindSet()) then
                            repeat
                                JXVZWithholdAreaLine.Reset();
                                if JXVZWithholdAreaLine.Get(PurchCrMemoLine.JXVZWithholdingCode, JXVZWithholdCalcLines.JXVZWitholdingNo) then
                                    if PurchCrMemoHeader."Currency Factor" <> 0 then
                                        CargaDocPagoAcumulativo(JXVZWithholdCalcLines, PurchCrMemoHeader."Posting Date", PurchCrMemoLine."Document No.", '4',
                                                                ((100 * (PurchCrMemoLine."VAT Base Amount" / PurchCrMemoHeader."Currency Factor")) / 100), PurchCrMemoLine."Line No.")
                                    else
                                        CargaDocPagoAcumulativo(JXVZWithholdCalcLines, PurchCrMemoHeader."Posting Date", PurchCrMemoLine."Document No.", '4',
                                                              ((100 * PurchCrMemoLine."VAT Base Amount") / 100), PurchCrMemoLine."Line No.");

                            until PurchCrMemoLine.Next() = 0;

                    until PurchCrMemoHeader.Next() = 0;

            until JXVZWithholdCalcLines.Next() = 0;

    end;

    procedure "#DeleteTempTables"(var _PaymentOrderNro: Code[20])
    var

    begin
        Clear(JXVZWithholdCalcLines);
        JXVZWithholdCalcLines.Reset();
        JXVZWithholdCalcLines.SetRange(JXVZPaymentOrderNo, _PaymentOrderNro);
        if JXVZWithholdCalcLines.FindSet() then
            repeat
                JXVZWithholdCalcLines.Delete(true);
            until JXVZWithholdCalcLines.Next() = 0;

        GenJournalLine.Reset();
        GenJournalLine.SetRange(GenJournalLine."Document No.", _PaymentOrderNro);
        if GenJournalLine.FindSet() then
            repeat
                if (GenJournalLine.JXVZIsWitholding = true) then
                    GenJournalLine.Delete(true);
            until GenJournalLine.Next() = 0;

        DeleteWitholdLedgerEntryDoc(_PaymentOrderNro, '', 0);
    end;

    local procedure DiscriminaRetencionFACT(_JXVZWithholdCalcLines: Record "JXVZWithholdCalcLines"; _PurchInvLine: Record "Purch. Inv. Line")
    var
        JXVZWithholdCalcDocumentLocal: Record JXVZWithholdCalcDocument;
        PurchInvHeaderLocal: Record "Purch. Inv. Header";

    begin
        JXVZWithholdCalcDocumentLocal.Reset();
        JXVZWithholdCalcDocumentLocal.SetRange(JXVZPaymentOrderNo, JXVZWithholdCalcLines.JXVZPaymentOrderNo);
        JXVZWithholdCalcDocumentLocal.SetRange(JXVZWitholdingNo, JXVZWithholdCalcLines.JXVZWitholdingNo);
        JXVZWithholdCalcDocumentLocal.SetRange(JXVZDocumentNo, _PurchInvLine."Document No.");
        if not JXVZWithholdCalcDocumentLocal.IsEmpty() then
            exit;

        PurchInvHeaderLocal.Get(_PurchInvLine."Document No.");

        CargaDocumentosPeriodo(_JXVZWithholdCalcLines, PurchInvHeaderLocal."Posting Date");
    end;

    local procedure DiscriminaRetencionNC(_JXVZWithholdCalcLines: Record "JXVZWithholdCalcLines"; _PurchInvLine: Record "Purch. Cr. Memo Line")
    var
        JXVZWithholdCalcDocumentLocal: Record JXVZWithholdCalcDocument;
        PurchCrMemoHdrLocal: Record "Purch. Cr. Memo Hdr.";

    begin
        JXVZWithholdCalcDocumentLocal.Reset();
        JXVZWithholdCalcDocumentLocal.SetRange(JXVZPaymentOrderNo, JXVZWithholdCalcLines.JXVZPaymentOrderNo);
        JXVZWithholdCalcDocumentLocal.SetRange(JXVZWitholdingNo, JXVZWithholdCalcLines.JXVZWitholdingNo);
        JXVZWithholdCalcDocumentLocal.SetRange(JXVZDocumentNo, _PurchInvLine."Document No.");
        if not JXVZWithholdCalcDocumentLocal.IsEmpty() then
            exit;

        PurchCrMemoHdrLocal.Get(_PurchInvLine."Document No.");

        CargaDocumentosPeriodo(_JXVZWithholdCalcLines, PurchCrMemoHdrLocal."Posting Date");
    end;

    procedure CargaDocumentosPeriodo(_JXVZWithholdCalcLines: Record "JXVZWithholdCalcLines"; _OperationDate: Date)
    var
        PaymentOrderHeaderLocal: Record "Gen. Journal Line";
        PurchInvHeaderLocal: Record "Purch. Inv. Header";
        PurchCrMemoHdrLocal: Record "Purch. Cr. Memo Hdr.";
        JXVZWithholdCalcDocumentLocal: Record JXVZWithholdCalcDocument;
        InvoicingMonthly: Decimal;
        StartDate: Date;
        EndDate: Date;
        TotalTax: Decimal;
    begin
        PaymentOrderHeaderLocal.Reset();
        PaymentOrderHeaderLocal.SetRange("Account No.", _JXVZWithholdCalcLines.JXVZPaymentOrderNo);
        PaymentOrderHeaderLocal.SetRange("Account Type", PaymentOrderHeaderLocal."Account Type"::Vendor);
        if PaymentOrderHeaderLocal.FindFirst() then;

        EndDate := CalcDate('<CM>', _OperationDate);
        StartDate := CalcDate('+1<D>-1M', EndDate);
        InvoicingMonthly := CalculaFacturacionDL(PaymentOrderHeaderLocal."Account No.", _JXVZWithholdCalcLines.JXVZWitholdingNo, StartDate, EndDate);

        if InvoicingMonthly < _JXVZWithholdCalcLines.JXVZMinimumAmountInvPerMonth then
            exit;

        PurchInvHeaderLocal.Reset();
        PurchInvHeaderLocal.SetRange("Pay-to Vendor No.", PaymentOrderHeaderLocal."Account No.");
        PurchInvHeaderLocal.SetRange("Posting Date", StartDate, EndDate);
        if PurchInvHeaderLocal.FindSet() then
            repeat
                PurchInvHeaderLocal.CalcFields(Amount, "Amount Including VAT");
                case JXVZWithholdCalcLines.JXVZBaseWitholdingType of
                    JXVZWithholdCalcLines.JXVZBaseWitholdingType::"Sin Impuestos":
                        BaseCalculation := PurchInvHeaderLocal.Amount;
                    JXVZWithholdCalcLines.JXVZBaseWitholdingType::"Importe Impuestos":
                        BaseCalculation := PurchInvHeaderLocal."Amount Including VAT";
                    JXVZWithholdCalcLines.JXVZBaseWitholdingType::"Importe Total":
                        BaseCalculation := PurchInvHeaderLocal."Amount Including VAT";
                    JXVZWithholdCalcLines.JXVZBaseWitholdingType::"Total menos IVA":
                        begin
                            TotalTax := getTotalIVA("Gen. Journal Document Type"::Invoice, PurchInvHeaderLocal."No.");
                            if PurchInvHeaderLocal."Currency Code" <> '' then
                                TotalTax := TotalTax * PurchInvHeaderLocal."Currency Factor";

                            BaseCalculation := PurchInvHeaderLocal."Amount Including VAT" - TotalTax;
                        end;
                    JXVZWithholdCalcLines.JXVZBaseWitholdingType::"Total menos IVA menos IVA Percep":
                        begin
                            TotalTax := getTotalIVAAndPercepIVA("Gen. Journal Document Type"::Invoice, PurchInvHeaderLocal."No.");
                            if PurchInvHeaderLocal."Currency Code" <> '' then
                                TotalTax := TotalTax * PurchInvHeaderLocal."Currency Factor";

                            BaseCalculation := PurchInvHeaderLocal."Amount Including VAT" - TotalTax;
                        end;
                    JXVZWithholdCalcLines.JXVZBaseWitholdingType::"Solo IVA":
                        begin
                            TotalTax := getTotalIVA("Gen. Journal Document Type"::Invoice, PurchInvHeaderLocal."No.");
                            if PurchInvHeaderLocal."Currency Code" <> '' then
                                TotalTax := TotalTax * PurchInvHeaderLocal."Currency Factor";

                            BaseCalculation := TotalTax;
                        end;
                end;

                if PurchInvHeaderLocal."Currency Code" <> '' then
                    BaseCalculation := BaseCalculation / PurchInvHeaderLocal."Currency Factor";

                if JXVZWithholdCalcLines.JXVZWitholdingMode = JXVZWithholdCalcLines.JXVZWitholdingMode::"Proporcional al pago" then
                    BaseCalculation := (BaseCalculation * PercentageAmount) / 100;

                JXVZWithholdCalcDocumentLocal.Init();
                JXVZWithholdCalcDocumentLocal.JXVZPaymentOrderNo := JXVZWithholdCalcLines.JXVZPaymentOrderNo;
                JXVZWithholdCalcDocumentLocal.JXVZWitholdingNo := JXVZWithholdCalcLines.JXVZWitholdingNo;
                JXVZWithholdCalcDocumentLocal.JXVZDocumentType := JXVZWithholdCalcDocumentLocal.JXVZDocumentType::Invoice;

                JXVZWithholdCalcDocumentLocal.JXVZDocumentNo := PurchInvHeaderLocal."No.";
                JXVZWithholdCalcDocumentLocal.JXVZDocumentDate := PurchInvHeaderLocal."Posting Date";
                JXVZWithholdCalcDocumentLocal.JXVZMonthlyInvoicing := InvoicingMonthly;
                JXVZWithholdCalcDocumentLocal.JXVZVendorDocumentNo := PurchInvHeaderLocal."Vendor Invoice No.";
                JXVZWithholdCalcDocumentLocal.JXVZCalculationBase := BaseCalculation;
                JXVZWithholdCalcDocumentLocal.Insert();

            until PurchInvHeaderLocal.Next() = 0;

        PurchCrMemoHdrLocal.Reset();
        PurchCrMemoHdrLocal.SetRange("Pay-to Vendor No.", PaymentOrderHeaderLocal."Account No.");
        PurchCrMemoHdrLocal.SetRange("Posting Date", StartDate, EndDate);
        if PurchCrMemoHdrLocal.FindSet() then
            repeat
                PurchCrMemoHdrLocal.CalcFields(Amount, "Amount Including VAT");
                case JXVZWithholdCalcLines.JXVZBaseWitholdingType of
                    JXVZWithholdCalcLines.JXVZBaseWitholdingType::"Sin Impuestos":
                        BaseCalculation := PurchCrMemoHdrLocal.Amount;
                    JXVZWithholdCalcLines.JXVZBaseWitholdingType::"Importe Impuestos":
                        BaseCalculation := PurchCrMemoHdrLocal."Amount Including VAT";
                    JXVZWithholdCalcLines.JXVZBaseWitholdingType::"Importe Total":
                        BaseCalculation := PurchCrMemoHdrLocal."Amount Including VAT";
                    JXVZWithholdCalcLines.JXVZBaseWitholdingType::"Total menos IVA":
                        begin
                            TotalTax := getTotalIVA("Gen. Journal Document Type"::Invoice, PurchCrMemoHdrLocal."No.");
                            if PurchCrMemoHdrLocal."Currency Code" <> '' then
                                TotalTax := TotalTax * PurchCrMemoHdrLocal."Currency Factor";

                            BaseCalculation := PurchCrMemoHdrLocal."Amount Including VAT" - TotalTax;
                        end;
                    JXVZWithholdCalcLines.JXVZBaseWitholdingType::"Total menos IVA menos IVA Percep":
                        begin
                            TotalTax := getTotalIVAAndPercepIVA("Gen. Journal Document Type"::Invoice, PurchCrMemoHdrLocal."No.");
                            if PurchCrMemoHdrLocal."Currency Code" <> '' then
                                TotalTax := TotalTax * PurchCrMemoHdrLocal."Currency Factor";

                            BaseCalculation := PurchCrMemoHdrLocal."Amount Including VAT" - TotalTax;
                        end;
                    JXVZWithholdCalcLines.JXVZBaseWitholdingType::"Solo IVA":
                        begin
                            TotalTax := getTotalIVA("Gen. Journal Document Type"::Invoice, PurchCrMemoHdrLocal."No.");
                            if PurchCrMemoHdrLocal."Currency Code" <> '' then
                                TotalTax := TotalTax * PurchCrMemoHdrLocal."Currency Factor";

                            BaseCalculation := TotalTax;
                        end;
                end;

                if PurchCrMemoHdrLocal."Currency Code" <> '' then
                    BaseCalculation := BaseCalculation / PurchCrMemoHdrLocal."Currency Factor";

                if JXVZWithholdCalcLines.JXVZWitholdingMode = JXVZWithholdCalcLines.JXVZWitholdingMode::"Proporcional al pago" then
                    BaseCalculation := (BaseCalculation * PercentageAmount) / 100;

                JXVZWithholdCalcDocumentLocal.Init();
                JXVZWithholdCalcDocumentLocal.JXVZPaymentOrderNo := JXVZWithholdCalcLines.JXVZPaymentOrderNo;
                JXVZWithholdCalcDocumentLocal.JXVZWitholdingNo := JXVZWithholdCalcLines.JXVZWitholdingNo;
                JXVZWithholdCalcDocumentLocal.JXVZDocumentType := JXVZWithholdCalcDocumentLocal.JXVZDocumentType::"Credit Memo";
                JXVZWithholdCalcDocumentLocal.JXVZDocumentNo := PurchCrMemoHdrLocal."No.";
                JXVZWithholdCalcDocumentLocal.JXVZDocumentDate := PurchCrMemoHdrLocal."Posting Date";
                JXVZWithholdCalcDocumentLocal.JXVZMonthlyInvoicing := InvoicingMonthly;
                JXVZWithholdCalcDocumentLocal.JXVZVendorDocumentNo := PurchCrMemoHdrLocal."Vendor Cr. Memo No.";
                JXVZWithholdCalcDocumentLocal.JXVZCalculationBase := -BaseCalculation;
                JXVZWithholdCalcDocumentLocal.Insert();

            until PurchCrMemoHdrLocal.Next() = 0;
    end;

    local procedure PagoAcumulativoRetencionFACT(_JXVZWithholdCalcLines: Record "JXVZWithholdCalcLines"; _PurchInvLine: Record "Purch. Inv. Line")
    var
        JXVZWithholdAccumCalcLocal: Record JXVZWithholdAccumCalc;
        PurchInvHeaderLocal: Record "Purch. Inv. Header";
    begin
        JXVZWithholdAccumCalcLocal.Reset();
        JXVZWithholdAccumCalcLocal.SetRange(JXVZPaymentOrderNo, JXVZWithholdCalcLines.JXVZPaymentOrderNo);
        JXVZWithholdAccumCalcLocal.SetRange(JXVZWitholdingNo, JXVZWithholdCalcLines.JXVZWitholdingNo);
        JXVZWithholdAccumCalcLocal.SetRange(JXVZDocumentNo, _PurchInvLine."Document No.");
        JXVZWithholdAccumCalcLocal.SetRange(JXVZLineNo, _PurchInvLine."Line No.");
        if not JXVZWithholdAccumCalcLocal.IsEmpty() then
            exit;

        PurchInvHeaderLocal.Get(_PurchInvLine."Document No.");

        CargaDocPagoAcumulativo(_JXVZWithholdCalcLines, PurchInvHeaderLocal."Posting Date", _PurchInvLine."Document No.", '1', 0, _PurchInvLine."Line No.");
    end;

    local procedure PagoAcumulativoRetencionNC(_JXVZWithholdCalcLines: Record "JXVZWithholdCalcLines"; _PurchInvLine: Record "Purch. Cr. Memo Line")
    var
        JXVZWithholdAccumCalcLocal: Record JXVZWithholdAccumCalc;
        PurchCrMemoHdrLocal: Record "Purch. Cr. Memo Hdr.";
    begin
        JXVZWithholdAccumCalcLocal.Reset();
        JXVZWithholdAccumCalcLocal.SetRange(JXVZPaymentOrderNo, JXVZWithholdCalcLines.JXVZPaymentOrderNo);
        JXVZWithholdAccumCalcLocal.SetRange(JXVZWitholdingNo, JXVZWithholdCalcLines.JXVZWitholdingNo);
        JXVZWithholdAccumCalcLocal.SetRange(JXVZDocumentNo, _PurchInvLine."Document No.");
        JXVZWithholdAccumCalcLocal.SetRange(JXVZLineNo, _PurchInvLine."Line No.");
        if not JXVZWithholdAccumCalcLocal.IsEmpty() then
            exit;

        PurchCrMemoHdrLocal.Get(_PurchInvLine."Document No.");

        CargaDocPagoAcumulativo(_JXVZWithholdCalcLines, PurchCrMemoHdrLocal."Posting Date", _PurchInvLine."Document No.", '2', 0, _PurchInvLine."Line No.");
    end;

    procedure CargaDocPagoAcumulativo(_JXVZWithholdCalcLines: Record "JXVZWithholdCalcLines"; _OperationDate: Date; _Doc: Code[20]; _FacNC: Text[30]; _decBase: Decimal; _DocLin: Integer)
    var
        PaymentOrderHeaderLocal: Record "Gen. Journal Line";
        PurchInvHeaderLocal: Record "Purch. Inv. Header";
        PurchInvLineLocal: Record "Purch. Inv. Line";
        PurchCrMemoHdrLocal: Record "Purch. Cr. Memo Hdr.";
        PurchCrMemoLineLocal: Record "Purch. Cr. Memo Line";
        JXVZWithholdAccumCalcLocal: Record JXVZWithholdAccumCalc;
        InvoicingMonthly: Decimal;
        StartDate: Date;
        EndDate: Date;
        TotalTax: Decimal;
    begin
        PaymentOrderHeaderLocal.Reset();
        PaymentOrderHeaderLocal.SetRange("Account No.", _JXVZWithholdCalcLines.JXVZPaymentOrderNo);
        PaymentOrderHeaderLocal.SetRange("Account Type", PaymentOrderHeaderLocal."Account Type"::Vendor);
        if PaymentOrderHeaderLocal.FindFirst() then;

        EndDate := CalcDate('<CM>', _OperationDate);
        StartDate := CalcDate('+1<D>-1M', EndDate);

        case _FacNC of
            '1':
                begin
                    PurchInvHeaderLocal.Reset();
                    PurchInvHeaderLocal.SetRange("Pay-to Vendor No.", PaymentOrderHeaderLocal."Account No.");
                    PurchInvHeaderLocal.SetRange(PurchInvHeaderLocal."No.", _Doc);
                    if PurchInvHeaderLocal.FindFirst() then begin
                        PurchInvLineLocal.SetRange(PurchInvLineLocal."Document No.", PurchInvHeaderLocal."No.");
                        PurchInvLineLocal.SetRange(PurchInvLineLocal."Line No.", _DocLin);
                        if (PurchInvLineLocal.FindFirst()) then begin
                            PurchInvHeaderLocal.CalcFields(Amount, "Amount Including VAT");
                            case JXVZWithholdCalcLines.JXVZBaseWitholdingType of
                                JXVZWithholdCalcLines.JXVZBaseWitholdingType::"Sin Impuestos":
                                    BaseCalculation := PurchInvLineLocal.Amount;
                                JXVZWithholdCalcLines.JXVZBaseWitholdingType::"Importe Impuestos":
                                    BaseCalculation := PurchInvHeaderLocal."Amount Including VAT";
                                JXVZWithholdCalcLines.JXVZBaseWitholdingType::"Importe Total":
                                    BaseCalculation := PurchInvHeaderLocal."Amount Including VAT";
                                JXVZWithholdCalcLines.JXVZBaseWitholdingType::"Total menos IVA":
                                    begin
                                        TotalTax := getTotalIVA("Gen. Journal Document Type"::Invoice, PurchInvHeaderLocal."No.");
                                        if PurchInvHeaderLocal."Currency Code" <> '' then
                                            TotalTax := TotalTax * PurchInvHeaderLocal."Currency Factor";

                                        BaseCalculation := PurchInvHeaderLocal."Amount Including VAT" - TotalTax;
                                    end;
                                JXVZWithholdCalcLines.JXVZBaseWitholdingType::"Total menos IVA menos IVA Percep":
                                    begin
                                        TotalTax := getTotalIVAAndPercepIVA("Gen. Journal Document Type"::Invoice, PurchInvHeaderLocal."No.");
                                        if PurchInvHeaderLocal."Currency Code" <> '' then
                                            TotalTax := TotalTax * PurchInvHeaderLocal."Currency Factor";

                                        BaseCalculation := PurchInvHeaderLocal."Amount Including VAT" - TotalTax;
                                    end;
                                JXVZWithholdCalcLines.JXVZBaseWitholdingType::"Solo IVA":
                                    begin
                                        TotalTax := getTotalIVA("Gen. Journal Document Type"::Invoice, PurchInvHeaderLocal."No.");
                                        if PurchInvHeaderLocal."Currency Code" <> '' then
                                            TotalTax := TotalTax * PurchInvHeaderLocal."Currency Factor";

                                        BaseCalculation := TotalTax;
                                    end;
                            end;
                        end;
                        if PurchInvHeaderLocal."Currency Code" <> '' then
                            BaseCalculation := BaseCalculation / GenJournalLineTmpProcess."Currency Factor";

                        if JXVZWithholdCalcLines.JXVZWitholdingMode = JXVZWithholdCalcLines.JXVZWitholdingMode::"Proporcional al pago" then
                            if GenJournalLineTmpProcess."Applies-to Doc. Type" <> GenJournalLineTmpProcess."Applies-to Doc. Type"::"Credit Memo" then
                                BaseCalculation := (BaseCalculation * PercentageAmount) / 100;

                        if GenJournalLineTmpProcess."Applies-to Doc. Type" = GenJournalLineTmpProcess."Applies-to Doc. Type"::"Credit Memo" then begin
                            if not (JXVZWithholdCalcLines.JXVZApplyCreditMemo) then
                                BaseCalculation := BaseCalculation - FindApplicCreditMemo(PurchInvHeaderLocal."No.", PurchInvLineLocal.JXVZWithholdingCode);
                            JXVZWithholdCalcLines.JXVZApplyCreditMemo := true;
                        end;

                        JXVZWithholdAccumCalcLocal.Init();
                        JXVZWithholdAccumCalcLocal.JXVZPaymentOrderNo := JXVZWithholdCalcLines.JXVZPaymentOrderNo;
                        JXVZWithholdAccumCalcLocal.JXVZWitholdingNo := JXVZWithholdCalcLines.JXVZWitholdingNo;
                        JXVZWithholdAccumCalcLocal.JXVZDocumentType := JXVZWithholdAccumCalcLocal.JXVZDocumentType::Invoice;
                        JXVZWithholdAccumCalcLocal.JXVZDocumentNo := PurchInvHeaderLocal."No.";
                        JXVZWithholdAccumCalcLocal.JXVZDocumentDate := PurchInvHeaderLocal."Posting Date";
                        JXVZWithholdAccumCalcLocal.JXVZMonthlyInvoicing := InvoicingMonthly;
                        JXVZWithholdAccumCalcLocal.JXVZVendorDocumentNo := PurchInvHeaderLocal."Vendor Invoice No.";
                        JXVZWithholdAccumCalcLocal.JXVZCalculationBase := BaseCalculation;
                        JXVZWithholdAccumCalcLocal.JXVZLineNo := _DocLin;
                        JXVZWithholdAccumCalcLocal.Insert();
                    end;
                end;
            '2':
                begin
                    PurchCrMemoHdrLocal.Reset();
                    PurchCrMemoHdrLocal.SetRange("Pay-to Vendor No.", PaymentOrderHeaderLocal."Account No.");
                    PurchCrMemoHdrLocal.SetRange(PurchCrMemoHdrLocal."No.", _Doc);
                    if PurchCrMemoHdrLocal.FindFirst() then begin
                        PurchCrMemoLineLocal.SetRange("Document No.", PurchCrMemoHdrLocal."No.");
                        PurchCrMemoLineLocal.SetRange("Line No.", _DocLin);
                        if (PurchCrMemoLineLocal.FindFirst()) then begin
                            PurchCrMemoHdrLocal.CalcFields(Amount, "Amount Including VAT");
                            case JXVZWithholdCalcLines.JXVZBaseWitholdingType of
                                JXVZWithholdCalcLines.JXVZBaseWitholdingType::"Sin Impuestos":
                                    BaseCalculation := PurchCrMemoLineLocal.Amount;
                                JXVZWithholdCalcLines.JXVZBaseWitholdingType::"Importe Impuestos":
                                    BaseCalculation := PurchCrMemoHdrLocal."Amount Including VAT";
                                JXVZWithholdCalcLines.JXVZBaseWitholdingType::"Importe Total":
                                    BaseCalculation := PurchCrMemoHdrLocal."Amount Including VAT";
                                JXVZWithholdCalcLines.JXVZBaseWitholdingType::"Total menos IVA":
                                    begin
                                        TotalTax := getTotalIVA("Gen. Journal Document Type"::Invoice, PurchCrMemoHdrLocal."No.");
                                        if PurchCrMemoHdrLocal."Currency Code" <> '' then
                                            TotalTax := TotalTax * PurchCrMemoHdrLocal."Currency Factor";

                                        BaseCalculation := PurchCrMemoHdrLocal."Amount Including VAT" - TotalTax;
                                    end;
                                JXVZWithholdCalcLines.JXVZBaseWitholdingType::"Total menos IVA menos IVA Percep":
                                    begin
                                        TotalTax := getTotalIVAAndPercepIVA("Gen. Journal Document Type"::Invoice, PurchCrMemoHdrLocal."No.");
                                        if PurchCrMemoHdrLocal."Currency Code" <> '' then
                                            TotalTax := TotalTax * PurchCrMemoHdrLocal."Currency Factor";

                                        BaseCalculation := PurchCrMemoHdrLocal."Amount Including VAT" - TotalTax;
                                    end;
                                JXVZWithholdCalcLines.JXVZBaseWitholdingType::"Solo IVA":
                                    begin
                                        TotalTax := getTotalIVA("Gen. Journal Document Type"::Invoice, PurchCrMemoHdrLocal."No.");
                                        if PurchCrMemoHdrLocal."Currency Code" <> '' then
                                            TotalTax := TotalTax * PurchCrMemoHdrLocal."Currency Factor";

                                        BaseCalculation := TotalTax;
                                    end;
                            end;
                        end;
                        if PurchCrMemoHdrLocal."Currency Code" <> '' then
                            BaseCalculation := BaseCalculation / GenJournalLineTmpProcess."Currency Factor";

                        if JXVZWithholdCalcLines.JXVZWitholdingMode = JXVZWithholdCalcLines.JXVZWitholdingMode::"Proporcional al pago" then
                            BaseCalculation := (BaseCalculation * PercentageAmount) / 100;

                        JXVZWithholdAccumCalcLocal.Init();
                        JXVZWithholdAccumCalcLocal.JXVZPaymentOrderNo := JXVZWithholdCalcLines.JXVZPaymentOrderNo;
                        JXVZWithholdAccumCalcLocal.JXVZWitholdingNo := JXVZWithholdCalcLines.JXVZWitholdingNo;
                        JXVZWithholdAccumCalcLocal.JXVZDocumentType := JXVZWithholdAccumCalcLocal.JXVZDocumentType::"Credit Memo";
                        JXVZWithholdAccumCalcLocal.JXVZDocumentNo := PurchCrMemoHdrLocal."No.";
                        JXVZWithholdAccumCalcLocal.JXVZMonthlyInvoicing := InvoicingMonthly;
                        JXVZWithholdAccumCalcLocal.JXVZVendorDocumentNo := PurchCrMemoHdrLocal."Vendor Cr. Memo No.";
                        JXVZWithholdAccumCalcLocal.JXVZCalculationBase := -BaseCalculation;
                        JXVZWithholdAccumCalcLocal.JXVZLineNo := _DocLin;
                        JXVZWithholdAccumCalcLocal.Insert();
                    end;
                end;

            '3':
                begin
                    PurchInvHeaderLocal.Reset();
                    PurchInvHeaderLocal.SetRange("Pay-to Vendor No.", PaymentOrderHeaderLocal."Account No.");
                    PurchInvHeaderLocal.SetRange(PurchInvHeaderLocal."No.", _Doc);
                    if PurchInvHeaderLocal.FindFirst() then;

                    JXVZWithholdAccumCalcLocal.Reset();
                    JXVZWithholdAccumCalcLocal.SetRange(JXVZAccumulativePayments, true);
                    JXVZWithholdAccumCalcLocal.SetRange(JXVZDocumentType, JXVZWithholdAccumCalcLocal.JXVZDocumentType::Invoice);
                    JXVZWithholdAccumCalcLocal.SetRange(JXVZPaymentOrderNo, JXVZWithholdCalcLines.JXVZPaymentOrderNo);
                    JXVZWithholdAccumCalcLocal.SetRange(JXVZWitholdingNo, JXVZWithholdCalcLines.JXVZWitholdingNo);
                    if not (JXVZWithholdAccumCalcLocal.FindFirst()) then begin
                        JXVZWithholdAccumCalcLocal.JXVZPaymentOrderNo := JXVZWithholdCalcLines.JXVZPaymentOrderNo;
                        JXVZWithholdAccumCalcLocal.JXVZWitholdingNo := JXVZWithholdCalcLines.JXVZWitholdingNo;
                        JXVZWithholdAccumCalcLocal.JXVZDocumentType := JXVZWithholdAccumCalcLocal.JXVZDocumentType::Invoice;
                        JXVZWithholdAccumCalcLocal.JXVZDocumentNo := PurchInvHeaderLocal."No.";
                        JXVZWithholdAccumCalcLocal.JXVZDocumentDate := PurchInvHeaderLocal."Posting Date";
                        JXVZWithholdAccumCalcLocal.JXVZMonthlyInvoicing := InvoicingMonthly;
                        JXVZWithholdAccumCalcLocal.JXVZVendorDocumentNo := PurchInvHeaderLocal."Vendor Invoice No.";
                        JXVZWithholdAccumCalcLocal.JXVZCalculationBase := _decBase;
                        JXVZWithholdAccumCalcLocal.JXVZAccumulativePayments := true;
                        JXVZWithholdAccumCalcLocal.JXVZLineNo := _DocLin;
                        JXVZWithholdAccumCalcLocal.Insert();
                    end
                    else begin
                        JXVZWithholdAccumCalcLocal.JXVZCalculationBase += _decBase;
                        JXVZWithholdAccumCalcLocal.Modify();

                    end;
                end;
            '4':
                begin
                    PurchCrMemoHdrLocal.Reset();
                    PurchCrMemoHdrLocal.SetRange("Pay-to Vendor No.", PaymentOrderHeaderLocal."Account No.");
                    PurchCrMemoHdrLocal.SetRange(PurchCrMemoHdrLocal."No.", _Doc);
                    if PurchCrMemoHdrLocal.FindFirst() then;

                    JXVZWithholdAccumCalcLocal.Reset();
                    JXVZWithholdAccumCalcLocal.SetRange(JXVZWithholdAccumCalcLocal.JXVZAccumulativePayments, true);
                    JXVZWithholdAccumCalcLocal.SetRange(JXVZWithholdAccumCalcLocal.JXVZDocumentType, JXVZWithholdAccumCalcLocal.JXVZDocumentType::"Credit Memo");
                    JXVZWithholdAccumCalcLocal.SetRange(JXVZPaymentOrderNo, JXVZWithholdCalcLines.JXVZPaymentOrderNo);
                    JXVZWithholdAccumCalcLocal.SetRange(JXVZWitholdingNo, JXVZWithholdCalcLines.JXVZWitholdingNo);
                    if not (JXVZWithholdAccumCalcLocal.FindFirst()) then begin
                        JXVZWithholdAccumCalcLocal.JXVZPaymentOrderNo := JXVZWithholdCalcLines.JXVZPaymentOrderNo;
                        JXVZWithholdAccumCalcLocal.JXVZWitholdingNo := JXVZWithholdCalcLines.JXVZWitholdingNo;
                        JXVZWithholdAccumCalcLocal.JXVZDocumentType := JXVZWithholdAccumCalcLocal.JXVZDocumentType::"Credit Memo";
                        JXVZWithholdAccumCalcLocal.JXVZDocumentNo := PurchCrMemoHdrLocal."No.";
                        JXVZWithholdAccumCalcLocal.JXVZDocumentDate := PurchCrMemoHdrLocal."Posting Date";
                        JXVZWithholdAccumCalcLocal.JXVZMonthlyInvoicing := InvoicingMonthly;
                        JXVZWithholdAccumCalcLocal.JXVZVendorDocumentNo := PurchCrMemoHdrLocal."Vendor Cr. Memo No.";
                        JXVZWithholdAccumCalcLocal.JXVZCalculationBase := -_decBase;
                        JXVZWithholdAccumCalcLocal.JXVZAccumulativePayments := true;
                        JXVZWithholdAccumCalcLocal.JXVZLineNo := _DocLin;
                        JXVZWithholdAccumCalcLocal.Insert();
                    end
                    else begin
                        JXVZWithholdAccumCalcLocal.JXVZCalculationBase -= _decBase;
                        JXVZWithholdAccumCalcLocal.Modify();

                    end;
                end;

        end;
    end;

    procedure AjustaRetenciones(_PaymentOrderNro: Code[20])
    var
        localGenJnlLine: Record "Gen. Journal Line";
        JXVZWithholdCalcLinesLocal: Record "JXVZWithholdCalcLines";
        JXVZWithholdCalcDocumentLocal: Record JXVZWithholdCalcDocument;
        decTOP: Decimal;
        decRetFACT: Decimal;
        decRetNC: Decimal;
        decRetFACT2: Decimal;
        decRetNC2: Decimal;
    begin
        localGenJnlLine.reset();
        localGenJnlLine.SetRange("Document No.", _PaymentOrderNro);
        if localGenJnlLine.FindSet() then
            repeat
                decTOP += localGenJnlLine."Amount (LCY)";
            until localGenJnlLine.Next() = 0;

        decRetFACT := 0;
        decRetNC := 0;
        decRetFACT2 := 0;
        decRetNC2 := 0;

        JXVZWithholdCalcLinesLocal.Reset();
        JXVZWithholdCalcLinesLocal.SetRange(JXVZPaymentOrderNo, _PaymentOrderNro);
        JXVZWithholdCalcLinesLocal.SetRange(JXVZDistinctPerDocument, true);
        if JXVZWithholdCalcLinesLocal.FindSet() then
            repeat
                JXVZWithholdCalcDocumentLocal.Reset();
                JXVZWithholdCalcDocumentLocal.SetRange(JXVZPaymentOrderNo, _PaymentOrderNro);
                JXVZWithholdCalcDocumentLocal.SetRange(JXVZWitholdingNo, JXVZWithholdCalcLinesLocal.JXVZWitholdingNo);
                if JXVZWithholdCalcDocumentLocal.FindSet() then
                    repeat
                        if JXVZWithholdCalcDocumentLocal.JXVZDocumentType in [JXVZWithholdCalcDocumentLocal.JXVZDocumentType::Invoice,
                                                             JXVZWithholdCalcDocumentLocal.JXVZDocumentType::"Debit Memo"] then
                            decRetFACT += JXVZWithholdCalcDocumentLocal.JXVZWitholdingAmount
                        else
                            decRetNC += JXVZWithholdCalcDocumentLocal.JXVZWitholdingAmount;
                    until JXVZWithholdCalcDocumentLocal.Next() = 0;

                if decRetFACT < Abs(decRetNC) then
                    decRetNC := (-1) * decRetFACT;

                if (decRetFACT - Abs(decRetNC)) > decTOP then
                    decRetFACT := decTOP + (-1) * decRetNC;

                if JXVZWithholdCalcDocumentLocal.FindSet() then
                    repeat
                        if JXVZWithholdCalcDocumentLocal.JXVZDocumentType in [JXVZWithholdCalcDocumentLocal.JXVZDocumentType::Invoice,
                                                             JXVZWithholdCalcDocumentLocal.JXVZDocumentType::"Debit Memo"] then begin

                            if decRetFACT >= JXVZWithholdCalcDocumentLocal.JXVZWitholdingAmount then
                                decRetFACT -= JXVZWithholdCalcDocumentLocal.JXVZWitholdingAmount
                            else begin
                                JXVZWithholdCalcDocumentLocal.JXVZWitholdingAmount := decRetFACT;
                                JXVZWithholdCalcDocumentLocal.Modify();
                                decRetFACT := 0;
                            end;
                        end else
                            if decRetNC <= JXVZWithholdCalcDocumentLocal.JXVZWitholdingAmount then
                                decRetNC -= JXVZWithholdCalcDocumentLocal.JXVZWitholdingAmount
                            else begin
                                JXVZWithholdCalcDocumentLocal.JXVZWitholdingAmount := decRetNC;
                                JXVZWithholdCalcDocumentLocal.Modify();
                                decRetNC := 0;
                            end;
                    until JXVZWithholdCalcDocumentLocal.Next() = 0;
            until JXVZWithholdCalcLinesLocal.Next() = 0;

        JXVZWithholdCalcDocumentLocal.Reset();
        JXVZWithholdCalcDocumentLocal.SetRange(JXVZPaymentOrderNo, JXVZWithholdCalcLinesLocal.JXVZPaymentOrderNo);
        JXVZWithholdCalcDocumentLocal.SetRange(JXVZWitholdingAmount, 0);
        if JXVZWithholdCalcDocumentLocal.FindSet() then
            JXVZWithholdCalcDocumentLocal.DeleteAll(true);

        JXVZWithholdCalcLinesLocal.Reset();
        JXVZWithholdCalcLinesLocal.SetRange(JXVZPaymentOrderNo, _PaymentOrderNro);
        JXVZWithholdCalcLinesLocal.SetRange(JXVZDistinctPerDocument, true);
        if JXVZWithholdCalcLinesLocal.Find('-') then
            repeat
                JXVZWithholdCalcLinesLocal.CalcFields(JXVZDiscriminatedCalcWitholding, JXVZDiscriminationCalcBase);
                JXVZWithholdCalcLinesLocal.JXVZCalculatedWitholding := JXVZWithholdCalcLinesLocal.JXVZDiscriminatedCalcWitholding;
                JXVZWithholdCalcLinesLocal.JXVZBase := JXVZWithholdCalcLinesLocal.JXVZDiscriminationCalcBase;
                JXVZWithholdCalcLinesLocal.JXVZAccumulative := JXVZWithholdCalcLinesLocal.JXVZDiscriminationCalcBase;
                JXVZWithholdCalcLinesLocal.Modify();
            until JXVZWithholdCalcLinesLocal.Next() = 0;
    end;

    procedure CalculaFacturacionDL(_VendorNro: Code[20]; _RetentionNro: Integer; _StartDate: Date; _EndDate: Date) _InvoicingDL: Decimal
    var
        Vendor: Record Vendor;
        PurchInvHeaderLocal: Record "Purch. Inv. Header";
        PurchCrMemoHdrLocal: Record "Purch. Cr. Memo Hdr.";
        JXVZWithholdDetailEntryLocal: Record JXVZWithholdDetailEntry;
        BaseCalculationLocal: Decimal;
        TotalTax: Decimal;
    begin
        _InvoicingDL := 0;

        if not (Vendor.Get(VendorNro)) then
            exit;

        JXVZWithholdDetailEntryLocal.Reset();
        JXVZWithholdDetailEntryLocal.SetRange(JXVZWitholdingNo, _RetentionNro);
        if not (JXVZWithholdDetailEntryLocal.Find('-')) then
            exit;

        PurchInvHeaderLocal.Reset();
        PurchInvHeaderLocal.SetRange("Pay-to Vendor No.", VendorNro);
        PurchInvHeaderLocal.SetRange("Posting Date", _StartDate, _EndDate);
        if PurchInvHeaderLocal.FindSet() then
            repeat
                Clear(TotalTax);
                PurchInvHeaderLocal.CalcFields(Amount, "Amount Including VAT");
                case JXVZWithholdDetailEntryLocal.JXVZWitholdingBaseType of
                    JXVZWithholdDetailEntryLocal.JXVZWitholdingBaseType::"Sin Impuestos":
                        BaseCalculationLocal := PurchInvHeaderLocal.Amount;
                    JXVZWithholdDetailEntryLocal.JXVZWitholdingBaseType::"Importe Impuestos":
                        BaseCalculationLocal := PurchInvHeaderLocal."Amount Including VAT";
                    JXVZWithholdDetailEntryLocal.JXVZWitholdingBaseType::"Importe Total":
                        BaseCalculationLocal := PurchInvHeaderLocal."Amount Including VAT";
                    JXVZWithholdDetailEntryLocal.JXVZWitholdingBaseType::"Total menos IVA":
                        begin
                            TotalTax := getTotalIVA("Gen. Journal Document Type"::Invoice, PurchInvHeaderLocal."No.");
                            if PurchInvHeaderLocal."Currency Code" <> '' then
                                TotalTax := TotalTax * PurchInvHeaderLocal."Currency Factor";

                            BaseCalculationLocal := PurchInvHeaderLocal."Amount Including VAT" - TotalTax;
                        end;
                    JXVZWithholdDetailEntryLocal.JXVZWitholdingBaseType::"Total menos IVA menos IVA Percep":
                        begin
                            TotalTax := getTotalIVAAndPercepIVA("Gen. Journal Document Type"::Invoice, PurchInvHeaderLocal."No.");
                            if PurchInvHeaderLocal."Currency Code" <> '' then
                                TotalTax := TotalTax * PurchInvHeaderLocal."Currency Factor";

                            BaseCalculationLocal := PurchInvHeaderLocal."Amount Including VAT" - TotalTax;
                        end;
                    JXVZWithholdDetailEntryLocal.JXVZWitholdingBaseType::"Solo IVA":
                        begin
                            TotalTax := getTotalIVA("Gen. Journal Document Type"::Invoice, PurchInvHeaderLocal."No.");
                            if PurchInvHeaderLocal."Currency Code" <> '' then
                                TotalTax := TotalTax * PurchInvHeaderLocal."Currency Factor";

                            BaseCalculationLocal := TotalTax;
                        end;
                end;

                if PurchInvHeaderLocal."Currency Code" <> '' then
                    BaseCalculationLocal := BaseCalculationLocal / PurchInvHeaderLocal."Currency Factor";

                _InvoicingDL += BaseCalculationLocal;
                BaseCalculationLocal := 0;
            until PurchInvHeaderLocal.Next() = 0;

        PurchCrMemoHdrLocal.Reset();
        PurchCrMemoHdrLocal.SetRange("Pay-to Vendor No.", VendorNro);
        PurchCrMemoHdrLocal.SetRange("Posting Date", _StartDate, _EndDate);
        if PurchCrMemoHdrLocal.FindSet() then
            repeat
                Clear(TotalTax);
                PurchCrMemoHdrLocal.CalcFields(Amount, "Amount Including VAT");
                case JXVZWithholdCalcLines.JXVZBaseWitholdingType of
                    JXVZWithholdDetailEntryLocal.JXVZWitholdingBaseType::"Sin Impuestos":
                        BaseCalculationLocal := PurchCrMemoHdrLocal.Amount;
                    JXVZWithholdDetailEntryLocal.JXVZWitholdingBaseType::"Importe Impuestos":
                        BaseCalculationLocal := PurchCrMemoHdrLocal."Amount Including VAT";
                    JXVZWithholdDetailEntryLocal.JXVZWitholdingBaseType::"Importe Total":
                        BaseCalculationLocal := PurchCrMemoHdrLocal."Amount Including VAT";
                    JXVZWithholdDetailEntryLocal.JXVZWitholdingBaseType::"Total menos IVA":
                        begin
                            TotalTax := getTotalIVA("Gen. Journal Document Type"::"Credit Memo", PurchCrMemoHdrLocal."No.");
                            if PurchCrMemoHdrLocal."Currency Code" <> '' then
                                TotalTax := TotalTax * PurchCrMemoHdrLocal."Currency Factor";

                            BaseCalculationLocal := PurchCrMemoHdrLocal."Amount Including VAT" - TotalTax;
                        end;
                    JXVZWithholdDetailEntryLocal.JXVZWitholdingBaseType::"Total menos IVA menos IVA Percep":
                        begin
                            TotalTax := getTotalIVAAndPercepIVA("Gen. Journal Document Type"::"Credit Memo", PurchCrMemoHdrLocal."No.");
                            if PurchCrMemoHdrLocal."Currency Code" <> '' then
                                TotalTax := TotalTax * PurchCrMemoHdrLocal."Currency Factor";

                            BaseCalculationLocal := PurchCrMemoHdrLocal."Amount Including VAT" - TotalTax;
                        end;
                    JXVZWithholdDetailEntryLocal.JXVZWitholdingBaseType::"Solo IVA":
                        begin
                            TotalTax := getTotalIVA("Gen. Journal Document Type"::"Credit Memo", PurchCrMemoHdrLocal."No.");
                            if PurchCrMemoHdrLocal."Currency Code" <> '' then
                                TotalTax := TotalTax * PurchCrMemoHdrLocal."Currency Factor";

                            BaseCalculationLocal := TotalTax;
                        end;
                end;

                if PurchCrMemoHdrLocal."Currency Code" <> '' then
                    BaseCalculationLocal := BaseCalculationLocal / PurchCrMemoHdrLocal."Currency Factor";

                _InvoicingDL -= BaseCalculationLocal;
                BaseCalculationLocal := 0;
            until PurchCrMemoHdrLocal.Next() = 0;

    end;

    procedure CalcFechaMonotributo(_StartDate: Date) returnStartDate: Date
    begin
        returnStartDate := 0D;
        returnStartDate := DMY2Date(1, Date2DMY(_StartDate, 2), Date2DMY(_StartDate, 3));
        returnStartDate := CalcDate('<-11M>', returnStartDate);
    end;

    procedure FindApplicCreditMemo(_DocumentNro: Code[20]; _behavior: Code[20]) AmountNC: Decimal
    var
        VendorLedgerEntryLocal: Record "Vendor Ledger Entry";
    begin
        VendorLedgerEntryLocal.SetRange(VendorLedgerEntryLocal."Document No.", _DocumentNro);
        VendorLedgerEntryLocal.SetRange(VendorLedgerEntryLocal.Open, true);
        if (VendorLedgerEntryLocal.FindFirst()) then
            AmountNC := FindAppliNC(VendorLedgerEntryLocal."Entry No.", VendorLedgerEntryLocal."Vendor No.", _behavior);
    end;

    procedure FindApplicCreditMemo2(_DocumentNro: Code[20]; _behavior: Code[20]) AmountNC: Decimal
    var
        VendorLedgerEntryLocal: Record "Vendor Ledger Entry";
    begin
        VendorLedgerEntryLocal.SetRange(VendorLedgerEntryLocal."Document No.", _DocumentNro);
        VendorLedgerEntryLocal.SetRange(VendorLedgerEntryLocal.Open, false);
        if (VendorLedgerEntryLocal.FindFirst()) then
            AmountNC := FindAppliNC(VendorLedgerEntryLocal."Entry No.", VendorLedgerEntryLocal."Vendor No.", _behavior);
    end;

    procedure FindAppliNC(_EntryNro: Integer; _VendorNro: Code[20]; _behavior: Code[20]) AmountNC: Decimal
    var
        VendorLedgerEntryLocal: Record "Vendor Ledger Entry";
        PurchCrMemoHdrLocal: Record "Purch. Cr. Memo Hdr.";
        PurchCrMemoLineLocal: Record "Purch. Cr. Memo Line";
    begin
        VendorLedgerEntryLocal.Reset();
        VendorLedgerEntryLocal.SetCurrentKey("Vendor No.", Open, Positive);
        VendorLedgerEntryLocal.SetRange("Vendor No.", _VendorNro);
        VendorLedgerEntryLocal.SetRange(VendorLedgerEntryLocal."Closed by Entry No.", _EntryNro);
        if (VendorLedgerEntryLocal.FindSet()) then
            repeat
                if (VendorLedgerEntryLocal."Document Type" = VendorLedgerEntryLocal."Document Type"::"Credit Memo") then begin
                    PurchCrMemoHdrLocal.Reset();
                    PurchCrMemoHdrLocal.SetRange("Pay-to Vendor No.", GlobVendor);
                    PurchCrMemoHdrLocal.SetRange(PurchCrMemoHdrLocal."No.", VendorLedgerEntryLocal."Document No.");
                    if PurchCrMemoHdrLocal.FindFirst() then begin
                        PurchCrMemoHdrLocal.CalcFields(Amount, "Amount Including VAT");
                        PurchCrMemoLineLocal.Reset();
                        PurchCrMemoLineLocal.SetRange("Document No.", PurchCrMemoHdrLocal."No.");
                        PurchCrMemoLineLocal.SetRange("Buy-from Vendor No.", GlobVendor);
                        PurchCrMemoLineLocal.SetRange(PurchCrMemoLineLocal.JXVZWithholdingCode, _behavior);
                        if (PurchCrMemoLineLocal.FindSet()) then
                            repeat
                                AmountNC += PurchCrMemoLineLocal.Amount;
                            until PurchCrMemoLineLocal.Next() = 0;

                        if PurchCrMemoHdrLocal."Currency Code" <> '' then
                            AmountNC := AmountNC / PurchCrMemoHdrLocal."Currency Factor";
                    end;
                end;
            until VendorLedgerEntryLocal.Next() = 0;
    end;

    local procedure getTotalIVA(pDocType: Enum "Gen. Journal Document Type"; pDocNo: Code[20]) TotalIVA: Decimal;
    var
        VATEntry: Record "VAT Entry";
        TaxJurisdiction: Record "Tax Jurisdiction";
    begin
        VATEntry.Reset();
        VATEntry.SetRange("Document Type", pDocType);
        VATEntry.SetRange("Document No.", pDocNo);
        if VATEntry.FindSet() then
            repeat
                TaxJurisdiction.Reset();
                TaxJurisdiction.SetRange(Code, VATEntry."Tax Jurisdiction Code");
                if TaxJurisdiction.FindFirst() then
                    if TaxJurisdiction.JXVZTaxType = TaxJurisdiction.JXVZTaxType::VAT then
                        TotalIVA += abs(VATEntry.Amount);
            until VATEntry.Next() = 0
    end;

    local procedure getTotalIVAAndPercepIVA(pDocType: Enum "Gen. Journal Document Type"; pDocNo: Code[20]) TotalIVAAndPerIVA: Decimal;
    var
        VATEntry: Record "VAT Entry";
        TaxJurisdiction: Record "Tax Jurisdiction";
    begin
        VATEntry.Reset();
        VATEntry.SetRange("Document Type", pDocType);
        VATEntry.SetRange("Document No.", pDocNo);
        if VATEntry.FindSet() then
            repeat
                TaxJurisdiction.Reset();
                TaxJurisdiction.SetRange(Code, VATEntry."Tax Jurisdiction Code");
                if TaxJurisdiction.FindFirst() then
                    if (TaxJurisdiction.JXVZTaxType = TaxJurisdiction.JXVZTaxType::VAT) or (TaxJurisdiction.JXVZTaxType = TaxJurisdiction.JXVZTaxType::VATPerception) then
                        TotalIVAAndPerIVA += abs(VATEntry.Amount);
            until VATEntry.Next() = 0
    end;

    local procedure CalcTaxPerLine
    (
        TaxAreaCode: Code[20];
        TaxGroupCode: Code[20];
        TaxLiable: Boolean;
        Date: Date;
        Amount: Decimal;
        Quantity: Decimal;
        ExchangeRate: Decimal;
        CalcIVA: Boolean;
        CalcPerIVA: Boolean
    ) TaxAmount: decimal
    var
        CompanyInformation: Record "Company Information";
        GenLedgerSetup: Record "General Ledger Setup";
        MaxAmount: Decimal;
        TaxBaseAmount: Decimal;
        Text000: Label '%1 in %2 %3 must be filled in with unique values when %4 is %5.';
        Text001: Label 'The sales tax amount for the %1 %2 and the %3 %4 is incorrect. ';
        Text003: Label 'Lines is not initialized';
        Text004: Label 'The calculated sales tax amount is %5, but was supposed to be %6.';
        TaxArea: Record "Tax Area";
        TaxAreaLine: Record "Tax Area Line";
        TaxDetail: Record "Tax Detail";
        TaxJurisdiction: Record "Tax Jurisdiction";
        TMPTaxDetail: Record "Tax Detail" temporary;
        ExchangeFactor: Decimal;
        TotalTaxAmountRounding: Decimal;
        TotalForAllocation: Decimal;
        RemainingTaxDetails: Integer;
        LastCalculationOrder: Integer;
        Initialised: Boolean;
        FirstLine: Boolean;
        TaxOnTaxCalculated: Boolean;
        CalculationOrderViolation: Boolean;
        CalcThisLine: Boolean;
    begin
        CompanyInformation.get();
        if ((CompanyInformation.JXIsVenezuela())) then begin
            if (CompanyInformation.JXVZMaxDiferenceIVA > 0) then begin

                TaxAmount := 0;
                if not TaxLiable or (TaxAreaCode = '') or (TaxGroupCode = '') or
                   ((Amount = 0) and (Quantity = 0))
                then
                    exit;

                if ExchangeRate = 0 then
                    ExchangeFactor := 1
                else
                    ExchangeFactor := ExchangeRate;

                Amount := Amount / ExchangeFactor;

                TaxAreaLine.SetCurrentKey("Tax Area", "Calculation Order");
                TaxAreaLine.SetRange("Tax Area", TaxAreaCode);
                if TaxAreaLine.Find('+') then begin
                    LastCalculationOrder := TaxAreaLine."Calculation Order" + 1;
                    TaxOnTaxCalculated := false;
                    CalculationOrderViolation := false;
                    repeat
                        CalcThisLine := false;
                        TaxJurisdiction.Reset();
                        TaxJurisdiction.SetRange(Code, TaxAreaLine."Tax Jurisdiction Code");
                        if TaxJurisdiction.FindFirst() then begin
                            if (TaxJurisdiction.JXVZTaxType = TaxJurisdiction.JXVZTaxType::VAT) and (CalcIVA) then
                                CalcThisLine := true;

                            if not CalcThisLine then
                                if (TaxJurisdiction.JXVZTaxType = TaxJurisdiction.JXVZTaxType::VATPerception) and (CalcPerIVA) then
                                    CalcThisLine := true;
                        end;

                        if CalcThisLine then begin
                            if TaxAreaLine."Calculation Order" >= LastCalculationOrder then
                                CalculationOrderViolation := true
                            else
                                LastCalculationOrder := TaxAreaLine."Calculation Order";
                            TaxDetail.Reset();
                            TaxDetail.SetRange("Tax Jurisdiction Code", TaxAreaLine."Tax Jurisdiction Code");
                            if TaxGroupCode = '' then
                                TaxDetail.SetFilter("Tax Group Code", '%1', TaxGroupCode)
                            else
                                TaxDetail.SetFilter("Tax Group Code", '%1|%2', '', TaxGroupCode);
                            if Date = 0D then
                                TaxDetail.SetFilter("Effective Date", '<=%1', WorkDate)
                            else
                                TaxDetail.SetFilter("Effective Date", '<=%1', Date);
                            //Comment when implement for US or MX version
                            TaxDetail.SetRange("Tax Type", TaxDetail."Tax Type"::"Sales Tax");
                            if TaxDetail.FindLast then begin
                                TaxOnTaxCalculated := TaxOnTaxCalculated or TaxDetail."Calculate Tax on Tax";
                                if TaxDetail."Calculate Tax on Tax" then
                                    TaxBaseAmount := Amount + TaxAmount
                                else
                                    TaxBaseAmount := Amount;
                                if (Abs(TaxBaseAmount) <= TaxDetail."Maximum Amount/Qty.") or
                                   (TaxDetail."Maximum Amount/Qty." = 0)
                                then
                                    TaxAmount := TaxAmount + TaxBaseAmount * TaxDetail."Tax Below Maximum" / 100
                                else begin
                                    TaxAmount := TaxAmount + TaxBaseAmount * TaxDetail."Tax Above Maximum" / 100
                                end;
                            end;
                            /*
                            TaxDetail.SetRange("Tax Type", TaxDetail."Tax Type"::"Excise Tax");
                            if TaxDetail.FindLast then
                                if (Abs(Quantity) <= TaxDetail."Maximum Amount/Qty.") or
                                   (TaxDetail."Maximum Amount/Qty." = 0)
                                then
                                    TaxAmount := TaxAmount + Quantity * TaxDetail."Tax Below Maximum"
                                else begin
                                    MaxAmount := Quantity / Abs(Quantity) * TaxDetail."Maximum Amount/Qty.";
                                    TaxAmount :=
                                      TaxAmount + (MaxAmount * TaxDetail."Tax Below Maximum") +
                                      ((Quantity - MaxAmount) * TaxDetail."Tax Above Maximum");
                                end;
                                */
                        end;
                    until TaxAreaLine.Next(-1) = 0;
                    TaxAmount := TaxAmount * ExchangeFactor;

                    GenLedgerSetup.get();
                    if GenLedgerSetup.JXVZRoundIVA <> 0 then
                        TaxAmount := Round(TaxAmount, GenLedgerSetup.JXVZRoundIVA);

                    if TaxOnTaxCalculated and CalculationOrderViolation then
                        Error(
                          Text000,
                          TaxAreaLine.FieldCaption("Calculation Order"), TaxArea.TableCaption, TaxAreaLine."Tax Area",
                          TaxDetail.FieldCaption("Calculate Tax on Tax"), CalculationOrderViolation);
                end;
            end;
        end;
    end;

    local procedure getExchangeRate(DocumentNo: Code[20]): Decimal
    var
        localPurchInvHead: Record "Purch. Inv. Header";
        localPurchCrMemoHead: Record "Purch. Cr. Memo Hdr.";
    begin
        localPurchInvHead.Reset();
        localPurchInvHead.SetRange("No.", DocumentNo);
        if localPurchInvHead.FindFirst() then
            exit(localPurchInvHead."Currency Factor");

        localPurchCrMemoHead.Reset();
        localPurchCrMemoHead.SetRange("No.", DocumentNo);
        if localPurchCrMemoHead.FindFirst() then
            exit(localPurchCrMemoHead."Currency Factor");

        exit(0);
    end;

    //Save withiold by line (finish later)
    local procedure FillWitholdLedgerEntryDoc(_JXVZWithholdCalcLines: Record JXVZWithholdCalcLines; _InvoiceId: Code[20]; _IsInvoice: Boolean;
                                              _WitholdAmount: Decimal; _InvLineNo: Integer; _Base: Decimal)
    var
        JXVZWithholdLedgerEntryByDoc: Record JXVZWithholdLedgerEntryByDoc;
        PurchaseInvHeader: Record "Purch. Inv. Header";
        PurchaseCrMemoHeader: Record "Purch. Cr. Memo Hdr.";
        PurchaseInvLine: Record "Purch. Inv. Line";
        PurchaseCrMemoLine: Record "Purch. Cr. Memo Line";
        Noinsert: Boolean;
    begin
        Noinsert := false;
        JXVZWithholdLedgerEntryByDoc.Reset();
        JXVZWithholdLedgerEntryByDoc.SetRange("Invoice No.", _InvoiceId);
        JXVZWithholdLedgerEntryByDoc.SetRange(InvoiceLineNo, _InvLineNo);
        JXVZWithholdLedgerEntryByDoc.SetRange(JXVZPaymentJournal, _JXVZWithholdCalcLines.JXVZPaymentOrderNo);
        JXVZWithholdLedgerEntryByDoc.SetRange(JXVZWitholdingNo, _JXVZWithholdCalcLines.JXVZWitholdingNo);
        if JXVZWithholdLedgerEntryByDoc.IsEmpty then begin
            JXVZWithholdLedgerEntryByDoc.Init();
            JXVZWithholdLedgerEntryByDoc."No." := JXVZWithholdLedgerEntryByDoc.GetLastNo() + 1;
            JXVZWithholdLedgerEntryByDoc."Invoice No." := _InvoiceId;
            JXVZWithholdLedgerEntryByDoc.JXVZWitholdingAmount := _WitholdAmount;
            JXVZWithholdLedgerEntryByDoc.JXVZPaymentJournal := _JXVZWithholdCalcLines.JXVZPaymentOrderNo;
            JXVZWithholdLedgerEntryByDoc.JXVZBase := _Base;

            if _IsInvoice then begin
                PurchaseInvHeader.Reset();
                PurchaseInvHeader.SetRange("No.", _InvoiceId);
                if PurchaseInvHeader.FindFirst() then begin
                    PurchaseInvLine.Reset();
                    PurchaseInvLine.SetRange("Document No.", _InvoiceId);
                    PurchaseInvLine.SetRange("Line No.", _InvLineNo);
                    if PurchaseInvLine.FindFirst() then
                        if (PurchaseInvLine.JXVZWithholdingCode = 'NO_RETENER') or (PurchaseInvLine.JXVZWithholdingCode = 'NORETENER') then
                            Noinsert := true;

                    PurchaseInvHeader.CalcFields(Amount, "Amount Including VAT");
                    JXVZWithholdLedgerEntryByDoc.InvoiceLineNo := _InvLineNo;
                    JXVZWithholdLedgerEntryByDoc.JXVZVendorCode := PurchaseInvHeader."Pay-to Vendor No.";
                    JXVZWithholdLedgerEntryByDoc.JXVZVoucherAmount := PurchaseInvHeader."Amount Including VAT";
                    JXVZWithholdLedgerEntryByDoc.JXVZInvoiceCurrency := PurchaseInvHeader."Currency Code";
                    JXVZWithholdLedgerEntryByDoc.JXVZExchRate := PurchaseInvHeader."Currency Factor";
                    if JXVZWithholdLedgerEntryByDoc.JXVZInvoiceCurrency <> '' then
                        JXVZWithholdLedgerEntryByDoc.JXVZWitholdingAmountLCY := round((_WitholdAmount * JXVZWithholdLedgerEntryByDoc.JXVZExchRate), 0.01)
                    else
                        JXVZWithholdLedgerEntryByDoc.JXVZWitholdingAmountLCY := _WitholdAmount;
                end;
            end else begin
                PurchaseCrMemoHeader.Reset();
                PurchaseCrMemoHeader.SetRange("No.", _InvoiceId);
                if PurchaseCrMemoHeader.FindFirst() then begin
                    PurchaseCrMemoLine.Reset();
                    PurchaseCrMemoLine.SetRange("Document No.", _InvoiceId);
                    PurchaseCrMemoLine.SetRange("Line No.", _InvLineNo);
                    if PurchaseCrMemoLine.FindFirst() then
                        if (PurchaseCrMemoLine.JXVZWithholdingCode = 'NO_RETENER') or (PurchaseCrMemoLine.JXVZWithholdingCode = 'NORETENER') then
                            Noinsert := true;

                    PurchaseCrMemoHeader.CalcFields(Amount, "Amount Including VAT");
                    JXVZWithholdLedgerEntryByDoc.InvoiceLineNo := _InvLineNo;
                    JXVZWithholdLedgerEntryByDoc.JXVZVendorCode := PurchaseCrMemoHeader."Pay-to Vendor No.";
                    JXVZWithholdLedgerEntryByDoc.JXVZVoucherAmount := PurchaseCrMemoHeader."Amount Including VAT";
                    JXVZWithholdLedgerEntryByDoc.JXVZInvoiceCurrency := PurchaseCrMemoHeader."Currency Code";
                    JXVZWithholdLedgerEntryByDoc.JXVZExchRate := PurchaseCrMemoHeader."Currency Factor";
                    if JXVZWithholdLedgerEntryByDoc.JXVZInvoiceCurrency <> '' then
                        JXVZWithholdLedgerEntryByDoc.JXVZWitholdingAmountLCY := round((_WitholdAmount * JXVZWithholdLedgerEntryByDoc.JXVZExchRate), 0.01)
                    else
                        JXVZWithholdLedgerEntryByDoc.JXVZWitholdingAmountLCY := _WitholdAmount;
                end;
            end;

            JXVZWithholdLedgerEntryByDoc.JXVZTaxCode := _JXVZWithholdCalcLines.JXVZTaxCode;
            JXVZWithholdLedgerEntryByDoc."JXVZWitholding%" := _JXVZWithholdCalcLines."JXVZWitholding%";
            JXVZWithholdLedgerEntryByDoc.JXVZWitholdingDate := _JXVZWithholdCalcLines.JXVZDocumentDate;
            JXVZWithholdLedgerEntryByDoc.JXVZWitholdingNo := _JXVZWithholdCalcLines.JXVZWitholdingNo;
            if not Noinsert then
                JXVZWithholdLedgerEntryByDoc.Insert(false);
        end else begin
            if _WitholdAmount <> 0 then begin
                JXVZWithholdLedgerEntryByDoc.JXVZWitholdingAmount := _WitholdAmount;

                if JXVZWithholdLedgerEntryByDoc.JXVZInvoiceCurrency <> '' then
                    JXVZWithholdLedgerEntryByDoc.JXVZWitholdingAmountLCY := round((_WitholdAmount * JXVZWithholdLedgerEntryByDoc.JXVZExchRate), 0.01)
                else
                    JXVZWithholdLedgerEntryByDoc.JXVZWitholdingAmountLCY := _WitholdAmount;

                if _base <> 0 then
                    JXVZWithholdLedgerEntryByDoc.JXVZBase := _Base;

                JXVZWithholdLedgerEntryByDoc.Modify(false);
            end;
        end;
    end;

    local procedure DeleteWitholdLedgerEntryDoc(_PaymentNo: Code[20]; _InvoiceId: Code[20]; _InvLineNo: Integer)
    var
        JXVZWithholdLedgerEntryByDoc: Record JXVZWithholdLedgerEntryByDoc;
        co: Codeunit "Gen. Jnl.-Post Batch";
    begin
        JXVZWithholdLedgerEntryByDoc.Reset();
        if _InvoiceId <> '' then
            JXVZWithholdLedgerEntryByDoc.SetRange("Invoice No.", _InvoiceId);
        if _InvLineNo <> 0 then
            JXVZWithholdLedgerEntryByDoc.SetRange(InvoiceLineNo, _InvLineNo);
        JXVZWithholdLedgerEntryByDoc.SetRange(JXVZPaymentJournal, _PaymentNo);
        if JXVZWithholdLedgerEntryByDoc.Findset() then
            repeat
                JXVZWithholdLedgerEntryByDoc.Delete();
            until JXVZWithholdLedgerEntryByDoc.Next() = 0;
    end;
}