tableextension 84129 JXVZGeneralLedgerSetup extends "General Ledger Setup"
{
    fields
    {
        field(84100; JXVZOmmitJournalNegValidation; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Ommit journal negative validation';
        }

        field(84101; JXVZOmmitJournalPosValidation; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Ommit journal positive validation';
        }

        field(84102; JXVZRoundIVA; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 5;
            Caption = 'Round IVA decimals';
        }
    }
}