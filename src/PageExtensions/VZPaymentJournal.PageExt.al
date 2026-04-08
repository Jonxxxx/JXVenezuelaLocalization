pageextension 84115 JXVZPaymentJournal extends "Payment Journal"
{
    layout
    {
        addlast(Control1)
        {
            field(JXVZBase; Rec.JXVZBase)
            {
                Visible = IsVenezuela;
                ApplicationArea = All;
                ToolTip = 'Base amount', Comment = 'ESP=Importe base';

            }
            field(JXVZValueNoValue; Rec.JXVZValueNoValue)
            {
                Visible = IsVenezuela;
                ApplicationArea = All;
                ToolTip = 'Value no.', Comment = 'ESP=No. Valor';

            }
            field(JXVZEntityValue; Rec.JXVZEntityValue)
            {
                Visible = IsVenezuela;
                ApplicationArea = All;
                ToolTip = 'Entity', Comment = 'ESP=Entidad';

            }
            field(JXVZDocumentDateValue; Rec.JXVZDocumentDateValue)
            {
                Visible = IsVenezuela;
                ApplicationArea = All;
                ToolTip = 'Document date', Comment = 'ESP=Fecha documeto';

            }
            field(JXVZToDateValue; Rec.JXVZToDateValue)
            {
                Visible = IsVenezuela;
                ApplicationArea = All;
                ToolTip = 'To date', Comment = 'ESP=A fecha';

            }
            field(JXVZAcreditationDateValue; Rec.JXVZAcreditationDateValue)
            {
                Visible = IsVenezuela;
                ApplicationArea = All;
                ToolTip = 'Acreditation date', Comment = 'ESP=Fecha acreditacion';

            }
        }

        modify("Account No.")
        {
            trigger OnAfterValidate()
            begin
                CheckVendorOneLinePerDoc();
            end;
        }

        modify("Document No.")
        {
            trigger OnAfterValidate()
            begin
                CheckVendorOneLinePerDoc();
            end;
        }
    }

    actions
    {
        addlast(Processing)
        {
            action(JXVZRetentions)
            {
                Visible = IsVenezuela;
                Caption = 'Withholdings', Comment = 'ESP=Retenciones';
                Image = CalculateSalesTax;
                ApplicationArea = All;
                ToolTip = 'Calculate Withholdings', Comment = 'ESP=Calcular Retenciones';

                trigger OnAction()
                var
                    JXVZWithholdCalcLines: Record JXVZWithholdCalcLines;
                    GenJournalLine: Record "Gen. Journal Line";
                    GenJournalLineBus: Record "Gen. Journal Line";
                    GenJournalLineInsert: Record "Gen. Journal Line";
                    JXVZWithholdDetailEntry: Record JXVZWithholdDetailEntry;
                    Retenciones: Codeunit JXVZWithholdings;
                    LineNumber: Integer;

                begin
                    GenJournalLineBus.Reset();
                    GenJournalLineBus.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                    GenJournalLineBus.SetRange("Journal Template Name", Rec."Journal Template Name");
                    GenJournalLineBus.SetRange("Account Type", GenJournalLineBus."Account Type"::Vendor);
                    if GenJournalLineBus.FindSet() then
                        repeat
                            //if Rec."Account Type" <> Rec."Account Type"::Vendor then
                            //    Error('Debe seleccionar una linea con cuenta "Proveedor"')
                            //else begin
                            Retenciones."#DeleteTempTables"(GenJournalLineBus."Document No.");
                            Retenciones."#FindInvoices"(GenJournalLineBus."Document No.", GenJournalLineBus."Document Date", GenJournalLineBus."Account No.");

                            GenJournalLine.Reset();
                            GenJournalLine.SetRange("Journal Batch Name", GenJournalLineBus."Journal Batch Name");
                            GenJournalLine.SetRange("Journal Template Name", GenJournalLineBus."Journal Template Name");
                            GenJournalLine.SetRange("Document No.", GenJournalLineBus."Document No.");
                            if GenJournalLine.FindLast() then
                                LineNumber := GenJournalLine."Line No.";

                            JXVZWithholdCalcLines.RESET();
                            JXVZWithholdCalcLines.SETRANGE(JXVZWithholdCalcLines.JXVZPaymentOrderNo, GenJournalLineBus."Document No.");
                            if JXVZWithholdCalcLines.FindSet() then
                                repeat
                                    LineNumber := LineNumber + 100;

                                    GenJournalLineInsert.Init();
                                    //GenJournalLine.InitNewLine("Posting Date", "Document Date", '', "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", "Dimension Set ID", "Reason Code");
                                    GenJournalLineInsert."Journal Template Name" := GenJournalLineBus."Journal Template Name";
                                    GenJournalLineInsert."Journal Batch Name" := GenJournalLineBus."Journal Batch Name";
                                    GenJournalLineInsert.SetUpNewLine(GenJournalLineBus, 0, false);
                                    GenJournalLineInsert."Line No." := LineNumber;
                                    GenJournalLineInsert.Insert(true);
                                    GenJournalLineInsert."Account Type" := GenJournalLineInsert."Account Type"::"G/L Account";
                                    GenJournalLineInsert."Account No." := JXVZWithholdCalcLines.JXVZAccountNo;
                                    GenJournalLineInsert.Validate("Account No.", JXVZWithholdCalcLines.JXVZAccountNo);
                                    GenJournalLineInsert.Validate(Amount, Round(JXVZWithholdCalcLines.JXVZCalculatedWitholding, 0.01) * -1);
                                    GenJournalLineInsert.Comment := JXVZWithholdCalcLines.JXVZGeneralWitholdingDescription;
                                    GenJournalLineInsert."Payment Method Code" := JXVZWithholdCalcLines.JXVZPaymentMethodCode;
                                    GenJournalLineInsert.JXVZBase := JXVZWithholdCalcLines.JXVZBase * -1;
                                    GenJournalLineInsert.JXVZValueNoValue := JXVZWithholdCalcLines.JXVZWithholdingNumber;
                                    GenJournalLineInsert.JXVZWitholdingNo := JXVZWithholdCalcLines.JXVZWitholdingNo;
                                    GenJournalLineInsert.JXVZIsWitholding := true;

                                    JXVZWithholdDetailEntry.Reset();
                                    JXVZWithholdDetailEntry.SetRange(JXVZWitholdingNo, GenJournalLineInsert.JXVZWitholdingNo);
                                    if JXVZWithholdDetailEntry.FindFirst() then
                                        if JXVZWithholdDetailEntry.JXVZLineDescription <> '' then
                                            GenJournalLineInsert.Description := JXVZWithholdDetailEntry.JXVZLineDescription;

                                    GenJournalLineInsert.Modify();
                                until JXVZWithholdCalcLines.Next() = 0;
                        //end;
                        until GenJournalLineBus.Next() = 0;

                    CurrPage.Update();
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        IsVenezuela := CompanyInformation.JXIsVenezuela();
    end;

    local procedure CheckVendorOneLinePerDoc()
    var
        auxRec: Record "Gen. Journal Line";
        PurchSetup: Record "Purchases & Payables Setup";
        GenJournalBatch: Record "Gen. Journal Batch";
        Totalrecs: Integer;
    begin
        if ((IsVenezuela)) then begin
            PurchSetup.Reset();
            if PurchSetup.FindFirst() then
                if not PurchSetup.JXVZNotValidMultiVendInPaym then begin
                    GenJournalBatch.Reset();
                    GenJournalBatch.SetRange("Journal Template Name", rec."Journal Template Name");
                    GenJournalBatch.SetRange(Name, rec."Journal Batch Name");
                    GenJournalBatch.SetRange(JXVZPaymOrder, true);
                    if GenJournalBatch.FindFirst() then
                        if (rec."Account Type" = rec."Account Type"::Vendor) and (rec."Account No." <> '') then begin
                            Totalrecs := 1;
                            auxRec.Reset();
                            auxRec.SetRange("Journal Template Name", rec."Journal Template Name");
                            auxRec.SetRange("Journal Batch Name", rec."Journal Batch Name");
                            auxRec.SetRange("Document No.", rec."Document No.");
                            auxRec.SetRange("Account Type", auxRec."Account Type"::Vendor);
                            if auxRec.FindSet() then
                                repeat
                                    if auxRec."Account No." <> rec."Account No." then
                                        Totalrecs += 1;
                                until auxRec.Next() = 0;

                            if Totalrecs > 1 then
                                Error('Solo puede haber una linea de proveedor con el mismo numero de documento');
                        end;
                end;
        end;
    end;

    var
        CompanyInformation: Record "Company Information";
        IsVenezuela: Boolean;

}