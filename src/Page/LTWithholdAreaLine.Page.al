page 84126 JXVZWithholdAreaLine
{
    Caption = 'Withholding area line', Comment = 'ESP=Línea de área de retención';
    PageType = ListPart;
    SourceTable = JXVZWithholdAreaLine;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field(JXVZWithholdingNo; Rec.JXVZWithholdingNo)
                {
                    ApplicationArea = All;
                    ToolTip = 'Withholding no.', Comment = 'ESP=No. Retencion';
                }
                field(JXVZTaxCode; Rec.JXVZTaxCode)
                {
                    ApplicationArea = All;
                    ToolTip = 'Tax code', Comment = 'ESP=Codigo de impuesto';
                    Editable = false;
                }
                field(JXVZRegime; Rec.JXVZRegime)
                {
                    ApplicationArea = All;
                    ToolTip = 'Regime', Comment = 'ESP=Regimen';
                    Editable = false;
                }
                field("#RegimeDesc"; Rec."#RegimeDesc"())
                {
                    ApplicationArea = All;
                    ToolTip = 'Description regime', Comment = 'ESP=Descripcion de regimen';
                    Caption = 'Description regime', Comment = 'ESP=Descripcion de regimen';
                }
            }
        }
    }

    actions
    {
    }
}