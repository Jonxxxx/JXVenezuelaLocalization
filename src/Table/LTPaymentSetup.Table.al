table 84114 JXVZPaymentSetup
{
    Caption = 'Payment Venezuela setup', Comment = 'ESP=Config. pagos argentina';

    fields
    {
        field(1; JXVZIdCode; Integer)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'ID', Comment = 'ESP=Id';
        }

        field(19; JXVZHistReceiptReport; Integer)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Register receipt report', Comment = 'ESP=Reporte recibo registrado';
        }
        field(20; JXVZHisPaymentReport; Integer)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Register payment report', Comment = 'ESP=Reporte orden de pago registrado';
        }

        field(21; JXVZGrossIncomeReport; Integer)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Gross income report', Comment = 'ESP=Reporte ingresos brutos';
        }

        field(22; JXVZGainReport; Integer)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Gain report', Comment = 'ESP=Reporte ganancias';
        }

        field(23; JXVZSussReport; Integer)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Suss report', Comment = 'ESP=Reporte Suss';
        }

        field(24; JXVZBodyOPMail; Text[500])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Body payment order mail', Comment = 'ESP=Cuerpo mail orden de pago';
        }

        field(25; JXVZBasepathPadron; Text[120])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Base Path Padron';
        }

        field(26; JXVZPadronArbaName; Text[30])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Padron ARBA Name';
        }

        field(27; JXVZPadronCabaName; Text[30])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Padron CABA Name';
        }

        field(28; JXVZCompleteWithSpace; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Complete with space export files';
        }

        field(29; JXVZShowTCPaymentReport; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Show TC in payment report';
        }

        field(30; JXVZDefaultAccountTPCheck; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Default account Third Party Check';
            TableRelation = "G/L Account"."No.";
        }
        //SicoreRET
        field(31; JXVZField1DefaultSRET; Text[2])
        {
            DataClassification = CustomerContent;
            Caption = 'Field 1 default value';
        }

        field(32; JXVZCompleteWithSRETF3; Code[1])
        {
            DataClassification = CustomerContent;
            Caption = 'Complete with Field 3';
        }

        field(33; JXVZField10BisDefValueSRET; Code[1])
        {
            DataClassification = CustomerContent;
            Caption = 'Field 10 bis default value';
        }

        field(34; JXVZCompleteWithSRETF16; Code[1])
        {
            DataClassification = CustomerContent;
            Caption = 'Complete with Field 16';
        }

        field(35; JXVZSicoreRetFilter; Code[80])
        {
            DataClassification = CustomerContent;
            Caption = 'Sicore Withhold. filter';
        }
        //CABA
        field(36; JXVZCABAInvoiceFilter; Code[80])
        {
            DataClassification = CustomerContent;
            Caption = 'Caba invoice filter';
        }

        field(37; JXVZDefValueF4CABAEI; Code[2])
        {
            DataClassification = CustomerContent;
            Caption = 'Field 4 default value';
        }

        field(38; JXVZDefValueF10CABAEI; Code[1])
        {
            DataClassification = CustomerContent;
            Caption = 'Field 10 default value';
        }

        field(39; JXVZIIBBCodeCABAEI; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'IIBB CABA Tax Code';
        }

        field(40; JXVZCABAInvoiceVTFilter; Code[80])
        {
            DataClassification = CustomerContent;
            Caption = 'Caba invoice VAT filter';
        }

        field(41; JXVZARBAPercepFilter; Code[80])
        {
            DataClassification = CustomerContent;
            Caption = 'ARBA percep vat filter';
        }

        field(42; JXVZCABAWitholDot; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'CABA Withhold. dot separator';
        }

        field(43; JXVZurlServiceAutExchRate; text[120])
        {
            DataClassification = CustomerContent;
            Caption = 'URL service automatic exch. rate';

            trigger OnValidate()
            var
                Msglbl: Label 'La funcionalidad de actualizacion de tipo de cambio utiliza un servicio de terceros.\Jonxsoft no se responsabiliza de los datos y del correcto funcionamiento del proceso.';
            begin
                Message(Msglbl);
            end;
        }

        field(44; JXVZCurrencyCodeUSDSales; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'USD currency code Sales';
            TableRelation = Currency.Code;
        }

        field(45; JXVZCurrencyCodeUSDPurch; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'USD currency code Purchase';
            TableRelation = Currency.Code;
        }

        field(46; JXVZAccountDescripOP; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Account description in line OP report';
        }

        field(47; JXVZControlTPCheckPost; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Control third party check to post';
        }

        field(48; JXVZCheckAmountVAT; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Check Amount VAT Reports', Comment = 'ESP=Chequear importes libros IVA';
        }

        field(49; JXVZBodyRCMail; Text[500])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Body receipt mail', Comment = 'ESP=Cuerpo mail recibo';
        }

        field(50; JXVZPointSaleNumbers; Integer)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Point of sale positions', Comment = 'ESP="Caracteres punto de venta';
            InitValue = 4;
            MinValue = 2;
            MaxValue = 6;
        }

        field(51; JXVZDocumentNoNumbers; Integer)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Document No. positions', Comment = 'ESP="Caracteres numero de documento';
            InitValue = 8;
            MinValue = 4;
            MaxValue = 12;
        }

        field(52; JXVZAllowDiffTaxAreaCode; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Allow differents tax area in invoice', Comment = 'ESP="Permitir distintos codigos de areas en facturas"';
        }

        field(53; JXVZDeleteWithholdToRevert; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Delete withholding when revert OP', Comment = 'ESP="Eliminar retenciones al revertir OP';
        }

        field(54; JXVZSicoreCertLen; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Sicore Certificate length', Comment = 'ESP="Longitud Certificado Sicore';
        }
        field(55; JXVZSifereAmountLen; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Sifere amount length', Comment = 'ESP="Longitud importe Sifere';
        }
        field(56; JXVZNoNegativeSignLEDC; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'No Negative Sign LVE Purchase', Comment = 'ESP="Sin signo negativo LVE Compras';
        }
        field(57; JXVZVersion2ARBAReport; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Version 2 ARBA Export Reports';
        }
        field(58; JXVZControlSecuencePaymorderNo; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Control Payment Order Sequence';
        }
    }

    keys
    {
        key(Key1; JXVZIdCode)
        {
        }
    }
}