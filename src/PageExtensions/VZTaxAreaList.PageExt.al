pageextension 84136 JXVZTaxAreaList extends "Tax Area List"
{
    layout
    {
        addafter(Description)
        {
            field(JXVZSpedificArea; Rec.JXVZSpedificArea)
            {
                Visible = IsVenezuela;
                ApplicationArea = All;
                ToolTip = 'Specific area', Comment = 'Area especifico';
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