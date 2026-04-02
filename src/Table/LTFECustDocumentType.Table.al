table 84104 JXVZFECustDocumentType
{
    DataClassification = CustomerContent;
    Caption = 'customer document Type',
                Comment = 'ESP = Cliente tipo documento';
    LookupPageId = JXVZFECustDocumentTypes;

    fields
    {
        field(1; JXVZId; Code[10])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Id', Comment = 'ESP = Id';
        }

        field(2; JXVZDescription; Text[50])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Description', Comment = 'ESP = Descripcion';
        }

        field(3; JXVZSValue; Code[5])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'value', Comment = 'ESP = Valor';
        }
    }

    keys
    {
        key(PK; JXVZId)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; JXVZId, JXVZDescription, JXVZSValue)
        { }
    }
}