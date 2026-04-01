pageextension 84111 JXVZTaxJurisdiction extends "Tax Jurisdictions"
{
    layout
    {
        addafter("Report-to Jurisdiction")
        {
            field(JXTaxType; Rec.JXTaxType)
            {
                Visible = IsVenezuela;
                ApplicationArea = All;
                ToolTip = 'Tax type', Comment = 'ESP = Tipo de impuesto';
            }
            field(JXVAType; Rec.JXVAType)
            {
                Visible = IsVenezuela;
                ApplicationArea = All;
                ToolTip = 'VAT type', Comment = 'ESP = Tipo de IVA';
            }



        }
    }

    trigger OnOpenPage()
    begin
        IsVenezuela := CompanyInformation.JXIsVenezuela();


    end;

    var
        CompanyInformation: Record "Company Information";


        IsVenezuela: Boolean;
}