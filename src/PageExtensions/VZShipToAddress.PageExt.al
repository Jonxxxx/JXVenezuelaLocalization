pageextension 84167 JXVZShipToAddress extends "Ship-to Address"
{
    layout
    {

        addbefore("Last Date Modified")
        {
            field(JXVZTaxAreaCode; Rec."Tax Area Code")
            {
                ApplicationArea = All;
                Visible = IsVenezuela;
                ToolTip = 'Tax Area Code';
            }

            field(JXVZTaxLiable; Rec."Tax Liable")
            {
                ApplicationArea = All;
                Visible = IsVenezuela;
                ToolTip = 'Tax Liable';
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