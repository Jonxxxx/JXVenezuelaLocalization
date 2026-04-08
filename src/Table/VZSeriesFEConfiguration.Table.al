table 84101 JXVZSeriesFEConfiguration
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; JXVZType; Option)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Type', comment = 'ESP = Tipo';
            OptionMembers = Invoice,CreditMemo,DebitMemo,Shipment;
            OptionCaption = 'Invoice,Credit memo,Debit memo,Shipment',
                              Comment = 'ESP = Factura,Nota de credito,Nota de debito,Remito';
        }

        field(2; JXVZFiscalType; Code[20])
        {
            //RI = Responsable inscripto, CF = Consumidor final, MO = Monotributista
            //RX = Exento, EXT = Extranjero, NC = No categorizado
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Fiscal type', Comment = 'ESP = "Tipo fiscal"';
            TableRelation = JXVZFiscalType."No.";
        }

        field(3; JXVZPointOfSale; Code[5])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Point of sale',
                        Comment = 'ESP = Punto de venta';
            TableRelation = JXVZPointOfSale;
            ValidateTableRelation = true;
        }

        field(4; JXVZSeriesNumber; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Series number',
                        Comment = 'ESP = "Numero de serie"';
            TableRelation = "No. Series";
            ValidateTableRelation = true;
        }

        field(5; JXVZLetter; Code[1])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Letter',
                        Comment = 'ESP = Letra';
        }

        field(7; JXVZFEDocumentType; Code[5])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'document type',
                        Comment = 'ESP = "Tipo documento"';
            TableRelation = JXVZFEDocumentType;
            ValidateTableRelation = true;
        }

        field(8; JXVZSReportDescription; Text[150])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Report description',
                        Comment = 'ESP = "Descripcion en reporte"';
        }

    }

    keys
    {
        key(PK; JXVZType, JXVZFiscalType, JXVZPointOfSale, JXVZFEDocumentType)
        {
            Clustered = true;
        }
    }
}