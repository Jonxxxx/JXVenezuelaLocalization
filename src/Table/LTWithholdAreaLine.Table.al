table 84121 JXVZWithholdAreaLine
{
    Caption = 'Withholding area line', Comment = 'ESP=Línea de área de retención';
    LookupPageID = JXVZWithholdAreaList;

    fields
    {
        field(1; JXVZWithholdingNo; Integer)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Withholding no.', Comment = 'ESP=No. Retencion';
            Editable = true;
            TableRelation = JXVZWithholdDetailEntry.JXVZWitholdingNo;

            trigger OnValidate()
            var
                lclWithDetEntry: Record JXVZWithholdDetailEntry;
                lclWithBehavLine: Record JXVZWithholdAreaLine;
            begin
                lclWithDetEntry.Reset();
                lclWithDetEntry.SetCurrentKey(JXVZWitholdingNo);
                lclWithDetEntry.SetRange(JXVZWitholdingNo, JXVZWithholdingNo);
                if lclWithDetEntry.FindFirst() then
                    if lclWithDetEntry.JXVZWitholdingNo <> 0 then begin
                        lclWithBehavLine.Reset();
                        lclWithBehavLine.SetRange(JXVZWithholdingCode, JXVZWithholdingCode);
                        lclWithBehavLine.SetRange(JXVZTaxCode, lclWithDetEntry.JXVZTaxCode);
                        if lclWithBehavLine.IsEmpty() then begin
                            JXVZTaxCode := lclWithDetEntry.JXVZTaxCode;
                            JXVZRegime := lclWithDetEntry.JXVZRegime;
                        end else begin
                            Clear(JXVZWithholdingNo);
                            Message('', lclWithDetEntry.JXVZTaxCode);
                        end;
                    end;
            end;
        }
        field(2; JXVZWithholdingCode; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Withholding code', Comment = 'ESP=Codigo de retencion';
            TableRelation = JXVZWithholdArea;
        }
        field(3; JXVZTaxCode; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Tax code', Comment = 'ESP=Codigo de impuesto';
            Editable = false;
            NotBlank = true;
            TableRelation = JXVZWithholdDetailEntry.JXVZTaxCode;
        }
        field(5; JXVZRegime; Code[10])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Regime', Comment = 'ESP=Regimen';
            Editable = false;
            TableRelation = JXVZWithholdDetailEntry.JXVZRegime;
        }
    }

    keys
    {
        key(Key1; JXVZWithholdingNo, JXVZWithholdingCode)
        {
        }
        key(Key2; JXVZWithholdingCode)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if JXVZWithholdingNo = 0 then
            Delete();
    end;

    procedure "#RegimeDesc"(): Text[100]
    var
        JXVZWithholdDetailEntry: Record JXVZWithholdDetailEntry;
    begin
        if JXVZWithholdingNo <> 0 then begin
            JXVZWithholdDetailEntry.Reset();
            JXVZWithholdDetailEntry.SetCurrentKey(JXVZWitholdingNo, JXVZTaxCode, JXVZRegime);
            if JXVZWithholdDetailEntry.Get(JXVZWithholdingNo, JXVZTaxCode, JXVZRegime) then
                exit(JXVZWithholdDetailEntry.JXVZDescription);
        end;
        exit('')
    end;
}