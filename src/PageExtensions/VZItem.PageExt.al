pageextension 84126 JXVZItem extends "Item Card"
{
    layout
    {
        addafter(Warehouse)
        {
            group(JXVZgentineVenezuela)
            {
                Visible = IsVenezuela;
                Caption = 'Venezuela',
                            Comment = 'ESP = Venezuela';

                field(JXVZTaxGroupCode; Rec."Tax Group Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Tax group code', Comment = 'ESP=Codigo grupo impuesto';
                }
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