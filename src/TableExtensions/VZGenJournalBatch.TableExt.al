tableextension 84111 JXVZGenJournalBatch extends "Gen. Journal Batch"
{
    fields
    {
        field(84100; JXVZReceipt; Boolean)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Manage by receipt', Comment = 'ESP=Gestiona por recibo';
        }

        field(84101; JXVZPaymOrder; Boolean)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Manage by payment order', Comment = 'ESP=Gestionar por orden de pago';
        }
    }
}