table 84132 JXVZVatBookTmp
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; JXVZPostingdate; Date)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Posting date', Comment = 'ESP=Fecha registro';
        }
        field(2; JXVZInvoiceNumber; Code[35])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Invoice no.', Comment = 'ESP=No. factura';
        }
        field(3; JXVZCompanyName; Text[100])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Company name', Comment = 'ESP=Nombre empresa';
        }
        field(4; JXVZVATRegistrationNo; Text[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'NIF', Comment = 'ESP=CUIT';
        }
        field(5; JXVZTaxAreaCode; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Tax area', Comment = 'ESP=Codigo area';
        }
        field(6; JXVZProvince; code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Province', Comment = 'ESP=Provincia';
            TableRelation = JXVZProvince;
        }
        field(7; JXVZInvoiceType; text[30])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Invoice type', Comment = 'ESP=Tipo factura';
        }
        field(8; JXVZInvoiceAmount; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Invoice amount', Comment = 'ESP=Importe factura';
        }
        field(9; JXVZBaseAmount; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Base amount', Comment = 'ESP=Base gravado';
        }
        field(10; JXVZNoBaseAmount; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'No base amount', Comment = 'ESP=Base no gravado';
        }
        field(11; JXVZExemptBaseAmount; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Exempt base', Comment = 'ESP=Base exento';
        }
        field(12; JXVZVAT8; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'VAT 10,5', Comment = 'ESP=IVA 10,5';
        }
        field(13; JXVZVAT16; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'VAT 21', Comment = 'ESP=IVA 21';
        }
        field(14; JXVZVAT27; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'VAT 27', Comment = 'ESP=IVA 27';
        }
        field(15; JXVZVATPercep; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'VAT perception', Comment = 'ESP=IVA percepcion';
        }
        field(16; JXVZWithold; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Withholding', Comment = 'ESP=Retenciones';
        }
        field(17; JXVZSpecial; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Special', Comment = 'ESP=especial';
        }
        field(18; JXVZKey; Integer)
        {
            DataClassification = OrganizationIdentifiableInformation;

        }
        field(19; JXVZFiscalType; Text[100])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Fiscal type', Comment = 'ESP=Tipo fiscal';
        }
        field(20; JXVZVAT10; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'VAT 10', Comment = 'ESP=IVA 10';
        }

        field(21; JXVZVAT22; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'VAT 22', Comment = 'ESP=IVA 22';
        }

        field(22; JXVZIRNR; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'IRNR', Comment = 'ESP=IRNR';
        }

        field(23; JXVZIRPF; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'IRPF', Comment = 'ESP=IRPF';
        }

        field(24; JXVZCurrency; Code[10])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Currency', Comment = 'ESP=Divisa';
        }

        field(25; JXVZInvoiceAmountLCY; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Invoice amount LCY', Comment = 'ESP=Importe factura DL';
        }

        field(26; JXVZWitholdMunicipal; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Withholding Municipal', Comment = 'ESP=Retenciones Municipal';
        }

        field(27; JXVZWitholdISLR; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Withholding ISLR', Comment = 'ESP=Retenciones ISLR';
        }

        field(28; JXVZDocumentDate; Date)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Document date', Comment = 'ESP=Fecha documento';
        }
        field(29; JXVZDocNoBC; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Document No. BC';
        }
    }

    keys
    {
        key(PK; JXVZKey)
        {
            Clustered = true;
        }
    }
}