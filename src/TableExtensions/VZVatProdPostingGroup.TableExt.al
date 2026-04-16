tableextension 84102 JXVZVatProdPostingGroup extends "VAT Product Posting Group"
{
    fields
    {
        field(84100; JXVZVatPurchReport; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Libro de IVA Venezuela';
            OptionMembers = Exento,Exonerado,Tercero,Internas,Importaciones,"Internas Gravadas Aliciota Reducida","IVA Retenido","ISLR Retenido";
        }
    }
}