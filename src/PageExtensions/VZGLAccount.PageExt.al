pageextension 84127 JXVZGLAccount extends "G/L Account Card"
{
    layout
    {
        addlast(General)
        {
            field(JXVZTaxGroupCode; Rec."Tax Group Code")
            {
                Visible = IsVenezuela;
                ApplicationArea = All;
                ToolTip = 'Tax group code', Comment = 'ESP=Codigo grupo impuesto';
            }
        }

        addafter("Cost Accounting")
        {
            group(JXVZgentineVenezuela)
            {
                Visible = IsVenezuela;
                Caption = 'Venezuela',
                            Comment = 'ESP = Venezuela';

                field(JXVZProvinceCode; Rec.JXVZProvinceCode)
                {
                    ApplicationArea = All;
                    ToolTip = 'Province', Comment = 'ESP=Provincia';
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