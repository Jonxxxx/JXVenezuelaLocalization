table 84134 JXVZExportFilesTmp
{
    Caption = 'Export files temp.', Comment = 'ESP=Exportacion de archivos temporales';

    fields
    {
        field(1; pKey; Integer)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'pKey', Comment = 'ESP=Clave';
        }
        field(2; Field1; Text[1024])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Field 1', Comment = 'ESP=Campo 1';
        }
        field(3; Field2; Text[250])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Field 2', Comment = 'ESP=Campo 2';
        }
        field(4; Field3; Text[250])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Field 3', Comment = 'ESP=Campo 3';
        }
        field(5; Field4; Text[250])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Field 4', Comment = 'ESP=Campo 4';
        }
        field(6; Field5; Text[250])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Field 5', Comment = 'ESP=Campo 5';
        }
        field(7; Field6; Text[250])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Field 6', Comment = 'ESP=Campo 6';
        }
        field(8; Field7; Text[250])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Field 7', Comment = 'ESP=Campo 7';
        }
        field(9; Field8; Text[250])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Field 8', Comment = 'ESP=Campo 8';
        }
        field(10; User; Code[50])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'User', Comment = 'ESP=Usuario';
        }
        field(11; JXType; Option)
        {
            DataClassification = OrganizationIdentifiableInformation;
            OptionMembers = ,Header,Line,Dispatch,HeadDispatch;
            Caption = 'Type', Comment = 'ESP=tipo';
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