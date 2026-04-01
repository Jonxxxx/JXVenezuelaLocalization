table 84136 JXVZSetupCustomsPerceptions
{
    Caption = 'Setup customs perceptions', comment = 'ESP=Configuración percepciones aduaneras';


    fields
    {
        field(1; JXVZProvince; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            TableRelation = JXVZProvince;
            Caption = 'Province', comment = 'ESP=Provincia';
        }
        field(2; JXVZAliquot; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            DecimalPlaces = 4 : 4;
            Caption = 'Aliquot', comment = 'ESP=Alicuota';
        }
        field(3; JXVZCoefficient; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            DecimalPlaces = 4 : 4;
            Caption = 'Coefficient', comment = 'ESP=Coeficiente';
        }
    }

    keys
    {
        key(Key1; JXVZProvince)
        {
        }
    }

    fieldgroups
    {
    }
}

