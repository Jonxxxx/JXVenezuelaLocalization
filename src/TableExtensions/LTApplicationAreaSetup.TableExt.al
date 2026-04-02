tableextension 84131 JXVZApplicationAreaSetup extends "Application Area Setup"
{
    fields
    {
        field(84100; JXVZshowVen; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Show Loc Venezuela';
        }

        field(84101; JXVZNotshowVen; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Not Show Loc Venezuela';
        }
    }
}