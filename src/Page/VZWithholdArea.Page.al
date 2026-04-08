page 84125 JXVZWithholdArea
{
    Caption = 'Withholding area', Comment = 'ESP=Area de retencion';
    PageType = Document;
    SourceTable = JXVZWithholdArea;
    UsageCategory = Documents;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General', Comment = 'ESP=General';
                field(JXVZWithholdingCode; Rec.JXVZWithholdingCode)
                {
                    ApplicationArea = All;
                    ToolTip = 'Withholding code', Comment = 'ESP=Codigo de retencion';
                }
                field(JXVZDescription; Rec.JXVZDescription)
                {
                    ApplicationArea = All;
                    ToolTip = 'Description', Comment = 'ESP=Descripcion';
                }
            }
            part(JXVZWithholdAreaLine; JXVZWithholdAreaLine)
            {
                ApplicationArea = All;
                SubPageLink = JXVZWithholdingCode = FIELD(JXVZWithholdingCode);
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        if "#testWitholding"() then
            Message(TextJXL0024Lbl, Rec.JXVZWithholdingCode);
    end;

    trigger OnClosePage()
    begin
        if "#testWitholding"() then
            Message(TextJXL0024Lbl, Rec.JXVZWithholdingCode);
    end;

    var
        TextJXL0024Lbl: Label 'The behavior %1 does not have all the taxes the company retains';

    procedure "#testWitholding"() lclAlert: Boolean
    var
        JXVZWithholdingTax: Record JXVZWithholdingTax;
        JXVZWithholdAreaLine: Record JXVZWithholdAreaLine;
    begin
        lclAlert := false;

        JXVZWithholdingTax.Reset();
        JXVZWithholdingTax.SetRange(JXVZRetains, true);
        if JXVZWithholdingTax.Find('-') then
            repeat
                if Rec.JXVZWithholdingCode <> '' then begin
                    JXVZWithholdAreaLine.Reset();
                    JXVZWithholdAreaLine.SetRange(JXVZTaxCode, JXVZWithholdingTax.JXVZTaxCode);
                    JXVZWithholdAreaLine.SetRange(JXVZWithholdingCode, Rec.JXVZWithholdingCode);
                    //if not JXVZWithholdAreaLine.Find('-') then
                    if JXVZWithholdAreaLine.IsEmpty() then
                        lclAlert := true;
                end;
            until JXVZWithholdingTax.Next() = 0;
    end;
}

