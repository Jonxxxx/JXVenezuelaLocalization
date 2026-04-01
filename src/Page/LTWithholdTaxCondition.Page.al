page 84121 JXVZWithholdTaxCondition
{
    Caption = 'Withhoding tax conditions', Comment = 'ESP=Condicion de impeusto retenciones';
    PageType = List;
    SourceTable = JXVZWithholdTaxCondition;
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field(JXVZTaxCode; Rec.JXVZTaxCode)
                {
                    ToolTip = 'Tax code', Comment = 'ESP=Codigo Impuesto';
                    ApplicationArea = All;
                }
                field(JXVZConditionCode; Rec.JXVZConditionCode)
                {
                    ToolTip = 'Condition code', Comment = 'ESP=Codigo condicion';
                    ApplicationArea = All;
                }
                field(JXVZDescription; Rec.JXVZDescription)
                {
                    ToolTip = 'Description', Comment = 'ESP=Descripcion';
                    ApplicationArea = All;
                }
            }
        }
    }
}

