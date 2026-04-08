table 84103 JXVZFEDocumentType
{
    DataClassification = CustomerContent;
    Caption = 'document type',
                Comment = 'ESP = Tipo documento';
    LookupPageId = JXVZFEDocumentTypes;

    fields
    {
        field(1; JXVZId; Code[10])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Id',
                        Comment = 'ESP = Id';
        }

        field(2; JXVZDescription; Text[50])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Description',
                        Comment = 'ESP = Descripcion';
        }

        field(3; JXVZSValue; Code[5])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Value',
                        Comment = 'ESP = Valor';
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