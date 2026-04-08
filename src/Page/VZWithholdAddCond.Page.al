page 84127 JXVZWithholdAddCond
{
    Caption = 'Withholding additional condition', Comment = 'ESP=Condicion retencion adicional';
    PageType = List;
    SourceTable = JXVZWithholdAddCond;
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field(JXVZWithholdingNo; Rec.JXVZWithholdingNo)
                {
                    Tooltip = 'Withholding no.', Comment = 'ESP=No. Retencion';
                    ApplicationArea = All;
                }
                field(JXVZType; Rec.JXVZType)
                {
                    Tooltip = 'Type', Comment = 'ESP=Tipo';
                    ApplicationArea = All;
                }
                field(JXVZWithholdingCode; Rec.JXVZWithholdingCode)
                {
                    Tooltip = 'Withholding code', Comment = 'ESP=Codigo retencion';
                    ApplicationArea = All;
                }
            }
        }
    }
}