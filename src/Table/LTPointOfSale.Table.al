table 84100 JXVZPointOfSale
{
    DataClassification = CustomerContent;
    LookupPageId = JXVZPointOfSale;

    fields
    {
        field(1; JXVZPointOfSale; Code[5])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Point of sale', comment = 'ESP="Punto de venta"';
        }

        field(2; JXVZDescription; Text[50])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Description', Comment = 'ESP=Descripcion';
        }

    }

    keys
    {
        key(PK; JXVZPointOfSale)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; JXVZPointOfSale, JXVZDescription)
        { }
    }
}