table 84138 JXVZTempTable
{

    DataClassification = CustomerContent;

    fields
    {
        field(1; pKey; Integer)
        {
            DataClassification = OrganizationIdentifiableInformation;

        }
        field(2; PostingDate; Date)
        {
            DataClassification = OrganizationIdentifiableInformation;
        }
        field(3; Revert; Boolean)
        {
            DataClassification = OrganizationIdentifiableInformation;
        }
        field(4; User; text[250])
        {
            DataClassification = OrganizationIdentifiableInformation;

        }
    }

    keys
    {
        key(PK; pKey)
        {
            Clustered = true;
        }
    }
}