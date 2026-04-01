pageextension 84133 JXVZSalesInvoiceSubPage extends "Sales Invoice Subform"
{
    layout
    {
        addbefore(Quantity)
        {
            field("JXTax Area Code"; Rec."Tax Area Code")
            {
                Visible = IsVenezuela;
                ApplicationArea = all;
                ToolTip = 'Tax area code', Comment = 'ESP=Codigo area impuesto';
            }
            field("JXTax Group Code"; Rec."Tax Group Code")
            {
                Visible = IsVenezuela;
                ApplicationArea = all;
                ToolTip = 'Tax group code', Comment = 'ESP=Codigo grupo impuesto';
            }
            field("JXTax Liable"; Rec."Tax Liable")
            {
                Visible = IsVenezuela;
                ApplicationArea = all;
                ToolTip = 'Tax liable', Comment = 'ESP=Sujeto a impuestos';
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