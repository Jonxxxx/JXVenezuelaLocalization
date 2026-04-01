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

        field(2; JXDescription; Text[50])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Description', Comment = 'ESP=Descripcion';
        }

        field(3; JXVZShipment; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Is Shipment', Comment = 'ESP=Es remito';
        }

        field(4; JXVZCAI; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'CAI', Comment = 'ESP=CAI';
        }
        field(5; JXVZStartDate; Date)
        {
            DataClassification = CustomerContent;
            caption = 'Start Date', Comment = 'ESP=Fecha Inicio';
        }
        field(6; JXVZDueDate; Date)
        {
            DataClassification = CustomerContent;
            caption = 'Due Date', Comment = 'ESP=Fecha vencimiento';
        }
        field(7; JXVZAddress; Text[250])
        {
            DataClassification = CustomerContent;
            caption = 'Address', Comment = 'ESP=Direccion';
        }
        field(8; JXVZAddress2; Text[250])
        {
            DataClassification = CustomerContent;
            caption = 'Address 2', Comment = 'ESP=Direccion 2';
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
        fieldgroup(DropDown; JXVZPointOfSale, JXDescription)
        { }
    }
}