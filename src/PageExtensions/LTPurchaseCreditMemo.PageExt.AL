pageextension 84119 JXVZPurchaseCreditMemo extends "Purchase Credit Memo"
{
    layout
    {
        addbefore("Vendor Cr. Memo No.")
        {

            field("JX Posting No."; Rec."Posting No.")
            {
                ApplicationArea = All;
                ToolTip = 'Posting No.', Comment = 'ESP="No. Registro"';
                Editable = ShowSeriesField;
                Enabled = ShowSeriesField;
                Visible = ShowSeriesField;
            }
            field("JX Posting No. Series"; Rec."Posting No. Series")
            {
                ApplicationArea = All;
                ToolTip = 'Posting No. Series', Comment = 'ESP="No. Serie Registro"';
                Editable = ShowSeriesField;
                Enabled = ShowSeriesField;
                Visible = ShowSeriesField;
            }
        }

        addafter("Foreign Trade")
        {
            group(JXVZVenezuela)
            {
                Visible = IsVenezuela;
                Caption = 'Venezuela', Comment = 'ESP=Venezuela';

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

            }
        }
    }

    trigger OnOpenPage()
    begin
        IsVenezuela := CompanyInformation.JXIsVenezuela();
    end;

    var
        CompanyInformation: Record "Company Information";
        PurchSetup: Record "Purchases & Payables Setup";
        GeneralLedgerSetup: Record "General Ledger Setup";


        IsVenezuela: Boolean;
        NotShowInBookVisible: Boolean;
        ShowSeriesField: Boolean;

}