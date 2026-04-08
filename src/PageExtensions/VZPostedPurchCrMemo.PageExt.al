pageextension 84124 JXVZPostedPurchCrMemo extends "Posted Purchase Credit Memo"
{
    layout
    {
        addafter("Pay-to")
        {
            group(JXVZVenezuela)
            {
                Visible = IsVenezuela;
                Caption = 'Venezuela', Comment = 'ESP=Venezuela';

                field(JXVZInvoiceType; Rec.JXVZInvoiceType)
                {
                    ApplicationArea = all;
                    ToolTip = 'Invoice type', Comment = 'ESP=Tipo factura';
                }
                field(JXVZFiscalType; Rec.JXVZFiscalType)
                {
                    ApplicationArea = all;
                    ToolTip = 'Fiscal type', Comment = 'ESP=Tipo fiscal';
                }
                field(JXVZProvince; Rec.JXVZProvince)
                {
                    ApplicationArea = all;
                    ToolTip = 'Province code', Comment = 'ESP=Codigo provincia';
                }
                field(JXVZWithholdingCode; Rec.JXVZWithholdingCode)
                {
                    ApplicationArea = all;
                    ToolTip = 'Withholding code', Comment = 'ESP=Codigo retencion';
                }
                field("JXTax Area Code"; Rec."Tax Area Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Tax area code', Comment = 'ESP=Codigo area impuesto';
                }
                field("JXTax Liable"; Rec."Tax Liable")
                {
                    ApplicationArea = all;
                    ToolTip = 'Tax liable', Comment = 'ESP=Sujeto a impuestos';
                }
                field(JXVZCtrlDocumentNo; Rec.JXVZCtrlDocumentNo)
                {
                    ApplicationArea = all;
                    Visible = IsVenezuela;
                    ToolTip = 'Control Document No.';
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