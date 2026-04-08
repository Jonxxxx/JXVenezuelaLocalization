page 84132 JXVZVendorExemption
{
    Caption = 'Vendor withold exention', Comment = 'ESP=Exencion retenciones proveedores';
    PageType = List;
    SourceTable = JXVZVendorExemption;
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field(JXVZVendorCode; Rec.JXVZVendorCode)
                {
                    Tooltip = 'Vendor code', Comment = 'ESP=Codigo proveedor';
                    ApplicationArea = All;
                }
                field(JXVZTaxCode; Rec.JXVZTaxCode)
                {
                    Tooltip = 'Tax code', Comment = 'ESP=Codigo impuesto';
                    ApplicationArea = All;
                }
                field(JXVZRegime; Rec.JXVZRegime)
                {
                    Tooltip = 'Regime', Comment = 'ESP=Regimen';
                    ApplicationArea = All;
                }
                field(JXVZExemptionPercent; Rec.JXVZExemptionPercent)
                {
                    Tooltip = '% exemption', Comment = 'ESP=% exencion';
                    ApplicationArea = All;
                }
                field(JXVZFromDate; Rec.JXVZFromDate)
                {
                    Tooltip = 'From date', Comment = 'ESP=Fecha desde';
                    ApplicationArea = All;
                }
                field(JXVZToDate; Rec.JXVZToDate)
                {
                    Tooltip = 'To date', Comment = 'ESP=Fecha hasta';
                    ApplicationArea = All;
                }
                field(JXVZCertificateDate; Rec.JXVZCertificateDate)
                {
                    Tooltip = 'Certificate date', Comment = 'ESP=Fecha certificado';
                    ApplicationArea = All;
                }
                field(JXVZComment; Rec.JXVZComment)
                {
                    Tooltip = 'Comment', Comment = 'ESP=Comentario';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}