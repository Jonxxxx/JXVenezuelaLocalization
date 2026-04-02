table 84133 JXVZProvince
{
    Caption = 'Province', Comment = 'ESP=Provincia';
    DrillDownPageID = JXVZProvinces;
    LookupPageID = JXVZProvinces;

    fields
    {
        field(1; JXVZCode; Code[10])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Code', Comment = 'ESP=Codigo';
        }
        field(2; JXVZDescription; Text[30])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Description', Comment = 'ESP=Descripcion';
        }
    }

    keys
    {
        key(Key1; JXVZCode)
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; JXVZCode, JXVZDescription)
        { }
    }
}