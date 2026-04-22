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
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
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
                                    if not JXVZWithholdDetailEntry.JXVZCalcOnPayment then //Verifica si calcula en pagos
                                        continue;

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
                                        //JXVZWithholdScale.Reset();
                                        //JXVZWithholdScale.SetRange(JXVZWithholdScale.JXVZScaleCode, JXVZWithholdDetailEntry.JXVZScaleCode);
                                        //JXVZWithholdScale.SetRange(JXVZWithholdScale.JXVZWitholdingCondition, ConditionCode);
                                        //if JXVZWithholdScale.FindFirst() then begin
                                        if ScaleExistsForSetup(JXVZWithholdDetailEntry, ConditionCode, _DocumentDate) then begin
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
                                                        JXVZWithholdCalcLines.JXVZBaseWitholdingType::NetAmount:
                                                            BaseCalculation := PurchInvLine."VAT Base Amount";

                                                        JXVZWithholdCalcLines.JXVZBaseWitholdingType::TaxAmount:
                                                            BaseCalculation := PurchInvLine."Amount Including VAT";

                                                        JXVZWithholdCalcLines.JXVZBaseWitholdingType::GrossAmount:
                                                            BaseCalculation := PurchInvLine."Amount Including VAT";

                                                        JXVZWithholdCalcLines.JXVZBaseWitholdingType::GrossLessVATAndOtherTaxes:
                                                            BaseCalculation := PurchInvLine.Amount;

                                                        JXVZWithholdCalcLines.JXVZBaseWitholdingType::GrossLessVAT:
                                                            BaseCalculation := PurchInvLine."Amount Including VAT" - GetPostedPurchInvLineVATAmountNormalVAT(PurchInvLine);

                                                        JXVZWithholdCalcLines.JXVZBaseWitholdingType::GrossLessVATAndVATRelatedTaxes:
                                                            BaseCalculation := PurchInvLine."Amount Including VAT" - GetPostedPurchInvLineVATAmountNormalVAT(PurchInvLine);

                                                        JXVZWithholdCalcLines.JXVZBaseWitholdingType::VATOnly:
                                                            BaseCalculation := GetPostedPurchInvLineVATAmountNormalVAT(PurchInvLine);
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
                                                JXVZWithholdCalcLines.JXVZBaseWitholdingType::NetAmount:
                                                    BaseCalculation := PurchCrMemoLine."VAT Base Amount";

                                                JXVZWithholdCalcLines.JXVZBaseWitholdingType::TaxAmount:
                                                    BaseCalculation := PurchCrMemoLine."Amount Including VAT";

                                                JXVZWithholdCalcLines.JXVZBaseWitholdingType::GrossAmount:
                                                    BaseCalculation := PurchCrMemoLine."Amount Including VAT";

                                                JXVZWithholdCalcLines.JXVZBaseWitholdingType::GrossLessVATAndOtherTaxes:
                                                    BaseCalculation := PurchCrMemoLine.Amount;

                                                JXVZWithholdCalcLines.JXVZBaseWitholdingType::GrossLessVAT:
                                                    BaseCalculation := PurchCrMemoLine."Amount Including VAT" - GetPostedPurchCrMemoLineVATAmountNormalVAT(PurchCrMemoLine);

                                                JXVZWithholdCalcLines.JXVZBaseWitholdingType::GrossLessVATAndVATRelatedTaxes:
                                                    BaseCalculation := PurchCrMemoLine."Amount Including VAT" - GetPostedPurchCrMemoLineVATAmountNormalVAT(PurchCrMemoLine);

                                                JXVZWithholdCalcLines.JXVZBaseWitholdingType::VATOnly:
                                                    BaseCalculation := GetPostedPurchCrMemoLineVATAmountNormalVAT(PurchCrMemoLine);
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
        if (JXVZWithholdCalcLines.FindSet()) then
            repeat
                /*
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
                    */
                if ApplyScaleToCalcLine(JXVZWithholdCalcLines, JXVZWithholdCalcLines.JXVZAccumulative, JXVZWithholdCalcLines.JXVZDocumentDate) then
                    JXVZWithholdCalcLines.Modify();
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
                        /*
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
                            */
                        if ApplyScaleToCalcDocument(JXVZWithholdCalcDocument, JXVZWithholdCalcLines) then begin
                            JXVZWithholdCalcDocument.Modify();
                            JXVZWithholdCalcLines.Modify();
                        end;

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

                /*
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
                */

                if ApplyScaleToCalcLine(JXVZWithholdCalcLines, JXVZWithholdAccumCalc.JXVZCalculationBase, JXVZWithholdCalcLines.JXVZDocumentDate) then
                    JXVZWithholdCalcLines.Modify();

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

        RemoveWithholdingsAlreadyCalculatedOnPurchase(_PaymentOrderNro);

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

                                                    JXVZWithholdCalcLines.JXVZBaseWitholdingType::NetAmount:

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

                                                    JXVZWithholdCalcLines.JXVZBaseWitholdingType::TaxAmount:
                                                        if PurchInvoiceHeader.Get(PurchInvoiceLine."Document No.") then
                                                            if PurchInvoiceHeader."Currency Factor" <> 0 then
                                                                JXVZWithholdCalcLines.JXVZAccumulative += ((PercentageAmount *
                                                                      ((PurchInvoiceLine."Amount Including VAT" / PurchInvoiceHeader."Currency Factor")
                                                                                    - (PurchInvoiceLine."VAT Base Amount" / GenJournalLineTmpProcess."Currency Factor"))) / 100)
                                                            else
                                                                JXVZWithholdCalcLines.JXVZAccumulative += ((PercentageAmount * (PurchInvoiceLine."Amount Including VAT"
                                                                                                     - PurchInvoiceLine."VAT Base Amount")) / 100);


                                                    JXVZWithholdCalcLines.JXVZBaseWitholdingType::GrossAmount:
                                                        if PurchInvoiceHeader.Get(PurchInvoiceLine."Document No.") then
                                                            if PurchInvoiceHeader."Currency Factor" <> 0 then
                                                                JXVZWithholdCalcLines.JXVZAccumulative += ((PercentageAmount
                                                                      * (PurchInvoiceLine."Amount Including VAT" / PurchInvoiceHeader."Currency Factor")) / 100)
                                                            else
                                                                JXVZWithholdCalcLines.JXVZAccumulative += ((PercentageAmount * PurchInvoiceLine."Amount Including VAT") / 100);


                                                    JXVZWithholdCalcLines.JXVZBaseWitholdingType::GrossLessVATAndOtherTaxes:
                                                        if PurchInvoiceHeader.Get(PurchInvoiceLine."Document No.") then
                                                            if PurchInvoiceHeader."Currency Factor" <> 0 then
                                                                JXVZWithholdCalcLines.JXVZAccumulative += ((PercentageAmount *
                                                                    (PurchInvoiceLine.Amount / JXVZHistPaymVoucherLine.JXVZCurrencyFactor)) / 100)
                                                            else
                                                                JXVZWithholdCalcLines.JXVZAccumulative += ((PercentageAmount * PurchInvoiceLine.Amount) / 100);

                                                    JXVZWithholdCalcLines.JXVZBaseWitholdingType::GrossLessVAT:
                                                        begin
                                                            baseToCalc := PurchInvoiceLine."Amount Including VAT" - GetPostedPurchInvLineVATAmountNormalVAT(PurchInvoiceLine);

                                                            if PurchInvoiceHeader.Get(PurchInvoiceLine."Document No.") then
                                                                if PurchInvoiceHeader."Currency Factor" <> 0 then
                                                                    JXVZWithholdCalcLines.JXVZAccumulative += ((PercentageAmount *
                                                                        (baseToCalc / JXVZHistPaymVoucherLine.JXVZCurrencyFactor)) / 100)
                                                                else
                                                                    JXVZWithholdCalcLines.JXVZAccumulative += ((PercentageAmount * baseToCalc) / 100);
                                                        end;

                                                    JXVZWithholdCalcLines.JXVZBaseWitholdingType::GrossLessVATAndVATRelatedTaxes:
                                                        begin
                                                            baseToCalc := PurchInvoiceLine."Amount Including VAT" - GetPostedPurchInvLineVATAmountNormalVAT(PurchInvoiceLine);

                                                            if PurchInvoiceHeader.Get(PurchInvoiceLine."Document No.") then
                                                                if PurchInvoiceHeader."Currency Factor" <> 0 then
                                                                    JXVZWithholdCalcLines.JXVZAccumulative += ((PercentageAmount *
                                                                        (baseToCalc / JXVZHistPaymVoucherLine.JXVZCurrencyFactor)) / 100)
                                                                else
                                                                    JXVZWithholdCalcLines.JXVZAccumulative += ((PercentageAmount * baseToCalc) / 100);
                                                        end;

                                                    JXVZWithholdCalcLines.JXVZBaseWitholdingType::VATOnly:
                                                        begin
                                                            baseToCalc := GetPostedPurchInvLineVATAmountNormalVAT(PurchInvoiceLine);

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
                                                            JXVZWithholdCalcLines.JXVZBaseWitholdingType::NetAmount:

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


                                                            JXVZWithholdCalcLines.JXVZBaseWitholdingType::TaxAmount:

                                                                if GenJournalLineTmpProcess."Currency Factor" <> 0 then
                                                                    JXVZWithholdCalcLines.JXVZAccumulative := ((PercentageAmount * ((PurchCrMemoLine."Amount Including VAT" / GenJournalLineTmpProcess."Currency Factor")
                                                                                                          - (PurchCrMemoLine."VAT Base Amount" / GenJournalLineTmpProcess."Currency Factor"))) / 100)
                                                                                                          + JXVZWithholdCalcLines.JXVZAccumulative
                                                                else
                                                                    JXVZWithholdCalcLines.JXVZAccumulative := ((PercentageAmount * (PurchCrMemoLine."Amount Including VAT"
                                                                                                          - PurchCrMemoLine."VAT Base Amount")) / 100) + JXVZWithholdCalcLines.JXVZAccumulative;



                                                            JXVZWithholdCalcLines.JXVZBaseWitholdingType::GrossAmount:

                                                                if GenJournalLineTmpProcess."Currency Factor" <> 0 then
                                                                    JXVZWithholdCalcLines.JXVZAccumulative := ((PercentageAmount * (PurchCrMemoLine."Amount Including VAT" / GenJournalLineTmpProcess."Currency Factor"))
                                                                                                        / 100) + JXVZWithholdCalcLines.JXVZAccumulative
                                                                else
                                                                    JXVZWithholdCalcLines.JXVZAccumulative := ((PercentageAmount * PurchCrMemoLine."Amount Including VAT") / 100) + JXVZWithholdCalcLines.JXVZAccumulative;



                                                            JXVZWithholdCalcLines.JXVZBaseWitholdingType::GrossLessVATAndOtherTaxes:
                                                                if GenJournalLineTmpProcess."Currency Factor" <> 0 then
                                                                    JXVZWithholdCalcLines.JXVZAccumulative := ((PercentageAmount * (PurchCrMemoLine.Amount / GenJournalLineTmpProcess."Currency Factor"))
                                                                                                          / 100) + JXVZWithholdCalcLines.JXVZAccumulative
                                                                else
                                                                    JXVZWithholdCalcLines.JXVZAccumulative := ((PercentageAmount * PurchCrMemoLine.Amount) / 100) + JXVZWithholdCalcLines.JXVZAccumulative;

                                                            JXVZWithholdCalcLines.JXVZBaseWitholdingType::GrossLessVAT:
                                                                begin
                                                                    baseToCalc := PurchCrMemoLine."Amount Including VAT" - GetPostedPurchCrMemoLineVATAmountNormalVAT(PurchCrMemoLine);

                                                                    if PurchCrMemoHeader.Get(PurchCrMemoLine."Document No.") then
                                                                        if PurchCrMemoHeader."Currency Factor" <> 0 then
                                                                            JXVZWithholdCalcLines.JXVZAccumulative -= ((PercentageAmount *
                                                                                (baseToCalc / PurchCrMemoHeader."Currency Factor")) / 100)
                                                                        else
                                                                            JXVZWithholdCalcLines.JXVZAccumulative -= ((PercentageAmount * baseToCalc) / 100);
                                                                end;

                                                            JXVZWithholdCalcLines.JXVZBaseWitholdingType::GrossLessVATAndVATRelatedTaxes:
                                                                begin
                                                                    baseToCalc := PurchCrMemoLine."Amount Including VAT" - GetPostedPurchCrMemoLineVATAmountNormalVAT(PurchCrMemoLine);

                                                                    if PurchCrMemoHeader.Get(PurchCrMemoLine."Document No.") then
                                                                        if PurchCrMemoHeader."Currency Factor" <> 0 then
                                                                            JXVZWithholdCalcLines.JXVZAccumulative -= ((PercentageAmount *
                                                                                (baseToCalc / PurchCrMemoHeader."Currency Factor")) / 100)
                                                                        else
                                                                            JXVZWithholdCalcLines.JXVZAccumulative -= ((PercentageAmount * baseToCalc) / 100);
                                                                end;

                                                            JXVZWithholdCalcLines.JXVZBaseWitholdingType::VATOnly:
                                                                begin
                                                                    baseToCalc := GetPostedPurchCrMemoLineVATAmountNormalVAT(PurchCrMemoLine);

                                                                    if PurchCrMemoHeader.Get(PurchCrMemoLine."Document No.") then
                                                                        if PurchCrMemoHeader."Currency Factor" <> 0 then
                                                                            JXVZWithholdCalcLines.JXVZAccumulative -= ((PercentageAmount *
                                                                                (baseToCalc / PurchCrMemoHeader."Currency Factor")) / 100)
                                                                        else
                                                                            JXVZWithholdCalcLines.JXVZAccumulative -= ((PercentageAmount * baseToCalc) / 100);
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
                    JXVZWithholdCalcLines.JXVZBaseWitholdingType::NetAmount:
                        BaseCalculation := PurchInvHeaderLocal.Amount;
                    JXVZWithholdCalcLines.JXVZBaseWitholdingType::TaxAmount:
                        BaseCalculation := PurchInvHeaderLocal."Amount Including VAT";
                    JXVZWithholdCalcLines.JXVZBaseWitholdingType::GrossAmount:
                        BaseCalculation := PurchInvHeaderLocal."Amount Including VAT";
                    JXVZWithholdCalcLines.JXVZBaseWitholdingType::GrossLessVAT:
                        begin
                            TotalTax := getTotalIVA("Gen. Journal Document Type"::Invoice, PurchInvHeaderLocal."No.");
                            if PurchInvHeaderLocal."Currency Code" <> '' then
                                TotalTax := TotalTax * PurchInvHeaderLocal."Currency Factor";

                            BaseCalculation := PurchInvHeaderLocal."Amount Including VAT" - TotalTax;
                        end;
                    JXVZWithholdCalcLines.JXVZBaseWitholdingType::GrossLessVATAndVATRelatedTaxes:
                        begin
                            TotalTax := getTotalIVAAndPercepIVA("Gen. Journal Document Type"::Invoice, PurchInvHeaderLocal."No.");
                            if PurchInvHeaderLocal."Currency Code" <> '' then
                                TotalTax := TotalTax * PurchInvHeaderLocal."Currency Factor";

                            BaseCalculation := PurchInvHeaderLocal."Amount Including VAT" - TotalTax;
                        end;
                    JXVZWithholdCalcLines.JXVZBaseWitholdingType::VATOnly:
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
                    JXVZWithholdCalcLines.JXVZBaseWitholdingType::NetAmount:
                        BaseCalculation := PurchCrMemoHdrLocal.Amount;
                    JXVZWithholdCalcLines.JXVZBaseWitholdingType::TaxAmount:
                        BaseCalculation := PurchCrMemoHdrLocal."Amount Including VAT";
                    JXVZWithholdCalcLines.JXVZBaseWitholdingType::GrossAmount:
                        BaseCalculation := PurchCrMemoHdrLocal."Amount Including VAT";
                    JXVZWithholdCalcLines.JXVZBaseWitholdingType::GrossLessVAT:
                        begin
                            TotalTax := getTotalIVA("Gen. Journal Document Type"::Invoice, PurchCrMemoHdrLocal."No.");
                            if PurchCrMemoHdrLocal."Currency Code" <> '' then
                                TotalTax := TotalTax * PurchCrMemoHdrLocal."Currency Factor";

                            BaseCalculation := PurchCrMemoHdrLocal."Amount Including VAT" - TotalTax;
                        end;
                    JXVZWithholdCalcLines.JXVZBaseWitholdingType::GrossLessVATAndVATRelatedTaxes:
                        begin
                            TotalTax := getTotalIVAAndPercepIVA("Gen. Journal Document Type"::Invoice, PurchCrMemoHdrLocal."No.");
                            if PurchCrMemoHdrLocal."Currency Code" <> '' then
                                TotalTax := TotalTax * PurchCrMemoHdrLocal."Currency Factor";

                            BaseCalculation := PurchCrMemoHdrLocal."Amount Including VAT" - TotalTax;
                        end;
                    JXVZWithholdCalcLines.JXVZBaseWitholdingType::VATOnly:
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
                                JXVZWithholdCalcLines.JXVZBaseWitholdingType::NetAmount:
                                    BaseCalculation := PurchInvLineLocal.Amount;
                                JXVZWithholdCalcLines.JXVZBaseWitholdingType::TaxAmount:
                                    BaseCalculation := PurchInvHeaderLocal."Amount Including VAT";
                                JXVZWithholdCalcLines.JXVZBaseWitholdingType::GrossAmount:
                                    BaseCalculation := PurchInvHeaderLocal."Amount Including VAT";
                                JXVZWithholdCalcLines.JXVZBaseWitholdingType::GrossLessVAT:
                                    begin
                                        TotalTax := getTotalIVA("Gen. Journal Document Type"::Invoice, PurchInvHeaderLocal."No.");
                                        if PurchInvHeaderLocal."Currency Code" <> '' then
                                            TotalTax := TotalTax * PurchInvHeaderLocal."Currency Factor";

                                        BaseCalculation := PurchInvHeaderLocal."Amount Including VAT" - TotalTax;
                                    end;
                                JXVZWithholdCalcLines.JXVZBaseWitholdingType::GrossLessVATAndVATRelatedTaxes:
                                    begin
                                        TotalTax := getTotalIVAAndPercepIVA("Gen. Journal Document Type"::Invoice, PurchInvHeaderLocal."No.");
                                        if PurchInvHeaderLocal."Currency Code" <> '' then
                                            TotalTax := TotalTax * PurchInvHeaderLocal."Currency Factor";

                                        BaseCalculation := PurchInvHeaderLocal."Amount Including VAT" - TotalTax;
                                    end;
                                JXVZWithholdCalcLines.JXVZBaseWitholdingType::VATOnly:
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
                                JXVZWithholdCalcLines.JXVZBaseWitholdingType::NetAmount:
                                    BaseCalculation := PurchCrMemoLineLocal.Amount;
                                JXVZWithholdCalcLines.JXVZBaseWitholdingType::TaxAmount:
                                    BaseCalculation := PurchCrMemoHdrLocal."Amount Including VAT";
                                JXVZWithholdCalcLines.JXVZBaseWitholdingType::GrossAmount:
                                    BaseCalculation := PurchCrMemoHdrLocal."Amount Including VAT";
                                JXVZWithholdCalcLines.JXVZBaseWitholdingType::GrossLessVAT:
                                    begin
                                        TotalTax := getTotalIVA("Gen. Journal Document Type"::Invoice, PurchCrMemoHdrLocal."No.");
                                        if PurchCrMemoHdrLocal."Currency Code" <> '' then
                                            TotalTax := TotalTax * PurchCrMemoHdrLocal."Currency Factor";

                                        BaseCalculation := PurchCrMemoHdrLocal."Amount Including VAT" - TotalTax;
                                    end;
                                JXVZWithholdCalcLines.JXVZBaseWitholdingType::GrossLessVATAndVATRelatedTaxes:
                                    begin
                                        TotalTax := getTotalIVAAndPercepIVA("Gen. Journal Document Type"::Invoice, PurchCrMemoHdrLocal."No.");
                                        if PurchCrMemoHdrLocal."Currency Code" <> '' then
                                            TotalTax := TotalTax * PurchCrMemoHdrLocal."Currency Factor";

                                        BaseCalculation := PurchCrMemoHdrLocal."Amount Including VAT" - TotalTax;
                                    end;
                                JXVZWithholdCalcLines.JXVZBaseWitholdingType::VATOnly:
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

        if not Vendor.Get(VendorNro) then
            exit;

        JXVZWithholdDetailEntryLocal.Reset();
        JXVZWithholdDetailEntryLocal.SetRange(JXVZWitholdingNo, _RetentionNro);
        if not JXVZWithholdDetailEntryLocal.FindFirst() then
            exit;

        PurchInvHeaderLocal.Reset();
        PurchInvHeaderLocal.SetRange("Pay-to Vendor No.", VendorNro);
        PurchInvHeaderLocal.SetRange("Posting Date", _StartDate, _EndDate);
        if PurchInvHeaderLocal.FindSet() then
            repeat
                Clear(TotalTax);
                PurchInvHeaderLocal.CalcFields(Amount, "Amount Including VAT");

                case JXVZWithholdDetailEntryLocal.JXVZWitholdingBaseType of
                    JXVZWithholdDetailEntryLocal.JXVZWitholdingBaseType::NetAmount:
                        BaseCalculationLocal := PurchInvHeaderLocal.Amount;

                    JXVZWithholdDetailEntryLocal.JXVZWitholdingBaseType::TaxAmount:
                        // Mantengo la lógica actual por compatibilidad funcional
                        BaseCalculationLocal := PurchInvHeaderLocal."Amount Including VAT";

                    JXVZWithholdDetailEntryLocal.JXVZWitholdingBaseType::GrossAmount:
                        BaseCalculationLocal := PurchInvHeaderLocal."Amount Including VAT";

                    JXVZWithholdDetailEntryLocal.JXVZWitholdingBaseType::GrossLessVATAndOtherTaxes:
                        BaseCalculationLocal := PurchInvHeaderLocal.Amount;

                    JXVZWithholdDetailEntryLocal.JXVZWitholdingBaseType::GrossLessVAT:
                        begin
                            TotalTax := GetPostedPurchaseDocumentVATAmountNormalVAT("Gen. Journal Document Type"::Invoice, PurchInvHeaderLocal."No.");
                            if PurchInvHeaderLocal."Currency Code" <> '' then
                                TotalTax := TotalTax * PurchInvHeaderLocal."Currency Factor";

                            BaseCalculationLocal := PurchInvHeaderLocal."Amount Including VAT" - TotalTax;
                        end;

                    JXVZWithholdDetailEntryLocal.JXVZWitholdingBaseType::GrossLessVATAndVATRelatedTaxes:
                        begin
                            // En Normal VAT lo tratamos igual que GrossLessVAT
                            TotalTax := GetPostedPurchaseDocumentVATAmountNormalVAT("Gen. Journal Document Type"::Invoice, PurchInvHeaderLocal."No.");
                            if PurchInvHeaderLocal."Currency Code" <> '' then
                                TotalTax := TotalTax * PurchInvHeaderLocal."Currency Factor";

                            BaseCalculationLocal := PurchInvHeaderLocal."Amount Including VAT" - TotalTax;
                        end;

                    JXVZWithholdDetailEntryLocal.JXVZWitholdingBaseType::VATOnly:
                        begin
                            TotalTax := GetPostedPurchaseDocumentVATAmountNormalVAT("Gen. Journal Document Type"::Invoice, PurchInvHeaderLocal."No.");
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

                case JXVZWithholdDetailEntryLocal.JXVZWitholdingBaseType of
                    JXVZWithholdDetailEntryLocal.JXVZWitholdingBaseType::NetAmount:
                        BaseCalculationLocal := PurchCrMemoHdrLocal.Amount;

                    JXVZWithholdDetailEntryLocal.JXVZWitholdingBaseType::TaxAmount:
                        // Mantengo la lógica actual por compatibilidad funcional
                        BaseCalculationLocal := PurchCrMemoHdrLocal."Amount Including VAT";

                    JXVZWithholdDetailEntryLocal.JXVZWitholdingBaseType::GrossAmount:
                        BaseCalculationLocal := PurchCrMemoHdrLocal."Amount Including VAT";

                    JXVZWithholdDetailEntryLocal.JXVZWitholdingBaseType::GrossLessVATAndOtherTaxes:
                        BaseCalculationLocal := PurchCrMemoHdrLocal.Amount;

                    JXVZWithholdDetailEntryLocal.JXVZWitholdingBaseType::GrossLessVAT:
                        begin
                            TotalTax := GetPostedPurchaseDocumentVATAmountNormalVAT("Gen. Journal Document Type"::"Credit Memo", PurchCrMemoHdrLocal."No.");
                            if PurchCrMemoHdrLocal."Currency Code" <> '' then
                                TotalTax := TotalTax * PurchCrMemoHdrLocal."Currency Factor";

                            BaseCalculationLocal := PurchCrMemoHdrLocal."Amount Including VAT" - TotalTax;
                        end;

                    JXVZWithholdDetailEntryLocal.JXVZWitholdingBaseType::GrossLessVATAndVATRelatedTaxes:
                        begin
                            // En Normal VAT lo tratamos igual que GrossLessVAT
                            TotalTax := GetPostedPurchaseDocumentVATAmountNormalVAT("Gen. Journal Document Type"::"Credit Memo", PurchCrMemoHdrLocal."No.");
                            if PurchCrMemoHdrLocal."Currency Code" <> '' then
                                TotalTax := TotalTax * PurchCrMemoHdrLocal."Currency Factor";

                            BaseCalculationLocal := PurchCrMemoHdrLocal."Amount Including VAT" - TotalTax;
                        end;

                    JXVZWithholdDetailEntryLocal.JXVZWitholdingBaseType::VATOnly:
                        begin
                            TotalTax := GetPostedPurchaseDocumentVATAmountNormalVAT("Gen. Journal Document Type"::"Credit Memo", PurchCrMemoHdrLocal."No.");
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

    local procedure GetPurchaseLineVATAmountNormalVAT(_PurchaseLine: Record "Purchase Line"): Decimal
    begin
        exit(Abs(_PurchaseLine."Amount Including VAT" - _PurchaseLine.Amount));
    end;

    local procedure GetPostedPurchaseDocumentVATAmountNormalVAT(pDocType: Enum "Gen. Journal Document Type"; pDocNo: Code[20]) TotalVAT: Decimal
    var
        VATEntry: Record "VAT Entry";
    begin
        TotalVAT := 0;

        VATEntry.Reset();
        VATEntry.SetRange("Document Type", pDocType);
        VATEntry.SetRange("Document No.", pDocNo);
        if VATEntry.FindSet() then
            repeat
                TotalVAT += Abs(VATEntry.Amount);
            until VATEntry.Next() = 0;
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

    local procedure getTotalIVA(pDocType: Enum "Gen. Journal Document Type"; pDocNo: Code[20]) TotalIVA: Decimal
    var
        VATEntry: Record "VAT Entry";
    begin
        VATEntry.Reset();
        VATEntry.SetRange("Document Type", pDocType);
        VATEntry.SetRange("Document No.", pDocNo);
        if VATEntry.FindSet() then
            repeat
                TotalIVA += Abs(VATEntry.Amount);
            until VATEntry.Next() = 0;
    end;

    local procedure getTotalIVAAndPercepIVA(pDocType: Enum "Gen. Journal Document Type"; pDocNo: Code[20]) TotalIVAAndPerIVA: Decimal
    begin
        exit(getTotalIVA(pDocType, pDocNo));
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

    local procedure ScaleExistsForSetup(_WithholdDetail: Record JXVZWithholdDetailEntry; _ConditionCode: Code[20]; _OperationDate: Date): Boolean
    var
        LocalWithholdScale: Record JXVZWithholdScale;
    begin
        LocalWithholdScale.Reset();
        LocalWithholdScale.SetRange(JXVZScaleCode, _WithholdDetail.JXVZScaleCode);
        LocalWithholdScale.SetRange(JXVZWitholdingCondition, _ConditionCode);
        LocalWithholdScale.SetRange(JXVZTaxCode, _WithholdDetail.JXVZTaxCode);
        LocalWithholdScale.SetRange(JXVZRegime, _WithholdDetail.JXVZRegime);

        if LocalWithholdScale.FindSet() then
            repeat
                if IsScaleValidForDate(LocalWithholdScale, _OperationDate) then
                    exit(true);
            until LocalWithholdScale.Next() = 0;

        exit(false);
    end;

    local procedure ApplyScaleToCalcLine(var _WithholdCalcLine: Record JXVZWithholdCalcLines; _CalculationBase: Decimal; _OperationDate: Date): Boolean
    var
        SelectedScale: Record JXVZWithholdScale;
    begin
        if not TryGetApplicableScale(
                _WithholdCalcLine.JXVZScaleCode,
                _WithholdCalcLine.JXVZWitholdingCondition,
                _WithholdCalcLine.JXVZTaxCode,
                _WithholdCalcLine.JXVZRegime,
                _OperationDate,
                _CalculationBase,
                SelectedScale)
        then
            exit(false);

        _WithholdCalcLine.JXVZCalculatedWitholding := CalculateWithholdingFromScale(_CalculationBase, SelectedScale, _OperationDate);
        _WithholdCalcLine."JXVZWitholding%" := SelectedScale.JXVZSurplus;

        exit(true);
    end;

    local procedure ApplyScaleToCalcDocument(var _WithholdCalcDocument: Record JXVZWithholdCalcDocument; var _WithholdCalcLine: Record JXVZWithholdCalcLines): Boolean
    var
        SelectedScale: Record JXVZWithholdScale;
    begin
        if not TryGetApplicableScale(
                _WithholdCalcLine.JXVZScaleCode,
                _WithholdCalcLine.JXVZWitholdingCondition,
                _WithholdCalcLine.JXVZTaxCode,
                _WithholdCalcLine.JXVZRegime,
                _WithholdCalcDocument.JXVZDocumentDate,
                _WithholdCalcDocument.JXVZCalculationBase,
                SelectedScale)
        then
            exit(false);

        _WithholdCalcDocument.JXVZWitholdingTotalAmount := CalculateWithholdingFromScale(
            _WithholdCalcDocument.JXVZCalculationBase,
            SelectedScale,
            _WithholdCalcDocument.JXVZDocumentDate);

        _WithholdCalcLine."JXVZWitholding%" := SelectedScale.JXVZSurplus;

        exit(true);
    end;

    local procedure TryGetApplicableScale(
        _ScaleCode: Code[20];
        _ConditionCode: Code[20];
        _TaxCode: Code[20];
        _Regime: Code[20];
        _OperationDate: Date;
        _CalculationBase: Decimal;
        var _SelectedScale: Record JXVZWithholdScale): Boolean
    var
        LocalWithholdScale: Record JXVZWithholdScale;
        ScaleSearchBase: Decimal;
    begin
        LocalWithholdScale.Reset();
        LocalWithholdScale.SetRange(JXVZScaleCode, _ScaleCode);
        LocalWithholdScale.SetRange(JXVZWitholdingCondition, _ConditionCode);
        LocalWithholdScale.SetRange(JXVZTaxCode, _TaxCode);
        LocalWithholdScale.SetRange(JXVZRegime, _Regime);

        if LocalWithholdScale.FindSet() then
            repeat
                if IsScaleValidForDate(LocalWithholdScale, _OperationDate) then begin
                    ScaleSearchBase := GetScaleSearchBase(_CalculationBase, LocalWithholdScale, _OperationDate);

                    if IsScaleInRange(LocalWithholdScale, ScaleSearchBase) then begin
                        _SelectedScale := LocalWithholdScale;
                        exit(true);
                    end;
                end;
            until LocalWithholdScale.Next() = 0;

        exit(false);
    end;

    local procedure IsScaleValidForDate(_Scale: Record JXVZWithholdScale; _OperationDate: Date): Boolean
    begin
        if (_Scale.JXVZValidFrom <> 0D) and (_Scale.JXVZValidFrom > _OperationDate) then
            exit(false);

        if (_Scale.JXVZValidTo <> 0D) and (_Scale.JXVZValidTo < _OperationDate) then
            exit(false);

        exit(true);
    end;

    local procedure IsScaleInRange(_Scale: Record JXVZWithholdScale; _ScaleSearchBase: Decimal): Boolean
    begin
        if _Scale.JXVZTo = 0 then
            exit(_Scale.JXVZFrom <= _ScaleSearchBase);

        exit((_Scale.JXVZFrom <= _ScaleSearchBase) and (_Scale.JXVZTo > _ScaleSearchBase));
    end;

    local procedure GetScaleSearchBase(_CalculationBase: Decimal; _Scale: Record JXVZWithholdScale; _OperationDate: Date): Decimal
    var
        TaxableBaseAmount: Decimal;
        TaxUnitValue: Decimal;
    begin
        TaxableBaseAmount := Abs(_CalculationBase) * (GetScaleTaxableBasePct(_Scale) / 100);

        if _Scale.JXVZUseTaxUnit then begin
            TaxUnitValue := GetTaxUnitValue(_OperationDate);
            if TaxUnitValue = 0 then
                exit(0);

            exit(TaxableBaseAmount / TaxUnitValue);
        end;

        exit(TaxableBaseAmount);
    end;

    local procedure GetScaleThresholdBaseAmount(_Scale: Record JXVZWithholdScale; _OperationDate: Date): Decimal
    begin
        if _Scale.JXVZUseTaxUnit then
            exit(_Scale.JXVZBaseAmount * GetTaxUnitValue(_OperationDate));

        exit(_Scale.JXVZBaseAmount);
    end;

    local procedure GetScaleTaxableBasePct(_Scale: Record JXVZWithholdScale): Decimal
    begin
        if _Scale.JXVZTaxableBasePct = 0 then
            exit(100);

        exit(_Scale.JXVZTaxableBasePct);
    end;

    local procedure GetScaleFixedAmount(_Scale: Record JXVZWithholdScale; _OperationDate: Date): Decimal
    begin
        if _Scale.JXVZUseTaxUnit then
            exit(_Scale.JXVZFixedAmount * GetTaxUnitValue(_OperationDate));

        exit(_Scale.JXVZFixedAmount);
    end;

    local procedure GetScaleBaseAmount(_Scale: Record JXVZWithholdScale; _OperationDate: Date): Decimal
    begin
        if _Scale.JXVZUseTaxUnit then
            exit(_Scale.JXVZBaseAmount * GetTaxUnitValue(_OperationDate));

        exit(_Scale.JXVZBaseAmount);
    end;

    local procedure GetScaleDeductionAmount(_Scale: Record JXVZWithholdScale; _OperationDate: Date): Decimal
    begin
        if _Scale.JXVZUseTaxUnit then
            exit(_Scale.JXVZDeductionAmount * GetTaxUnitValue(_OperationDate));

        exit(_Scale.JXVZDeductionAmount);
    end;

    local procedure GetScaleMinimumPaymentAmount(_Scale: Record JXVZWithholdScale; _OperationDate: Date): Decimal
    begin
        if _Scale.JXVZUseTaxUnit then
            exit(_Scale.JXVZMinimumPaymentAmount * GetTaxUnitValue(_OperationDate));

        exit(_Scale.JXVZMinimumPaymentAmount);
    end;

    local procedure CalculateWithholdingFromScale(_CalculationBase: Decimal; _Scale: Record JXVZWithholdScale; _OperationDate: Date): Decimal
    var
        TaxableBaseAmount: Decimal;
        FixedAmount: Decimal;
        ThresholdBaseAmount: Decimal;
        DeductionAmount: Decimal;
        MinimumPaymentAmount: Decimal;
        Result: Decimal;
    begin
        FixedAmount := GetScaleFixedAmount(_Scale, _OperationDate);
        ThresholdBaseAmount := GetScaleThresholdBaseAmount(_Scale, _OperationDate);
        DeductionAmount := GetScaleDeductionAmount(_Scale, _OperationDate);
        MinimumPaymentAmount := GetScaleMinimumPaymentAmount(_Scale, _OperationDate);

        TaxableBaseAmount := Abs(_CalculationBase) * (GetScaleTaxableBasePct(_Scale) / 100);

        // 1. Mínimo sujeto a retención / base mínima
        // Si la base gravable no alcanza el mínimo configurado, no retiene.
        if (ThresholdBaseAmount <> 0) and (TaxableBaseAmount < ThresholdBaseAmount) then
            exit(0);

        case _Scale.JXVZCalculationFormula of
            _Scale.JXVZCalculationFormula::StandardExcess:
                begin
                    if _Scale.JXVZMonotributoIVA then
                        Result := FixedAmount + (Abs(_CalculationBase) * (_Scale.JXVZSurplus / 100))
                    else
                        Result := FixedAmount + ((TaxableBaseAmount - ThresholdBaseAmount) * (_Scale.JXVZSurplus / 100));
                end;

            _Scale.JXVZCalculationFormula::PercentageOnFullBase:
                begin
                    Result := FixedAmount + (TaxableBaseAmount * (_Scale.JXVZSurplus / 100));
                end;

            _Scale.JXVZCalculationFormula::PercentageMinusDeduction:
                begin
                    Result := FixedAmount + (TaxableBaseAmount * (_Scale.JXVZSurplus / 100)) - DeductionAmount;
                end;

            _Scale.JXVZCalculationFormula::Tarifa2Accumulated:
                begin
                    Result := FixedAmount + (TaxableBaseAmount * (_Scale.JXVZSurplus / 100)) - DeductionAmount;
                end;

            _Scale.JXVZCalculationFormula::FixedAmountOnly:
                begin
                    Result := FixedAmount;
                end;

            _Scale.JXVZCalculationFormula::NoWithhold:
                begin
                    Result := 0;
                end;
        end;

        // 2. Si luego del sustraendo queda negativa o en cero, no retiene
        if Result <= 0 then
            exit(0);

        // 3. Mínimo de pago / mínima retención
        if (MinimumPaymentAmount <> 0) and (Result < MinimumPaymentAmount) then
            exit(0);

        exit(Result);
    end;

    local procedure GetTaxUnitValue(_OperationDate: Date): Decimal
    begin
        // TODO:
        // Idealmente este valor debería salir de setup por vigencia.
        // Por ahora se deja fijo según UT vigente utilizada para Venezuela.
        exit(43);
    end;

    local procedure RemoveWithholdingsAlreadyCalculatedOnPurchase(_PaymentOrderNro: Code[20])
    var
        LocalCalcLine: Record JXVZWithholdCalcLines;
        RemainingDocs: Boolean;
        RemovedBase: Decimal;
    begin
        // 1) Retenciones discriminadas por documento:
        // eliminamos solo los documentos que ya tienen retención registrada desde compra.
        LocalCalcLine.Reset();
        LocalCalcLine.SetRange(JXVZPaymentOrderNo, _PaymentOrderNro);
        LocalCalcLine.SetRange(JXVZDistinctPerDocument, true);
        LocalCalcLine.SetRange(JXVZAccumulativePayments, false);
        if LocalCalcLine.FindSet() then
            repeat
                RemoveCalculatedDocumentsAlreadyWithheld(LocalCalcLine);

                JXVZWithholdCalcDocument.Reset();
                JXVZWithholdCalcDocument.SetRange(JXVZPaymentOrderNo, LocalCalcLine.JXVZPaymentOrderNo);
                JXVZWithholdCalcDocument.SetRange(JXVZWitholdingNo, LocalCalcLine.JXVZWitholdingNo);
                RemainingDocs := JXVZWithholdCalcDocument.FindFirst();

                if not RemainingDocs then begin
                    LocalCalcLine.Delete(true);
                end else begin
                    LocalCalcLine.CalcFields(JXVZDiscriminatedCalcWitholding, JXVZDiscriminationCalcBase);
                    LocalCalcLine.JXVZCalculatedWitholding := LocalCalcLine.JXVZDiscriminatedCalcWitholding;
                    LocalCalcLine.JXVZBase := LocalCalcLine.JXVZDiscriminationCalcBase;
                    LocalCalcLine.JXVZAccumulative := LocalCalcLine.JXVZDiscriminationCalcBase;

                    if LocalCalcLine.JXVZAccumulativeCalculation then
                        LocalCalcLine.JXVZCalculatedWitholding := LocalCalcLine.JXVZCalculatedWitholding - LocalCalcLine.JXVZPreviousWitholdings;

                    LocalCalcLine.Modify();
                end;
            until LocalCalcLine.Next() = 0;

        // 2) Retenciones no discriminadas:
        // restamos del acumulado/base los documentos ya retenidos en compra y recalculamos.
        LocalCalcLine.Reset();
        LocalCalcLine.SetRange(JXVZPaymentOrderNo, _PaymentOrderNro);
        LocalCalcLine.SetRange(JXVZDistinctPerDocument, false);
        if LocalCalcLine.FindSet() then
            repeat
                RemovedBase := GetBaseAlreadyWithheldOnPurchase(LocalCalcLine);

                if RemovedBase <> 0 then begin
                    LocalCalcLine.JXVZAccumulative := LocalCalcLine.JXVZAccumulative - RemovedBase;
                    LocalCalcLine.JXVZBase := LocalCalcLine.JXVZBase - RemovedBase;

                    if LocalCalcLine.JXVZAccumulative <= 0 then begin
                        LocalCalcLine.Delete(true);
                    end else begin
                        if ApplyScaleToCalcLine(LocalCalcLine, LocalCalcLine.JXVZAccumulative, LocalCalcLine.JXVZDocumentDate) then begin
                            if LocalCalcLine.JXVZAccumulativeCalculation then
                                LocalCalcLine.JXVZCalculatedWitholding := LocalCalcLine.JXVZCalculatedWitholding - LocalCalcLine.JXVZPreviousWitholdings;

                            LocalCalcLine.Modify();
                        end;
                    end;
                end;
            until LocalCalcLine.Next() = 0;
    end;

    local procedure RemoveCalculatedDocumentsAlreadyWithheld(var _CalcLine: Record JXVZWithholdCalcLines)
    begin
        JXVZWithholdCalcDocument.Reset();
        JXVZWithholdCalcDocument.SetRange(JXVZPaymentOrderNo, _CalcLine.JXVZPaymentOrderNo);
        JXVZWithholdCalcDocument.SetRange(JXVZWitholdingNo, _CalcLine.JXVZWitholdingNo);
        if JXVZWithholdCalcDocument.FindSet() then
            repeat
                if ExistsPurchaseWithholdingInLedger(
                    JXVZWithholdCalcDocument.JXVZDocumentNo,
                    GlobVendor,
                    _CalcLine.JXVZTaxCode,
                    _CalcLine.JXVZRegime,
                    _CalcLine.JXVZWitholdingNo)
                then
                    JXVZWithholdCalcDocument.Delete(true);
            until JXVZWithholdCalcDocument.Next() = 0;
    end;

    local procedure GetBaseAlreadyWithheldOnPurchase(var _CalcLine: Record JXVZWithholdCalcLines): Decimal
    var
        LocalLedgerByDoc: Record JXVZWithholdLedgerEntryByDoc;
        RemovedBase: Decimal;
    begin
        RemovedBase := 0;

        LocalLedgerByDoc.Reset();
        LocalLedgerByDoc.SetRange(JXVZPaymentJournal, _CalcLine.JXVZPaymentOrderNo);
        LocalLedgerByDoc.SetRange(JXVZWitholdingNo, _CalcLine.JXVZWitholdingNo);
        if LocalLedgerByDoc.FindSet() then
            repeat
                if ExistsPurchaseWithholdingInLedger(
                    LocalLedgerByDoc."Invoice No.",
                    GlobVendor,
                    _CalcLine.JXVZTaxCode,
                    _CalcLine.JXVZRegime,
                    _CalcLine.JXVZWitholdingNo)
                then begin
                    RemovedBase += LocalLedgerByDoc.JXVZBase;
                    LocalLedgerByDoc.Delete(true);
                end;
            until LocalLedgerByDoc.Next() = 0;

        exit(RemovedBase);
    end;

    local procedure ExistsPurchaseWithholdingInLedger(
        _DocumentNo: Code[20];
        _VendorNo: Code[20];
        _TaxCode: Code[20];
        _Regime: Code[20];
        _WithholdingNo: Integer): Boolean
    var
        LocalWithholdLedgerEntry: Record JXVZWithholdLedgerEntry;
    begin
        LocalWithholdLedgerEntry.Reset();
        LocalWithholdLedgerEntry.SetRange(JXVZVoucherNo, _DocumentNo);
        LocalWithholdLedgerEntry.SetRange(JXVZVendorCode, _VendorNo);
        LocalWithholdLedgerEntry.SetRange(JXVZTaxCode, _TaxCode);
        LocalWithholdLedgerEntry.SetRange(JXVZRegime, _Regime);
        LocalWithholdLedgerEntry.SetRange(JXVZWitholdingNo, _WithholdingNo);
        LocalWithholdLedgerEntry.SetRange(JXVZWitholdingType, LocalWithholdLedgerEntry.JXVZWitholdingType::Realizada);
        exit(LocalWithholdLedgerEntry.FindFirst());
    end;

    //Purchase
    procedure CalcPurchaseDocument(var _PurchaseHeader: Record "Purchase Header")
    var
        ProcessKey: Code[20];
    begin
        if not (_PurchaseHeader."Document Type" in [_PurchaseHeader."Document Type"::Invoice, _PurchaseHeader."Document Type"::Order, _PurchaseHeader."Document Type"::"Credit Memo"]) then
            exit;

        ProcessKey := _PurchaseHeader."No.";

        DeletePurchaseDocumentTemp(ProcessKey);

        GlobDocumentDate := GetPurchaseOperationDate(_PurchaseHeader);
        GlobVendor := GetPurchaseVendorNo(_PurchaseHeader);
        GlobPaymentOrderNro := ProcessKey;

        PurchaseLine.Reset();
        PurchaseLine.SetRange("Document Type", _PurchaseHeader."Document Type");
        PurchaseLine.SetRange("Document No.", _PurchaseHeader."No.");
        PurchaseLine.SetFilter(Amount, '<>%1', 0);
        if PurchaseLine.FindSet() then
            repeat
                ProcessPurchaseLine(_PurchaseHeader, PurchaseLine, ProcessKey);
            until PurchaseLine.Next() = 0;

        FinalizePurchaseDocumentCalc(_PurchaseHeader, ProcessKey);
    end;

    local procedure DeletePurchaseDocumentTemp(_ProcessKey: Code[20])
    begin
        JXVZWithholdCalcLines.Reset();
        JXVZWithholdCalcLines.SetRange(JXVZPaymentOrderNo, _ProcessKey);
        if JXVZWithholdCalcLines.FindSet() then
            JXVZWithholdCalcLines.DeleteAll(true);

        JXVZWithholdCalcDocument.Reset();
        JXVZWithholdCalcDocument.SetRange(JXVZPaymentOrderNo, _ProcessKey);
        if JXVZWithholdCalcDocument.FindSet() then
            JXVZWithholdCalcDocument.DeleteAll(true);

        JXVZWithholdAccumCalc.Reset();
        JXVZWithholdAccumCalc.SetRange(JXVZPaymentOrderNo, _ProcessKey);
        if JXVZWithholdAccumCalc.FindSet() then
            JXVZWithholdAccumCalc.DeleteAll(true);
    end;

    local procedure ProcessPurchaseLine(var _PurchaseHeader: Record "Purchase Header"; var _PurchaseLine: Record "Purchase Line"; _ProcessKey: Code[20])
    var
        LocalWithholdingTax: Record JXVZWithholdingTax;
        LocalCalcLine: Record JXVZWithholdCalcLines;
        LocalConditionCode: Code[20];
        LocalBaseCalculation: Decimal;
    begin
        if _PurchaseLine.JXVZWithholdingCode = '' then
            exit;

        JXVZWithholdAreaLine.Reset();
        JXVZWithholdAreaLine.SetRange(JXVZWithholdingCode, _PurchaseLine.JXVZWithholdingCode);
        if not JXVZWithholdAreaLine.FindSet() then
            exit;

        repeat
            JXVZWithholdDetailEntry.Reset();
            JXVZWithholdDetailEntry.SetRange(JXVZWitholdingNo, JXVZWithholdAreaLine.JXVZWithholdingNo);
            if JXVZWithholdDetailEntry.FindSet() then
                repeat
                    if not JXVZWithholdDetailEntry.JXVZCalcOnPurchaseDoc then// Si esta en false no calcula
                        continue;

                    LocalWithholdingTax.Reset();
                    LocalWithholdingTax.SetRange(JXVZTaxCode, JXVZWithholdDetailEntry.JXVZTaxCode);
                    LocalWithholdingTax.SetRange(JXVZRetains, true);
                    if not LocalWithholdingTax.FindFirst() then
                        continue;

                    if not VendorAllowedForPurchaseWithholding(_PurchaseHeader, JXVZWithholdDetailEntry.JXVZTaxCode, LocalWithholdingTax) then
                        continue;

                    LocalConditionCode := GetVendorWithholdingCondition(GetPurchaseVendorNo(_PurchaseHeader), JXVZWithholdDetailEntry.JXVZTaxCode);
                    if LocalConditionCode = '' then
                        LocalConditionCode := JXVZWithholdDetailEntry.JXVZConditionCode;

                    if not ScaleExistsForSetup(JXVZWithholdDetailEntry, LocalConditionCode, GetPurchaseOperationDate(_PurchaseHeader)) then
                        continue;

                    GetOrCreatePurchaseCalcLine(
                        _PurchaseHeader,
                        JXVZWithholdDetailEntry,
                        LocalWithholdingTax,
                        LocalConditionCode,
                        _ProcessKey,
                        LocalCalcLine);

                    LocalBaseCalculation := GetPurchaseLineBase(_PurchaseHeader, _PurchaseLine, LocalCalcLine.JXVZBaseWitholdingType);

                    if _PurchaseHeader."Document Type" = _PurchaseHeader."Document Type"::"Credit Memo" then
                        LocalBaseCalculation := -LocalBaseCalculation;

                    if LocalCalcLine.JXVZDistinctPerDocument then
                        UpsertPurchaseCalcDocument(LocalCalcLine, _PurchaseHeader, LocalBaseCalculation)
                    else begin
                        LocalCalcLine.JXVZAccumulative += LocalBaseCalculation;
                        LocalCalcLine.JXVZBase := LocalCalcLine.JXVZAccumulative;
                        LocalCalcLine.Modify();
                    end;
                until JXVZWithholdDetailEntry.Next() = 0;
        until JXVZWithholdAreaLine.Next() = 0;
    end;

    local procedure GetOrCreatePurchaseCalcLine(
        var _PurchaseHeader: Record "Purchase Header";
        var _WithholdDetail: Record JXVZWithholdDetailEntry;
        var _WithholdingTax: Record JXVZWithholdingTax;
        _ConditionCode: Code[20];
        _ProcessKey: Code[20];
        var _CalcLine: Record JXVZWithholdCalcLines)
    var
        NoSeriesManagement: Codeunit "No. Series";
    begin
        _CalcLine.Reset();
        _CalcLine.SetRange(JXVZWitholdingNo, _WithholdDetail.JXVZWitholdingNo);
        _CalcLine.SetRange(JXVZPaymentOrderNo, _ProcessKey);

        if _CalcLine.FindFirst() then
            exit;

        _CalcLine.Init();
        _CalcLine.JXVZTaxCode := _WithholdDetail.JXVZTaxCode;
        _CalcLine.JXVZRegime := _WithholdDetail.JXVZRegime;
        _CalcLine.JXVZDescription := 'Retención - ' + _WithholdingTax.JXVZDescription;
        _CalcLine.JXVZBaseWitholdingType := _WithholdDetail.JXVZWitholdingBaseType;
        _CalcLine.JXVZAccumulativeCalculation := _WithholdDetail.JXVZAccumulativeCalculation;
        _CalcLine.JXVZMinimumWitholding := _WithholdDetail.JXVZMinimumWitholding;
        _CalcLine.JXVZScaleCode := _WithholdDetail.JXVZScaleCode;
        _CalcLine.JXVZWitholdingNo := _WithholdDetail.JXVZWitholdingNo;
        _CalcLine.JXVZCalculatedWitholding := 0;
        _CalcLine.JXVZWitholdingCondition := _ConditionCode;
        _CalcLine.JXVZPaymentOrderNo := _ProcessKey;

        Clear(NoSeriesManagement);
        _WithholdDetail.TestField(JXVZSeriesCode);
        _CalcLine.JXVZWithholdingNumber := NoSeriesManagement.GetNextNo(_WithholdDetail.JXVZSeriesCode, Today(), true);

        _CalcLine.JXVZPaymentMethodCode := _WithholdDetail.JXVZPaymentMethodCode;
        _CalcLine.JXVZAccountNo := _WithholdDetail.JXVZAccountNo;
        _CalcLine.JXVZDocumentDate := GetPurchaseOperationDate(_PurchaseHeader);

        if _WithholdDetail.JXVZAccumulativeCalculation then
            _CalcLine.JXVZAccumulationPeriod := _WithholdDetail.JXVZAccumulationPeriod
        else
            _CalcLine.JXVZAccumulationPeriod := _CalcLine.JXVZAccumulationPeriod::" ";

        _CalcLine.JXVZGeneralWitholdingDescription := _WithholdDetail.JXVZDescription;
        _CalcLine.JXVZDistinctPerDocument := _WithholdDetail.JXVZDiscriminatesPerDocument;
        _CalcLine.JXVZDeterminationPerMonthlyInv := _WithholdDetail.JXVZMonthInvoiceDeter;
        _CalcLine.JXVZMinimumAmountInvPerMonth := _WithholdDetail.JXVZMonthInvoiceMinimunAmt;
        _CalcLine.JXVZWitholdingMode := _WithholdDetail.JXVZWitholdingMode;
        _CalcLine.JXVZAccumulativePayments := false; // En compras abiertas no se usa acumulado por pagos
        _CalcLine.JXVZRetainAllInFirstPayment := false;
        _CalcLine.JXVZMonotributo := _WithholdDetail.JXVZMonotributo;

        _CalcLine.Insert();
    end;

    local procedure UpsertPurchaseCalcDocument(var _CalcLine: Record JXVZWithholdCalcLines; var _PurchaseHeader: Record "Purchase Header"; _BaseCalculation: Decimal)
    begin
        JXVZWithholdCalcDocument.Reset();
        JXVZWithholdCalcDocument.SetRange(JXVZPaymentOrderNo, _CalcLine.JXVZPaymentOrderNo);
        JXVZWithholdCalcDocument.SetRange(JXVZWitholdingNo, _CalcLine.JXVZWitholdingNo);
        JXVZWithholdCalcDocument.SetRange(JXVZDocumentNo, _PurchaseHeader."No.");

        if not JXVZWithholdCalcDocument.FindFirst() then begin
            JXVZWithholdCalcDocument.Init();
            JXVZWithholdCalcDocument.JXVZPaymentOrderNo := _CalcLine.JXVZPaymentOrderNo;
            JXVZWithholdCalcDocument.JXVZWitholdingNo := _CalcLine.JXVZWitholdingNo;
            if _PurchaseHeader."Document Type" = _PurchaseHeader."Document Type"::"Credit Memo" then
                JXVZWithholdCalcDocument.JXVZDocumentType := JXVZWithholdCalcDocument.JXVZDocumentType::"Credit Memo"
            else
                JXVZWithholdCalcDocument.JXVZDocumentType := JXVZWithholdCalcDocument.JXVZDocumentType::Invoice;
            JXVZWithholdCalcDocument.JXVZDocumentNo := _PurchaseHeader."No.";
            JXVZWithholdCalcDocument.JXVZDocumentDate := GetPurchaseOperationDate(_PurchaseHeader);
            JXVZWithholdCalcDocument.JXVZVendorDocumentNo := GetPurchaseExternalDocumentNo(_PurchaseHeader);
            JXVZWithholdCalcDocument.JXVZCalculationBase := _BaseCalculation;
            JXVZWithholdCalcDocument.Insert();
        end else begin
            JXVZWithholdCalcDocument.JXVZCalculationBase += _BaseCalculation;
            JXVZWithholdCalcDocument.Modify();
        end;
    end;

    local procedure FinalizePurchaseDocumentCalc(var _PurchaseHeader: Record "Purchase Header"; _ProcessKey: Code[20])
    begin
        ApplyPurchaseHistoricalAccumulation(_PurchaseHeader, _ProcessKey);
        ApplyPurchaseScales(_ProcessKey);
        ApplyPurchaseVendorExemptions(_PurchaseHeader, _ProcessKey);
        FinalAdjustPurchaseAccumulatedWithholdings(_ProcessKey);
        if _PurchaseHeader."Document Type" <> _PurchaseHeader."Document Type"::"Credit Memo" then
            CleanupPurchaseCalc(_ProcessKey);
    end;

    local procedure ApplyPurchaseHistoricalAccumulation(var _PurchaseHeader: Record "Purchase Header"; _ProcessKey: Code[20])
    var
        StartPeriodLocal: Date;
        EndPeriodLocal: Date;
        PreviousBase: Decimal;
    begin
        JXVZWithholdCalcLines.Reset();
        JXVZWithholdCalcLines.SetRange(JXVZPaymentOrderNo, _ProcessKey);
        if JXVZWithholdCalcLines.FindSet() then
            repeat
                if not (JXVZWithholdCalcLines.JXVZAccumulativeCalculation or JXVZWithholdCalcLines.JXVZDeterminationPerMonthlyInv) then
                    continue;

                GetAccumulationDatesByOperationDate(
                    GetPurchaseOperationDate(_PurchaseHeader),
                    JXVZWithholdCalcLines.JXVZAccumulationPeriod,
                    StartPeriodLocal,
                    EndPeriodLocal);

                if StartPeriodLocal = 0D then
                    Error(Text004Lbl, JXVZWithholdCalcLines.JXVZTaxCode, JXVZWithholdCalcLines.JXVZRegime);

                PreviousBase := CalculaFacturacionDL(
                    GetPurchaseVendorNo(_PurchaseHeader),
                    JXVZWithholdCalcLines.JXVZWitholdingNo,
                    StartPeriodLocal,
                    EndPeriodLocal);

                JXVZWithholdCalcLines.JXVZPreviousPayments := PreviousBase;

                if JXVZWithholdCalcLines.JXVZAccumulativeCalculation then begin
                    JXVZWithholdCalcLines.JXVZAccumulative += PreviousBase;
                    JXVZWithholdCalcLines.JXVZBase := JXVZWithholdCalcLines.JXVZAccumulative;
                    JXVZWithholdCalcLines.JXVZMothlyWitholding := GetHistoricalWithholdingAmount(
                        JXVZWithholdCalcLines.JXVZTaxCode,
                        JXVZWithholdCalcLines.JXVZRegime,
                        GetPurchaseVendorNo(_PurchaseHeader),
                        StartPeriodLocal,
                        EndPeriodLocal);
                end;

                JXVZWithholdCalcLines.Modify();
            until JXVZWithholdCalcLines.Next() = 0;
    end;

    local procedure ApplyPurchaseScales(_ProcessKey: Code[20])
    begin
        JXVZWithholdCalcLines.Reset();
        JXVZWithholdCalcLines.SetRange(JXVZPaymentOrderNo, _ProcessKey);
        JXVZWithholdCalcLines.SetRange(JXVZDistinctPerDocument, false);
        if JXVZWithholdCalcLines.FindSet() then
            repeat
                if ApplyScaleToCalcLine(JXVZWithholdCalcLines, JXVZWithholdCalcLines.JXVZAccumulative, JXVZWithholdCalcLines.JXVZDocumentDate) then
                    JXVZWithholdCalcLines.Modify();
            until JXVZWithholdCalcLines.Next() = 0;

        JXVZWithholdCalcLines.Reset();
        JXVZWithholdCalcLines.SetRange(JXVZPaymentOrderNo, _ProcessKey);
        JXVZWithholdCalcLines.SetRange(JXVZDistinctPerDocument, true);
        if JXVZWithholdCalcLines.FindSet() then
            repeat
                JXVZWithholdCalcDocument.Reset();
                JXVZWithholdCalcDocument.SetRange(JXVZPaymentOrderNo, _ProcessKey);
                JXVZWithholdCalcDocument.SetRange(JXVZWitholdingNo, JXVZWithholdCalcLines.JXVZWitholdingNo);
                if JXVZWithholdCalcDocument.FindSet() then
                    repeat
                        if ApplyScaleToCalcDocument(JXVZWithholdCalcDocument, JXVZWithholdCalcLines) then begin
                            JXVZWithholdCalcDocument.JXVZWitholdingAmount := JXVZWithholdCalcDocument.JXVZWitholdingTotalAmount;
                            JXVZWithholdCalcDocument.Modify();
                        end;
                    until JXVZWithholdCalcDocument.Next() = 0;

                JXVZWithholdCalcLines.CalcFields(JXVZDiscriminatedCalcWitholding, JXVZDiscriminationCalcBase);
                JXVZWithholdCalcLines.JXVZCalculatedWitholding := JXVZWithholdCalcLines.JXVZDiscriminatedCalcWitholding;
                JXVZWithholdCalcLines.JXVZBase := JXVZWithholdCalcLines.JXVZDiscriminationCalcBase;
                JXVZWithholdCalcLines.JXVZAccumulative := JXVZWithholdCalcLines.JXVZDiscriminationCalcBase;
                JXVZWithholdCalcLines.Modify();
            until JXVZWithholdCalcLines.Next() = 0;
    end;

    local procedure ApplyPurchaseVendorExemptions(var _PurchaseHeader: Record "Purchase Header"; _ProcessKey: Code[20])
    begin
        JXVZWithholdCalcLines.Reset();
        JXVZWithholdCalcLines.SetRange(JXVZPaymentOrderNo, _ProcessKey);
        if JXVZWithholdCalcLines.FindSet() then
            repeat
                JXVZVendorExemption.Reset();
                JXVZVendorExemption.SetRange(JXVZVendorCode, GetPurchaseVendorNo(_PurchaseHeader));
                JXVZVendorExemption.SetRange(JXVZTaxCode, JXVZWithholdCalcLines.JXVZTaxCode);
                JXVZVendorExemption.SetRange(JXVZRegime, JXVZWithholdCalcLines.JXVZRegime);
                if JXVZVendorExemption.FindSet() then
                    repeat
                        if (JXVZVendorExemption.JXVZFromDate <= GetPurchaseOperationDate(_PurchaseHeader)) and
                           (JXVZVendorExemption.JXVZToDate >= GetPurchaseOperationDate(_PurchaseHeader))
                        then begin
                            JXVZWithholdCalcLines.JXVZCalculatedWitholding :=
                              JXVZWithholdCalcLines.JXVZCalculatedWitholding -
                              ((JXVZWithholdCalcLines.JXVZCalculatedWitholding * JXVZVendorExemption.JXVZExemptionPercent) / 100);

                            JXVZWithholdCalcLines."JXVZExemption%" := JXVZVendorExemption.JXVZExemptionPercent;
                            JXVZWithholdCalcLines.JXVZCertificateDate := JXVZVendorExemption.JXVZCertificateDate;
                            JXVZWithholdCalcLines.Modify();
                        end;
                    until JXVZVendorExemption.Next() = 0;
            until JXVZWithholdCalcLines.Next() = 0;
    end;

    local procedure FinalAdjustPurchaseAccumulatedWithholdings(_ProcessKey: Code[20])
    begin
        JXVZWithholdCalcLines.Reset();
        JXVZWithholdCalcLines.SetRange(JXVZPaymentOrderNo, _ProcessKey);
        if JXVZWithholdCalcLines.FindSet() then
            repeat
                if JXVZWithholdCalcLines.JXVZAccumulativeCalculation then begin
                    JXVZWithholdCalcLines.JXVZPreviousWitholdings := JXVZWithholdCalcLines.JXVZMothlyWitholding;
                    JXVZWithholdCalcLines.JXVZCalculatedWitholding :=
                        JXVZWithholdCalcLines.JXVZCalculatedWitholding - JXVZWithholdCalcLines.JXVZMothlyWitholding;
                    JXVZWithholdCalcLines.Modify();
                end;
            until JXVZWithholdCalcLines.Next() = 0;
    end;

    local procedure CleanupPurchaseCalc(_ProcessKey: Code[20])
    var
        MonthlyBaseToValidate: Decimal;
    begin
        JXVZWithholdCalcLines.Reset();
        JXVZWithholdCalcLines.SetRange(JXVZPaymentOrderNo, _ProcessKey);
        if JXVZWithholdCalcLines.FindSet() then
            repeat
                MonthlyBaseToValidate := JXVZWithholdCalcLines.JXVZAccumulative + JXVZWithholdCalcLines.JXVZPreviousPayments;

                if (JXVZWithholdCalcLines.JXVZCalculatedWitholding < JXVZWithholdCalcLines.JXVZMinimumWitholding) or
                   (JXVZWithholdCalcLines.JXVZCalculatedWitholding = 0)
                then begin
                    JXVZWithholdCalcLines.Delete(true);
                    continue;
                end;

                if JXVZWithholdCalcLines.JXVZDeterminationPerMonthlyInv then
                    if MonthlyBaseToValidate < JXVZWithholdCalcLines.JXVZMinimumAmountInvPerMonth then begin
                        JXVZWithholdCalcLines.Delete(true);
                        continue;
                    end;
            until JXVZWithholdCalcLines.Next() = 0;

        JXVZWithholdCalcDocument.Reset();
        JXVZWithholdCalcDocument.SetRange(JXVZPaymentOrderNo, _ProcessKey);
        if JXVZWithholdCalcDocument.FindSet() then
            repeat
                JXVZWithholdCalcLines.Reset();
                JXVZWithholdCalcLines.SetRange(JXVZPaymentOrderNo, _ProcessKey);
                JXVZWithholdCalcLines.SetRange(JXVZWitholdingNo, JXVZWithholdCalcDocument.JXVZWitholdingNo);
                if not JXVZWithholdCalcLines.FindFirst() then
                    JXVZWithholdCalcDocument.Delete(true);
            until JXVZWithholdCalcDocument.Next() = 0;
    end;

    local procedure GetPurchaseLineBase(var _PurchaseHeader: Record "Purchase Header"; var _PurchaseLine: Record "Purchase Line"; _BaseType: enum JXVZWithholdBaseType): Decimal
    var
        LocalBaseCalculation: Decimal;
        LocalVATAmount: Decimal;
    begin
        LocalVATAmount := GetPurchaseLineVATAmountNormalVAT(_PurchaseLine);

        case _BaseType of
            _BaseType::NetAmount:
                LocalBaseCalculation := _PurchaseLine."VAT Base Amount";

            _BaseType::TaxAmount:
                LocalBaseCalculation := _PurchaseLine."Amount Including VAT";

            _BaseType::GrossAmount:
                LocalBaseCalculation := _PurchaseLine."Amount Including VAT";

            _BaseType::GrossLessVATAndOtherTaxes:
                LocalBaseCalculation := _PurchaseLine.Amount;

            _BaseType::GrossLessVAT:
                LocalBaseCalculation := _PurchaseLine."Amount Including VAT" - LocalVATAmount;

            _BaseType::GrossLessVATAndVATRelatedTaxes:
                LocalBaseCalculation := _PurchaseLine."Amount Including VAT" - LocalVATAmount;

            _BaseType::VATOnly:
                LocalBaseCalculation := LocalVATAmount;
        end;

        if _PurchaseHeader."Currency Factor" <> 0 then
            LocalBaseCalculation := LocalBaseCalculation / _PurchaseHeader."Currency Factor";

        exit(LocalBaseCalculation);
    end;

    local procedure VendorAllowedForPurchaseWithholding(var _PurchaseHeader: Record "Purchase Header"; _TaxCode: Code[20]; var _WithholdingTax: Record JXVZWithholdingTax): Boolean
    begin
        if _WithholdingTax.JXVZProvince = '' then
            exit(true);

        if (_PurchaseHeader.JXVZProvince <> '') and (_PurchaseHeader.JXVZProvince = _WithholdingTax.JXVZProvince) then
            exit(true);

        if _PurchaseHeader.JXVZProvince = '' then begin
            JXVZVendorWithholdCondition2.Reset();
            JXVZVendorWithholdCondition2.SetRange(JXVZVendorCode, _PurchaseHeader."Buy-from Vendor No.");
            JXVZVendorWithholdCondition2.SetRange(JXVZTaxCode, _TaxCode);
            if JXVZVendorWithholdCondition2.FindFirst() then begin
                JXVZWithholdingTax2.Reset();
                JXVZWithholdingTax2.SetRange(JXVZTaxCode, JXVZVendorWithholdCondition2.JXVZTaxCode);
                if JXVZWithholdingTax2.FindFirst() then
                    if JXVZWithholdingTax2.JXVZProvince <> '' then
                        exit(true);
            end;
        end;

        exit(false);
    end;

    local procedure GetVendorWithholdingCondition(_VendorNo: Code[20]; _TaxCode: Code[20]): Code[20]
    begin
        JXVZVendorWithholdCondition.Reset();
        JXVZVendorWithholdCondition.SetRange(JXVZTaxCode, _TaxCode);
        JXVZVendorWithholdCondition.SetRange(JXVZVendorCode, _VendorNo);
        if JXVZVendorWithholdCondition.FindFirst() then
            exit(JXVZVendorWithholdCondition.JXVZTaxConditionCode);

        exit('');
    end;

    local procedure GetPurchaseVendorNo(var _PurchaseHeader: Record "Purchase Header"): Code[20]
    begin
        if _PurchaseHeader."Pay-to Vendor No." <> '' then
            exit(_PurchaseHeader."Pay-to Vendor No.");

        exit(_PurchaseHeader."Buy-from Vendor No.");
    end;

    local procedure GetPurchaseOperationDate(var _PurchaseHeader: Record "Purchase Header"): Date
    begin
        if _PurchaseHeader."Posting Date" <> 0D then
            exit(_PurchaseHeader."Posting Date");

        if _PurchaseHeader."Document Date" <> 0D then
            exit(_PurchaseHeader."Document Date");

        exit(WorkDate());
    end;

    local procedure GetPurchaseExternalDocumentNo(var _PurchaseHeader: Record "Purchase Header"): Code[35]
    begin
        if _PurchaseHeader."Vendor Cr. Memo No." <> '' then
            exit(_PurchaseHeader."Vendor Cr. Memo No.");

        exit(_PurchaseHeader."Vendor Invoice No.");
    end;

    local procedure GetAccumulationDatesByOperationDate(_OperationDate: Date; _AccumulationPeriod: Option " ","Mes Calendario","Año Calendario","Año Corrido"; var _StartPeriod: Date; var _EndPeriod: Date)
    begin
        _StartPeriod := 0D;
        _EndPeriod := 0D;

        case _AccumulationPeriod of
            _AccumulationPeriod::"Mes Calendario":
                begin
                    _StartPeriod := DMY2Date(1, Date2DMY(_OperationDate, 2), Date2DMY(_OperationDate, 3));
                    _EndPeriod := CalcDate('<CM>', _OperationDate);
                end;

            _AccumulationPeriod::"Año Calendario":
                begin
                    _StartPeriod := DMY2Date(1, 1, Date2DMY(_OperationDate, 3));
                    _EndPeriod := CalcDate('<CY>', _OperationDate);
                end;

            _AccumulationPeriod::"Año Corrido":
                begin
                    _StartPeriod := CalcDate('<-1Y+1D>', _OperationDate);
                    _EndPeriod := _OperationDate;
                end;
        end;
    end;

    local procedure GetHistoricalWithholdingAmount(_TaxCode: Code[20]; _Regime: Code[20]; _VendorNo: Code[20]; _StartPeriod: Date; _EndPeriod: Date): Decimal
    begin
        JXVZWithholdLedgerEntry.Reset();
        JXVZWithholdLedgerEntry.SetCurrentKey(JXVZTaxCode, JXVZVendorCode, JXVZRegime);
        JXVZWithholdLedgerEntry.SetRange(JXVZTaxCode, _TaxCode);
        JXVZWithholdLedgerEntry.SetRange(JXVZVendorCode, _VendorNo);
        JXVZWithholdLedgerEntry.SetRange(JXVZRegime, _Regime);
        JXVZWithholdLedgerEntry.SetRange(JXVZWitholdingDate, _StartPeriod, _EndPeriod);
        JXVZWithholdLedgerEntry.CalcSums(JXVZWitholdingAmount);

        exit(JXVZWithholdLedgerEntry.JXVZWitholdingAmount);
    end;

    procedure PostPurchaseInvoiceWithholdings(var PurchHeader: Record "Purchase Header"; var PurchInvHeader: Record "Purch. Inv. Header")
    begin
        PostPurchaseWithholdings(PurchHeader, PurchInvHeader."No.", PurchInvHeader."Posting Date", PurchInvHeader."Document Date",
            PurchInvHeader."Vendor Invoice No.", false, PurchInvHeader."Dimension Set ID",
            PurchInvHeader."Shortcut Dimension 1 Code", PurchInvHeader."Shortcut Dimension 2 Code");
    end;

    procedure PostPurchaseCrMemoWithholdings(var PurchHeader: Record "Purchase Header"; var PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.")
    begin
        PostPurchaseWithholdings(PurchHeader, PurchCrMemoHdr."No.", PurchCrMemoHdr."Posting Date", PurchCrMemoHdr."Document Date",
            PurchCrMemoHdr."Vendor Cr. Memo No.", true, PurchCrMemoHdr."Dimension Set ID",
            PurchCrMemoHdr."Shortcut Dimension 1 Code", PurchCrMemoHdr."Shortcut Dimension 2 Code");
    end;

    local procedure PostPurchaseWithholdings(
        var PurchHeader: Record "Purchase Header";
        PostedDocNo: Code[20];
        PostingDate: Date;
        DocumentDate: Date;
        ExternalDocumentNo: Code[35];
        IsCreditMemo: Boolean;
        DimensionSetID: Integer;
        ShortcutDim1Code: Code[20];
        ShortcutDim2Code: Code[20])
    var
        ProcessKey: Code[20];
        LocalCalcLine: Record JXVZWithholdCalcLines;
        LocalDetail: Record JXVZWithholdDetailEntry;
        CertificateNo: Code[20];
    begin
        ProcessKey := PurchHeader."No.";

        //CalcPurchaseDocument(PurchHeader); No forzamos recalculo

        LocalCalcLine.Reset();
        LocalCalcLine.SetRange(JXVZPaymentOrderNo, ProcessKey);
        if not LocalCalcLine.FindSet() then
            exit;

        repeat
            if LocalCalcLine.JXVZCalculatedWitholding = 0 then
                continue;

            LocalDetail.Reset();
            LocalDetail.SetRange(JXVZWitholdingNo, LocalCalcLine.JXVZWitholdingNo);
            LocalDetail.SetRange(JXVZTaxCode, LocalCalcLine.JXVZTaxCode);
            LocalDetail.SetRange(JXVZRegime, LocalCalcLine.JXVZRegime);
            if not LocalDetail.FindFirst() then
                Error('No se encontró la configuración de detalle de retención para Impuesto %1, Régimen %2.',
                    LocalCalcLine.JXVZTaxCode, LocalCalcLine.JXVZRegime);

            CertificateNo := GetPurchaseWithholdingCertificateNo(LocalDetail, PostingDate);

            PostPurchaseWithholdingJournalLine(
                PurchHeader,
                LocalDetail,
                LocalCalcLine,
                PostedDocNo,
                PostingDate,
                DocumentDate,
                ExternalDocumentNo,
                IsCreditMemo,
                CertificateNo,
                DimensionSetID,
                ShortcutDim1Code,
                ShortcutDim2Code);

            InsertPurchaseWithholdLedgerEntry(
                PurchHeader,
                LocalDetail,
                LocalCalcLine,
                PostedDocNo,
                PostingDate,
                DocumentDate,
                ExternalDocumentNo,
                IsCreditMemo,
                CertificateNo);
        until LocalCalcLine.Next() = 0;

        DeletePurchaseDocumentTemp(ProcessKey);
    end;

    local procedure PostPurchaseWithholdingJournalLine(
        var PurchHeader: Record "Purchase Header";
        var WithholdDetail: Record JXVZWithholdDetailEntry;
        var WithholdCalcLine: Record JXVZWithholdCalcLines;
        PostedDocNo: Code[20];
        PostingDate: Date;
        DocumentDate: Date;
        ExternalDocumentNo: Code[35];
        IsCreditMemo: Boolean;
        CertificateNo: Code[20];
        DimensionSetID: Integer;
        ShortcutDim1Code: Code[20];
        ShortcutDim2Code: Code[20])
    var
        LocalGenJnlLine: Record "Gen. Journal Line";
        SourceCodeSetup: Record "Source Code Setup";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        JXVZPaymentSetup: Record JXVZPaymentSetup;
        SignFactor: Decimal;
    begin
        SourceCodeSetup.Get();

        if IsCreditMemo then
            SignFactor := -1
        else
            SignFactor := 1;

        JXVZPaymentSetup.Reset();
        if JXVZPaymentSetup.FindFirst() then;

        JXVZPaymentSetup.TestField(JXVZJournalNameWithhold);
        JXVZPaymentSetup.TestField(JXVZJournalBatchWithhold);
        WithholdDetail.TestField(JXVZAccountNo);

        //Delete prev data
        LocalGenJnlLine.Reset();
        LocalGenJnlLine.SetRange("Journal Template Name", JXVZPaymentSetup.JXVZJournalNameWithhold);
        LocalGenJnlLine.SetRange("Journal Batch Name", JXVZPaymentSetup.JXVZJournalBatchWithhold);
        LocalGenJnlLine.DeleteAll();

        LocalGenJnlLine.Reset();
        LocalGenJnlLine.Init();
        LocalGenJnlLine."Journal Template Name" := JXVZPaymentSetup.JXVZJournalNameWithhold;
        LocalGenJnlLine."Journal Batch Name" := JXVZPaymentSetup.JXVZJournalBatchWithhold;
        LocalGenJnlLine."Line No." := 10000;
        LocalGenJnlLine."System-Created Entry" := true;
        LocalGenJnlLine."Source Code" := SourceCodeSetup.Purchases;
        LocalGenJnlLine."Posting Date" := PostingDate;
        LocalGenJnlLine."Document Date" := DocumentDate;
        LocalGenJnlLine."Document No." := PostedDocNo;
        LocalGenJnlLine."External Document No." := ExternalDocumentNo;

        if not IsCreditMemo then begin
            LocalGenJnlLine."Document Type" := LocalGenJnlLine."Document Type"::Payment;
            LocalGenJnlLine."Account Type" := LocalGenJnlLine."Account Type"::Vendor;
            LocalGenJnlLine.Validate("Account No.", GetPurchaseVendorNo(PurchHeader));
        end else begin
            LocalGenJnlLine."Document Type" := LocalGenJnlLine."Document Type"::Refund;
            LocalGenJnlLine."Bal. Account Type" := LocalGenJnlLine."Bal. Account Type"::"G/L Account";
            LocalGenJnlLine.Validate("Bal. Account No.", WithholdDetail.JXVZAccountNo);
        end;

        LocalGenJnlLine.Description := CopyStr(PostedDocNo + ' ' + WithholdCalcLine.JXVZDescription, 1, MaxStrLen(LocalGenJnlLine.Description));

        if not IsCreditMemo then begin
            LocalGenJnlLine."Bal. Account Type" := LocalGenJnlLine."Bal. Account Type"::"G/L Account";
            LocalGenJnlLine.Validate("Bal. Account No.", WithholdDetail.JXVZAccountNo);
        end else begin
            LocalGenJnlLine."Account Type" := LocalGenJnlLine."Account Type"::Vendor;
            LocalGenJnlLine.Validate("Account No.", GetPurchaseVendorNo(PurchHeader));
        end;

        LocalGenJnlLine."Dimension Set ID" := DimensionSetID;
        LocalGenJnlLine."Shortcut Dimension 1 Code" := ShortcutDim1Code;
        LocalGenJnlLine."Shortcut Dimension 2 Code" := ShortcutDim2Code;

        LocalGenJnlLine.Validate("Currency Code", '');
        LocalGenJnlLine.Validate(Amount, Round(Abs(WithholdCalcLine.JXVZCalculatedWitholding) * SignFactor, 0.01));

        LocalGenJnlLine.JXVZIsWitholding := true;
        LocalGenJnlLine.JXVZWitholdingNo := WithholdCalcLine.JXVZWitholdingNo;
        LocalGenJnlLine.JXVZBase := Round(Abs(WithholdCalcLine.JXVZBase) * SignFactor, 0.01);
        LocalGenJnlLine.JXVZValueNoValue := CertificateNo;
        LocalGenJnlLine.JXVZDocumentDateValue := DocumentDate;
        LocalGenJnlLine.JXVZToDateValue := PostingDate;
        LocalGenJnlLine.JXVZAcreditationDateValue := PostingDate;

        GenJnlPostLine.RunWithCheck(LocalGenJnlLine);
    end;

    local procedure InsertPurchaseWithholdLedgerEntry(
        var PurchHeader: Record "Purchase Header";
        var WithholdDetail: Record JXVZWithholdDetailEntry;
        var WithholdCalcLine: Record JXVZWithholdCalcLines;
        PostedDocNo: Code[20];
        PostingDate: Date;
        DocumentDate: Date;
        ExternalDocumentNo: Code[35];
        IsCreditMemo: Boolean;
        CertificateNo: Code[20])
    var
        LocalWithholdLedgerEntry: Record JXVZWithholdLedgerEntry;
        LocalWithholdingTax: Record JXVZWithholdingTax;
        LocalWithholdScale: Record JXVZWithholdScale;
        LocalWithholdTaxCondition: Record JXVZWithholdTaxCondition;
        EntryNo: Integer;
    begin
        LocalWithholdLedgerEntry.Reset();
        if LocalWithholdLedgerEntry.FindLast() then
            EntryNo := LocalWithholdLedgerEntry.JXVZNo + 1
        else
            EntryNo := 1;

        LocalWithholdLedgerEntry.Init();
        LocalWithholdLedgerEntry.JXVZNo := EntryNo;
        LocalWithholdLedgerEntry.JXVZVendorCode := GetPurchaseVendorNo(PurchHeader);
        LocalWithholdLedgerEntry.JXVZWitholdingNo := WithholdCalcLine.JXVZWitholdingNo;
        LocalWithholdLedgerEntry.JXVZVoucherCode := '';
        LocalWithholdLedgerEntry.JXVZVoucherDate := DocumentDate;
        LocalWithholdLedgerEntry.JXVZVoucherNo := PostedDocNo;
        LocalWithholdLedgerEntry.JXVZVoucherAmount := Abs(WithholdCalcLine.JXVZBase);
        LocalWithholdLedgerEntry.JXVZOperationCode := 1;
        LocalWithholdLedgerEntry.JXVZCalculationBase := Abs(WithholdCalcLine.JXVZBase);
        LocalWithholdLedgerEntry.JXVZWitholdingDate := PostingDate;
        LocalWithholdLedgerEntry.JXVZWitholdingCertDate := PostingDate;
        LocalWithholdLedgerEntry.JXVZWitholdingAmount := Abs(WithholdCalcLine.JXVZCalculatedWitholding);
        LocalWithholdLedgerEntry."JXVZExemption%" := WithholdCalcLine."JXVZExemption%";
        LocalWithholdLedgerEntry.JXVZBoletinDate := WithholdCalcLine.JXVZCertificateDate;
        LocalWithholdLedgerEntry.JXVZWitholdingCertificateNo := CertificateNo;
        LocalWithholdLedgerEntry.JXVZWitholdingSeriesNo := '';
        LocalWithholdLedgerEntry.JXVZBase := Abs(WithholdCalcLine.JXVZBase);
        LocalWithholdLedgerEntry.JXVZWitholdingType := LocalWithholdLedgerEntry.JXVZWitholdingType::Realizada;
        LocalWithholdLedgerEntry.JXVZDiscriminatePerDocument := WithholdCalcLine.JXVZDistinctPerDocument;
        LocalWithholdLedgerEntry."JXVZWitholding%" := Abs(WithholdCalcLine."JXVZWitholding%");
        LocalWithholdLedgerEntry.JXVZTaxCode := WithholdDetail.JXVZTaxCode;
        LocalWithholdLedgerEntry.JXVZWitholdingBaseType := WithholdDetail.JXVZWitholdingBaseType;
        LocalWithholdLedgerEntry.JXVZMinimumWitholding := WithholdDetail.JXVZMinimumWitholding;
        LocalWithholdLedgerEntry.JXVZScaleCode := WithholdDetail.JXVZScaleCode;
        LocalWithholdLedgerEntry.JXVZRegime := WithholdDetail.JXVZRegime;

        LocalWithholdingTax.Reset();
        LocalWithholdingTax.SetRange(JXVZTaxCode, WithholdDetail.JXVZTaxCode);
        if LocalWithholdingTax.FindFirst() then
            LocalWithholdLedgerEntry.JXVZProvinceCode := LocalWithholdingTax.JXVZProvince;

        LocalWithholdLedgerEntry.JXVZConditionCode := WithholdCalcLine.JXVZWitholdingCondition;

        LocalWithholdTaxCondition.Reset();
        LocalWithholdTaxCondition.SetRange(JXVZTaxCode, WithholdDetail.JXVZTaxCode);
        if WithholdDetail.JXVZConditionCode <> '' then
            LocalWithholdTaxCondition.SetRange(JXVZConditionCode, WithholdDetail.JXVZConditionCode)
        else
            LocalWithholdTaxCondition.SetRange(JXVZConditionCode, WithholdCalcLine.JXVZWitholdingCondition);
        if LocalWithholdTaxCondition.FindFirst() then
            LocalWithholdLedgerEntry.JXVZSicoreConditionCode := LocalWithholdTaxCondition.JXVZSicoreConditionCode;

        LocalWithholdScale.Reset();
        LocalWithholdScale.SetRange(JXVZScaleCode, WithholdDetail.JXVZScaleCode);
        LocalWithholdScale.SetRange(JXVZTaxCode, WithholdDetail.JXVZTaxCode);
        LocalWithholdScale.SetRange(JXVZRegime, WithholdDetail.JXVZRegime);
        LocalWithholdScale.SetRange(JXVZWitholdingCondition, WithholdCalcLine.JXVZWitholdingCondition);
        if LocalWithholdScale.FindFirst() then;

        LocalWithholdLedgerEntry.JXVZWithholdStatus := LocalWithholdLedgerEntry.JXVZWithholdStatus::Posted;
        LocalWithholdLedgerEntry.Insert();
    end;

    local procedure GetPurchaseWithholdingCertificateNo(var WithholdDetail: Record JXVZWithholdDetailEntry; PostingDate: Date): Code[20]
    var
        NoSeriesManagement: Codeunit "No. Series";
    begin
        if WithholdDetail.JXVZPostingSeriesCode <> '' then
            exit(NoSeriesManagement.GetNextNo(WithholdDetail.JXVZPostingSeriesCode, PostingDate, true));

        if WithholdDetail.JXVZSeriesCode <> '' then
            exit(NoSeriesManagement.GetNextNo(WithholdDetail.JXVZSeriesCode, PostingDate, true));

        exit('');
    end;

    //Helpers actions
    procedure CalculateFromPurchaseDocument(var PurchaseHeader: Record "Purchase Header")
    var
        JXVZWithholdings: Codeunit JXVZWithholdings;
    begin
        PurchaseHeader.TestField("Buy-from Vendor No.");
        PurchaseHeader.TestField("Posting Date");
        PurchaseHeader.TestField("Document Date");
        PurchaseHeader.TestField("No.");

        JXVZWithholdings.CalcPurchaseDocument(PurchaseHeader);
    end;

    procedure ShowCalculatedWithholdings(var PurchaseHeader: Record "Purchase Header")
    var
        CalcLines: Record JXVZWithholdCalcLines;
    begin
        PurchaseHeader.TestField("No.");

        CalcLines.Reset();
        CalcLines.SetRange(JXVZPaymentOrderNo, PurchaseHeader."No.");

        Page.Run(Page::JXVZPurchCalculatedWithholds, CalcLines);
    end;

    //Delete witholds
    procedure DeletePurchaseDocumentWithholdings(var PurchaseHeader: Record "Purchase Header")
    begin
        PurchaseHeader.testfield("No.");
        DeletePurchaseDocumentTemp(PurchaseHeader."No.");
    end;

    procedure DeleteCalculatedWithholdings(var PurchaseHeader: Record "Purchase Header")
    var
        JXVZWithholdings: Codeunit JXVZWithholdings;
    begin
        PurchaseHeader.testfield("No.");
        JXVZWithholdings.DeletePurchaseDocumentWithholdings(PurchaseHeader);
    end;

    local procedure GetPostedPurchInvLineVATAmountNormalVAT(_PurchInvLine: Record "Purch. Inv. Line"): Decimal
    begin
        exit(Abs(_PurchInvLine."Amount Including VAT" - _PurchInvLine.Amount));
    end;

    local procedure GetPostedPurchCrMemoLineVATAmountNormalVAT(_PurchCrMemoLine: Record "Purch. Cr. Memo Line"): Decimal
    begin
        exit(Abs(_PurchCrMemoLine."Amount Including VAT" - _PurchCrMemoLine.Amount));
    end;
}