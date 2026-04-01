tableextension 84122 JXVZGLAccount extends "G/L Account"
{
    fields
    {
        field(84100; JXVZPercepLineIIBB; Boolean)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'IIBB ARBA percep by line', Comment = 'ESP=Percepcion por linea IIBB ARBA';
        }

        field(84101; JXVZPercepLineGAN; Boolean)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Gain percep by line', Comment = 'ESP=Percepcion por linea Ganancias';
        }

        field(84102; JXVZPercepLineVAT; Boolean)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Vat percep by line', Comment = 'ESP=Percepcion por linea IVA';
        }

        field(84103; JXVZPercepLineVAT105; Boolean)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'VAT 10.5 percep by line', Comment = 'ESP=Percepcion por linea IVA 10,5';
        }

        field(84104; JXVZPercepLineVAT21; Boolean)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Vat 21 percep by line', Comment = 'ESP=Percepcion por linea IVA 21';
        }

        field(84105; JXVZPercepLineVAT27; Boolean)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Vat 27 percep by line', Comment = 'ESP=Percepcion por linea IVA 27';
        }

        field(84106; JXVZPercepLineIIBBCABA; Boolean)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'IIBB CABA percep by line', Comment = 'ESP=Percepcion por linea IIBB CABA';
        }

        field(84107; JXVZPercepLineIIBBOthers; Boolean)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'IIBB Others percep by line', Comment = 'ESP=Percepcion por linea IIBB Otros';
        }
        field(84108; JXVZProvinceCode; Code[10])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Province', Comment = 'ESP=Provincia';
            TableRelation = JXVZProvince;
        }
    }
}