tableextension 84131 JXVZApplicationAreaSetup extends "Application Area Setup"
{
    fields
    {
        field(84100; JXVZshowLATAM; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Show Loc LATAM';
        }

        field(84101; JXVZNotshowLATAM; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Not Show Loc LATAM';
        }
    }
}