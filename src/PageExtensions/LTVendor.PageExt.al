pageextension 84116 JXVZVendor extends "Vendor Card"
{
    layout
    {
        addafter(Receiving)
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

                field(JXVZFEDocumentType; Rec.JXVZFEDocumentType)
                {
                    ApplicationArea = all;
                    ToolTip = 'Document type', Comment = 'ESP=Tipo documento';
                }


                field(JXVZProvinceCode; Rec.JXVZProvinceCode)
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
                    ApplicationArea = All;
                    ToolTip = 'Tax area code', Comment = 'ESP = Codigo area impuesto';
                }
                field("JXTax Liable"; Rec."Tax Liable")
                {
                    ApplicationArea = All;
                    ToolTip = 'Tax liable', Comment = 'ESP = Sujeto a impuestos';
                }
            }
        }
    }

    actions
    {
        addlast(Navigation)
        {
            action(JXVZWithholdings)
            {
                Visible = IsVenezuela;
                Caption = 'Withholding setup', Comment = 'ESP=Configurar retenciones';
                ApplicationArea = all;
                ToolTip = 'Withholding setup Venezuela', Comment = 'ESP=Configurar retenciones Venezuela';
                Image = TaxSetup;

                Promoted = true;

                trigger OnAction()
                var
                    JXVZVendorWithholdCondition: Record JXVZVendorWithholdCondition;
                    JXVZVendorWithholdConditionPage: Page JXVZVendorWithholdCondition;
                begin
                    Rec.TestField(JXVZWithholdingCode);

                    clear(JXVZVendorWithholdConditionPage);
                    JXVZVendorWithholdCondition.Reset();
                    JXVZVendorWithholdCondition.SetRange(JXVZVendorCode, Rec."No.");
                    JXVZVendorWithholdConditionPage.SetTableView(JXVZVendorWithholdCondition);
                    JXVZVendorWithholdConditionPage.RunModal();
                end;
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

