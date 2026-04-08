pageextension 84113 JXVZCashReceiptJournal extends "Cash Receipt Journal"
{
    layout
    {
        addlast(Control1)
        {
            field(JXVZValueNoValue; Rec.JXVZValueNoValue)
            {
                Visible = IsVenezuela;
                ToolTip = 'Value no.', Comment = 'ESP=No. value';
                ApplicationArea = All;
            }
            field(JXVZEntityValue; Rec.JXVZEntityValue)
            {
                Visible = IsVenezuela;
                ToolTip = 'Entity value', Comment = 'ESP=Valor entidad';
                ApplicationArea = All;
            }
            field(JXVZDocumentDateValue; Rec.JXVZDocumentDateValue)
            {
                Visible = IsVenezuela;
                ToolTip = 'Document date', Comment = 'ESP=fecha de documento';
                ApplicationArea = All;
            }
            field(JXVZToDateValue; Rec.JXVZToDateValue)
            {
                Visible = IsVenezuela;
                ToolTip = 'To date', Comment = 'ESP=A fecha';
                ApplicationArea = All;
            }
            field(JXVZAcreditationDateValue; Rec.JXVZAcreditationDateValue)
            {
                Visible = IsVenezuela;
                ToolTip = 'Acreditation date', Comment = 'ESP=Fecha acreditacion';
                ApplicationArea = All;
            }
        }

        modify("Account No.")
        {
            trigger OnAfterValidate()
            begin
                CheckCustomerOneLinePerDoc();
            end;
        }

        modify("Document No.")
        {
            trigger OnAfterValidate()
            begin
                CheckCustomerOneLinePerDoc();
            end;
        }
    }

    actions
    {
        addlast(Processing)
        {
            action(JXVZCalcCuadre)
            {
                Visible = IsVenezuela;
                Caption = 'Square operation', Comment = 'ESP=Cuadrar operación';
                Image = Calculate;
                ApplicationArea = all;
                ToolTip = 'Square operation', Comment = 'ESP=Cuadrar operación';

                trigger OnAction()
                var
                    GenJournalLine: Record "Gen. Journal Line";
                    CalcAmount: Decimal;
                begin
                    GenJournalLine.Reset();
                    GenJournalLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                    GenJournalLine.SetRange("Journal Template Name", Rec."Journal Template Name");
                    GenJournalLine.SetRange("Document No.", Rec."Document No.");
                    GenJournalLine.SetFilter("Line No.", '<>%1', rec."Line No.");
                    if GenJournalLine.FindSet() then
                        repeat
                            if rec."Currency Code" = '' then
                                CalcAmount += GenJournalLine."Amount (LCY)"
                            else
                                CalcAmount += GenJournalLine.Amount;
                        until GenJournalLine.Next() = 0;

                    if (CalcAmount <> 0) then begin
                        if rec."Currency Code" = '' then
                            rec.Validate("Amount (LCY)", (abs(CalcAmount) * 1))
                        else
                            rec.Validate("Amount", (abs(CalcAmount) * 1));

                        rec.Modify(false);
                    end;

                    CurrPage.Update();
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        IsVenezuela := CompanyInformation.JXIsVenezuela();
    end;

    local procedure CheckCustomerOneLinePerDoc()
    var
        auxRec: Record "Gen. Journal Line";
        Customer: Record Customer;
        CustomerTmp: Record Customer temporary;
        Totalrecs: Integer;
    begin
        if ((IsVenezuela)) then
            if (rec."Account Type" = rec."Account Type"::Customer) and (rec."Account No." <> '') then begin
                Totalrecs := 1;

                Customer.Reset();
                Customer.SetRange("No.", rec."Account No.");
                if Customer.FindFirst() then begin
                    CustomerTmp.Reset();
                    CustomerTmp.SetRange("VAT Registration No.", DelChr(Customer."VAT Registration No.", '=', '- .,'));
                    if not CustomerTmp.FindFirst() then begin
                        CustomerTmp.Init();
                        CustomerTmp.TransferFields(Customer);
                        CustomerTmp."VAT Registration No." := DelChr(Customer."VAT Registration No.", '=', '- .,');
                        CustomerTmp.Insert();
                    end;
                end;

                auxRec.Reset();
                auxRec.SetRange("Journal Template Name", rec."Journal Template Name");
                auxRec.SetRange("Journal Batch Name", rec."Journal Batch Name");
                auxRec.SetRange("Document No.", rec."Document No.");
                auxRec.SetRange("Account Type", auxRec."Account Type"::Customer);
                if auxRec.FindSet() then
                    repeat
                        Customer.Reset();
                        Customer.SetRange("No.", auxRec."Account No.");
                        if Customer.FindFirst() then begin
                            CustomerTmp.Reset();
                            CustomerTmp.SetRange("VAT Registration No.", DelChr(Customer."VAT Registration No.", '=', '- .,'));
                            if not CustomerTmp.FindFirst() then begin
                                CustomerTmp.Init();
                                CustomerTmp.TransferFields(Customer);
                                CustomerTmp."VAT Registration No." := DelChr(Customer."VAT Registration No.", '=', '- .,');
                                CustomerTmp.Insert();
                                Totalrecs += 1;
                            end;
                        end;

                    until auxRec.Next() = 0;

                if Totalrecs > 1 then
                    Error('Solo puede haber una linea de cliente con el mismo numero de documento');
            end;
    end;

    var
        CompanyInformation: Record "Company Information";


        IsVenezuela: Boolean;

}