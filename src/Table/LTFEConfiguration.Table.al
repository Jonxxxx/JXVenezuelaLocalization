table 84102 JXVZFEConfiguration
{
    DataClassification = CustomerContent;
    Caption = 'FE configuration', Comment = 'ESP=Configuracion FE';

    fields
    {
        field(1; JXkey; Integer)
        {
            DataClassification = OrganizationIdentifiableInformation;
        }

        field(2; JXWSFEUrl; Text[100])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'WSFE url',
                        Comment = 'ESP = Url WSFE';
        }

        field(3; JXWSTAUrl; Text[100])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'WSTA url',
                        Comment = 'ESP = Url WSTA';
        }

        field(4; JXFEXUrl; Text[100])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'WSFEX url',
                        Comment = 'ESP = Url WSFEX';
        }

        field(5; JXFECREDUrl; Text[100])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'WSFECRED url',
                        Comment = 'ESP = Url WSFECRED';
        }

        field(6; JXFEId; Text[10])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'FE id',
                        Comment = 'ESP =Id FE';
        }

        field(7; JXCertificatePath; Text[150])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Certificate path',
                        Comment = 'ESP = Ruta certificado';
        }

        field(8; JXCertificatePassword; Text[30])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Certificate password',
                        Comment = 'ESP = Contraseña certificado';
            ExtendedDatatype = Masked;
        }

        field(9; JXLogBasePath; Text[100])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Log base patch',
                        Comment = 'ESP = Ruta base log';
        }

        field(10; JXCUIT; Text[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'CUIT',
                        Comment = 'ESP = CUIT';
        }

        field(11; JXFEEnabled; Boolean)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Sales invoice enabled',
                        Comment = 'ESP = Factura electronica habilitada';
        }

        field(12; JXFELocalCurrencyCode; Text[5])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'FE local currency code',
                        Comment = 'ESP = Codigo moneda local FE';
        }

        field(13; JXFEXId; Text[10])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'FEX id',
                        Comment = 'ESP = Id FEX';
        }

        field(14; JXFECREDId; Text[10])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'FECRED id',
                        Comment = 'ESP = Id FECRED';
        }

        field(15; JXwebservice; Text[100])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'JX webservice',
                        Comment = 'ESP = Webservice JX';
        }

        //QR
        field(16; JXUrlQRCode; Text[200])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Url QR Code', Comment = 'ESP = Url codigo QR';
        }

        field(18; JXVZPrintQRCode; Boolean)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Print QR Code', Comment = 'ESP = Imprimir codigo QR';
        }
        //QR END
        field(19; JXVZShowRequest; Boolean)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Show request', Comment = 'ESP=Muestra request';
        }

        field(20; JXVZEncryptRequest; Boolean)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Encrypt request';
        }

        field(22; JXVZFERoundFE; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Round FE numbers';
            DecimalPlaces = 2 : 8;
        }

        field(23; JXVZFEErrorPostNoFE; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Error invoices NO FE';
        }

        field(24; JXVZupdateSeriesCode; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Update series Code';
        }

        field(25; JXLCheckAFIPNumber; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Check AFIP number when post';
        }

        field(26; JXVZLimitAmountNoCheckB; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Limit Amount to check amount FB';
        }

        field(27; JXVZDefValueInvoiceType; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Def. Invoice type',
                        Comment = 'ESP = Tipo factura defecto';
            OptionMembers = ,Invoice,DebitMemo;
            OptionCaption = ' ,Invoice,DebitMemo', Comment = 'ESP= ,Factura,Nota de debito';
        }

        field(28; JXVZDefExportType; Option)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Def. FE export type',
                        Comment = 'ESP = Tipo exportacion FE Defecto';
            OptionMembers = ,Products,Services,Others;
            OptionCaption = ',Products,Services,Others',
                              Comment = 'ESP = ,Productos,Servicios,Otros';
        }

        field(29; JXVZEnabledCUITValidation; Boolean)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Enabled CUIT validation';
        }

        field(30; JXFEVersion; Enum JXVZFEVersion)
        {
            DataClassification = OrganizationIdentifiableInformation;
        }

        field(31; JXFEContentCertificate; Text[2048])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Content certificate PFX';
        }

        field(32; JXFEManualVoucherType; Boolean)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Allow edit voucher type', Comment = 'ESP="Tipo de comprobante editable"';
        }

        field(33; JXFEShowAllError; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Show all error';
        }

        field(34; JXFETransFiscalLeyend; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Show text transparencia fiscal B';
        }

        field(35; JXFEVisibleSavePdfReport; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Show save pdf report';
        }
        //Save URL qr Code
        field(36; JXFESaveUrlQr; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Save Url qr';
        }
        //Save URL qr Code END
    }

    keys
    {
        key(PK; JXkey)
        {
            Clustered = true;
        }
    }
}