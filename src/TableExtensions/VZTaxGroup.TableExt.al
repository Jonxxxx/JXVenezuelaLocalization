tableextension 84114 JXVZTaxGroup extends "Tax Group"
{
    fields
    {
        field(84100; JXVZType; Option)
        {
            Caption = 'Type', Comment = 'ESP=Tipo';
            DataClassification = OrganizationIdentifiableInformation;
            OptionMembers = " ","No base","Exempt base","Base exonerado";
            OptionCaption = ' ,Base no gravada,Base exento,Base exonerado';
        }
    }
}