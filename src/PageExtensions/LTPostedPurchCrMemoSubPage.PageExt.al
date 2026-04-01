pageextension 84137 JXVZPostedPurchCrMemoSubPage extends "Posted Purch. Cr. Memo Subform"
{
    layout
    {
        addafter("Line Amount")
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

            field(JXVZWithholdingCode; Rec.JXVZWithholdingCode)
            {
                Visible = IsVenezuela;
                ApplicationArea = all;
                ToolTip = 'Withholding code', Comment = 'ESP=Codigo retencion';
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