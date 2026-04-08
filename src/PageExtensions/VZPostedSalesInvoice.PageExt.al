pageextension 84107 JXVZPostedSalesInvoice extends "Posted Sales Invoice"
{
    layout
    {
        addafter("Foreign Trade")
        {
            group(JXElectronicInvoice)
            {
                Visible = IsVenezuela;
                Caption = 'Venezuela',
                            Comment = 'ESP = Venezuela';
                Editable = false;


                field(JXVZPointOfSale; Rec.JXVZPointOfSale)
                {
                    ApplicationArea = All;
                    ToolTip = 'Point of sale', Comment = 'ESP = Punto de venta';
                }
                field(JXVZFEDocumentType; Rec.JXVZFEDocumentType)
                {
                    Visible = IsVenezuela;
                    ApplicationArea = All;
                    ToolTip = 'document type', Comment = 'ESP = Tipo documento';
                }
                field("JXTax Area Code"; Rec."Tax Area Code")
                {
                    Visible = IsVenezuela;
                    ApplicationArea = all;
                    ToolTip = 'Tax area code', Comment = 'ESP=Codigo area impuesto';
                }

                field(JXVZSTypeVoucher; Rec.JXVZSTypeVoucher)
                {
                    Visible = IsVenezuela;
                    ApplicationArea = All;
                    ToolTip = 'Voucher type for', Comment = 'ESP = Tipo de voucher para';
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