pageextension 84142 JXVZTaxGroups extends "Tax Groups"
{
    layout
    {
        addafter(Description)
        {
            field(JXVZType; rec.JXVZType)
            {
                ApplicationArea = All;
                ToolTip = 'Type', Comment = 'ESP= Tipo';
                Visible = IsVenezuela;
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