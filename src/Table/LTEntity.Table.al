table 84111 JXVZEntity
{
    Caption = 'Entities', Comment = 'ESP=Entidades';
    DrillDownPageID = JXVZEntities;
    LookupPageID = JXVZEntities;

    fields
    {
        field(1; JXVZEntity; Code[100])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Entity', Comment = 'ESP=Entidad';
        }

        field(2; JXVZDescription; Text[100])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Description', Comment = 'ESP=Descripcion';
        }
    }

    keys
    {
        key(Key1; JXVZEntity)
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; JXVZEntity, JXVZDescription)
        { }
    }
}