pageextension 84139 JXVZPurchaseSetup extends "Purchases & Payables Setup"
{
    layout
    {
        addlast(General)
        {
            field(JXVZSerieAutoInvoice; Rec.JXVZSerieAutoInvoice)
            {
                ApplicationArea = All;
                ToolTip = 'Serie Auto-Invoice';
                Visible = IsVenezuela;
            }

            field(JXVZNotValidMultiVendInPaym; rec.JXVZNotValidMultiVendInPaym)
            {
                ApplicationArea = All;
                Visible = IsVenezuela;
                ToolTip = 'No validate multi vendors in same payment', Comment = 'ESP=No validar proveedores multiples en un mismo pago';
            }
        }
    }

    var
        CompanyInformation: Record "Company Information";


        IsVenezuela: Boolean;

    trigger OnOpenPage()
    begin
        IsVenezuela := CompanyInformation.JXIsVenezuela();


    end;
}