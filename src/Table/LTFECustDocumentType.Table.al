table 84104 JXVZFECustDocumentType
{
    DataClassification = CustomerContent;
    Caption = 'FE customer document Type',
                Comment = 'ESP = Cliente tipo documento FE';
    LookupPageId = JXVZFECustDocumentTypes;

    fields
    {
        field(1; JXId; Code[10])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Id', Comment = 'ESP = Id';
        }

        field(2; JXDescription; Text[50])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Description', Comment = 'ESP = Descripcion';
        }

        field(3; JXFEValue; Code[5])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'FE value', Comment = 'ESP = Valor FE';
        }
    }

    keys
    {
        key(PK; JXId)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; JXId, JXDescription, JXFEValue)
        { }
    }
}