tableextension 84103 JXVZCustomer extends Customer
{
    fields
    {
        field(84100; JXVZFEDocumentType; Code[10])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Document type',
                        Comment = 'ESP = Tipo documento';
            TableRelation = JXVZFECustDocumentType;
            ValidateTableRelation = true;
        }

        field(84101; JXVZFiscalType; Code[20])
        {
            //RI = Responsable inscripto, CF = Consumidor final, MO = Monotributista
            //RX = Exento, EXT = Extranjero, NC = No categorizado
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Fiscal type', Comment = 'ESP = "Tipo fiscal"';
            TableRelation = JXVZFiscalType."No.";
        }

        field(84102; JXVZProvinceCode; Code[10])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Province', Comment = 'ESP=Provincia';
            TableRelation = JXVZProvince;
        }

        field(84104; JXVZPointofSale; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = JXVZPointOfSale.JXVZPointOfSale;
            Caption = 'Point of sale',
                        Comment = 'ESP = "Punto de venta"';
        }
    }
}