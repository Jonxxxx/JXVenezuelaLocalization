pageextension 84108 JXVZPostedSalesCrMemo extends "Posted Sales Credit Memo"
{
    layout
    {

        addafter("Shipping and Billing")
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
                    ApplicationArea = all;
                    ToolTip = 'Tax area code', Comment = 'ESP=Codigo area impuesto';
                }

                field(JXVZSTypeVoucher; Rec.JXVZSTypeVoucher)
                {
                    Visible = IsVenezuela;
                    ApplicationArea = All;
                    ToolTip = 'Voucher type for', Comment = 'ESP = Tipo de voucher para';
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