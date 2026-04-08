pageextension 84103 JXVZCustomer extends "Customer Card"
{
    layout
    {
        addafter(Shipping)
        {
            group(JXElectronicInvoice)
            {
                Visible = IsVenezuela;

                Caption = 'Venezuela',
                            Comment = 'ESP = Venezuela';

                field(JXVZFEDocumentType; Rec.JXVZFEDocumentType)
                {
                    ApplicationArea = All;
                    ToolTip = 'document type', Comment = 'ESP = Tipo documento';
                }
                field(JXVZFiscalType; Rec.JXVZFiscalType)
                {
                    ApplicationArea = All;
                    ToolTip = 'Fiscal type', Comment = 'ESP = Tipo fiscal';
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

                //7345 - COT
                field(JXVZProvinceCode; Rec.JXVZProvinceCode)
                {
                    ApplicationArea = All;
                    ToolTip = 'Province', Comment = 'ESP=Provincia';
                }
                //7345 - COT END
                field(JXVZPointofSale; Rec.JXVZPointofSale)
                {
                    ApplicationArea = All;
                    ToolTip = 'Point of sale',
                        Comment = 'ESP = "Punto de venta"';
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