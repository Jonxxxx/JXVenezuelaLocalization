pageextension 84138 JXVZVendorList extends "Vendor List"
{
    layout
    {
        addbefore("Balance (LCY)")
        {
            field("JXTax Area Code"; Rec."Tax Area Code")
            {
                Visible = IsVenezuela;
                ApplicationArea = All;
                ToolTip = 'Tax area code', Comment = 'ESP = Codigo area impuesto';
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