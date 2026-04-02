tableextension 84122 JXVZGLAccount extends "G/L Account"
{
    fields
    {
        field(84108; JXVZProvinceCode; Code[10])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Province', Comment = 'ESP=Provincia';
            TableRelation = JXVZProvince;
        }
    }
}