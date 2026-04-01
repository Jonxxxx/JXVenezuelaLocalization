page 84120 JXVZWithholdingTax
{
    Caption = 'Withholding taxes', Comment = 'ESP=Impuesto retenciones';
    PageType = List;
    SourceTable = JXVZWithholdingTax;
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
                    ApplicationArea = All;
                    Tooltip = 'Tax code', Comment = 'ESP=Codigo impuesto';
                }
                field(JXVZTax; Rec.JXVZTax)
                {
                    ApplicationArea = All;
                    Tooltip = 'Tax', Comment = 'ESP=Impuesto';
                }
                field(JXVZDescription; Rec.JXVZDescription)
                {
                    ApplicationArea = All;
                    Tooltip = 'Description', Comment = 'ESP=Descripcion';
                }
                field(JXVZProvince; Rec.JXVZProvince)
                {
                    ApplicationArea = All;
                    Tooltip = 'Province', Comment = 'ESP=Provincia';
                }
                field(JXVZRetains; Rec.JXVZRetains)
                {
                    ApplicationArea = All;
                    Tooltip = 'Retains', Comment = 'ESP=Retiene';
                }
                field(JXVZTaxType; Rec.JXVZTaxType)
                {
                    ApplicationArea = All;
                    Tooltip = 'Tax type', Comment = 'ESP=Tipo de impuesto';
                }
                field(JXVZSicoreCode; rec.JXVZSicoreCode)
                {
                    ApplicationArea = All;
                    Tooltip = 'Sicore Code', Comment = 'ESP=Codigo Sicore';
                }
            }
        }
    }

    actions
    {
    }
}