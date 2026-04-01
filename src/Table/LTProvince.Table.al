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
        field(3; "JXVZAfipCode"; Text[10])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'AFIP code', Comment = 'ESP=Codigo AFIP';
        }
        field(4; "JXVZCotCode"; Code[1])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'COT code', Comment = 'ESP=Codigo COT';
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