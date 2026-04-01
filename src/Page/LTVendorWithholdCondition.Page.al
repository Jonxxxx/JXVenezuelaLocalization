page 84128 JXVZVendorWithholdCondition
{

    Caption = 'Vendor withhold condition', Comment = 'ESP=Condicion retencion proveedor';
    PageType = List;
    SourceTable = JXVZVendorWithholdCondition;
    //UsageCategory = None;

    layout
    {
        area(content)
        {
            group(Vendor)
            {
                Caption = 'Vendor', Comment = 'ESP=Proveedor';
                field(JXVZVendorCode; Rec.JXVZVendorCode)
                {
                    ApplicationArea = All;
                    Tooltip = 'Vendor code', Comment = 'ESP=Codigo proveedor';
                    Editable = false;
                }
            }
            repeater(ControlRepeat)
            {
                ShowCaption = false;
                field(JXVZTaxCode; Rec.JXVZTaxCode)
                {
                    ApplicationArea = All;
                    Tooltip = 'Tax code', Comment = 'ESP=Codigo impuesto';
                }
                field(JXVZTaxConditionCode; Rec.JXVZTaxConditionCode)
                {
                    ApplicationArea = All;
                    Tooltip = 'Tax condition code', Comment = 'ESP=codigo condicion fiscal';
                }
                /*
                field(JXVZFromDate; JXVZFromDate)
                {
                    ApplicationArea = All;
                    ToolTip = 'From date', Comment = 'ESP=Fecha desde';
                }
                field(JXVZToDate; JXVZToDate)
                {
                    ApplicationArea = All;
                    ToolTip = 'To date', Comment = 'ESP=Fecha hasta';
                }
                */
            }
        }
    }
}

