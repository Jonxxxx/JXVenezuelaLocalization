page 84123 JXVZWithholdScale
{
    Caption = 'Witholding scale', Comment = 'ESP=Escala retencion';
    PageType = List;
    SourceTable = JXVZWithholdScale;
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field(JXVZScaleCode; Rec.JXVZScaleCode)
                {
                    ApplicationArea = All;
                    Tooltip = 'Scale code', Comment = 'ESP=Codigo escala';
                }
                field(JXVZTaxCode; Rec.JXVZTaxCode)
                {
                    ApplicationArea = All;
                    Tooltip = 'Tax code', Comment = 'ESP=Codigo impuesto';
                }
                field(JXVZWitholdingCondition; Rec.JXVZWitholdingCondition)
                {
                    ApplicationArea = All;
                    Tooltip = 'Witholding condition', Comment = 'ESP=Condicion de retencion';
                }
                field(JXVZFrom; Rec.JXVZFrom)
                {
                    ApplicationArea = All;
                    Tooltip = 'From', Comment = 'ESP=Desde';
                }
                field(JXVZTo; Rec.JXVZTo)
                {
                    ApplicationArea = All;
                    Tooltip = 'To', Comment = 'ESP=Hasta';
                }
                field(JXVZFixedAmount; Rec.JXVZFixedAmount)
                {
                    ApplicationArea = All;
                    Tooltip = 'Fixed amount', Comment = 'ESP=Importe fijo';
                }
                field(JXVZBaseAmount; Rec.JXVZBaseAmount)
                {
                    ApplicationArea = All;
                    Tooltip = 'Base amount', Comment = 'ESP=Importe base';
                }
                field(JXVZSurplus; Rec.JXVZSurplus)
                {
                    ApplicationArea = All;
                    Tooltip = '% surplus', Comment = 'ESP=% excendente';
                }
            }
        }
    }

    actions
    {
    }
}