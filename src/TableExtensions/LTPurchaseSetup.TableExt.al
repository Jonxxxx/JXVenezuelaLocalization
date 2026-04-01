tableextension 84128 JXVZPurchaseSetup extends "Purchases & Payables Setup"
{
    fields
    {
        field(84102; JXVZNotValidMultiVendInPaym; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'No validate multi vendors in same payment', Comment = 'ESP=No validar proveedores multiples en un mismo pago';
        }
    }
}