table 84103 JXVZFEDocumentType
{
    DataClassification = CustomerContent;
    Caption = 'FE document type',
                Comment = 'ESP = Tipo documento FE';
    LookupPageId = JXVZFEDocumentTypes;

    fields
    {
        field(1; JXId; Code[10])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Id',
                        Comment = 'ESP = Id';
        }

        field(2; JXDescription; Text[50])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Description',
                        Comment = 'ESP = Descripcion';
        }

        field(3; JXFEValue; Code[5])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'FE Value',
                        Comment = 'ESP = Valor FE';
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