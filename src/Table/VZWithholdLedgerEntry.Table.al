table 84126 JXVZWithholdLedgerEntry
{
    fields
    {
        field(1; JXVZNo; Integer)
        {
            DataClassification = OrganizationIdentifiableInformation;
            AutoIncrement = false;
            Caption = 'No.', Comment = 'ESP=No.';
        }
        field(2; JXVZTaxCode; Code[10])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Tax code', Comment = 'ESP=Codigo impuesto';
            TableRelation = JXVZWithholdingTax.JXVZTaxCode;
        }
        field(3; JXVZVendorCode; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Vendor code', Comment = 'ESP=Codigo proveedor';
        }
        field(5; JXVZWitholdingBaseType; Option)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Witholding base type', Comment = 'ESP=Tipo retencion base';
            OptionMembers = "Sin Impuestos","Importe IVA","Importe Total","Total menos IVA-IVA Perc-IIBB","Total menos IVA","Total menos IVA menos IVA Percep","Solo IVA";
        }
        field(6; JXVZMinimumWitholding; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Minimum witholding', Comment = 'ESP=Minimo retencion';
        }
        field(7; JXVZScaleCode; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Scale code', Comment = 'ESP=Codigo escala';
            TableRelation = JXVZWithholdScale.JXVZScaleCode;
        }
        field(8; JXVZWitholdingNo; Integer)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Witholding no.', Comment = 'ESP=No. retnecion';
        }
        field(9; JXVZConditionCode; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Condition code', Comment = 'ESP=Codigo condicion';
        }
        field(10; JXVZVoucherCode; Code[2])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Voucher code', Comment = 'ESP=Codigo comprobante';
        }
        field(11; JXVZVoucherDate; Date)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Voucher date', Comment = 'ESP=Fecha comprobante';
        }
        field(12; JXVZVoucherNo; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Voucher no.', Comment = 'ESP=No. Comprobante';
        }
        field(13; JXVZVoucherAmount; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Voucher amount', Comment = 'ESP=Importe comprobante';
        }
        field(14; JXVZSicoreCode; Code[3])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'SICORE code', Comment = 'ESP=Codigo SICORE';
        }
        field(15; JXVZRegime; Code[10])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Regime', Comment = 'ESP=Regimen';
        }
        field(16; JXVZOperationCode; Integer)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Operation code', Comment = 'ESP=Codigo operacion';
        }
        field(17; JXVZCalculationBase; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Calculation base', Comment = 'ESP=Calculo base';
        }
        field(18; JXVZWitholdingDate; Date)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Witholding date', Comment = 'ESP=Fecha retencion';
        }
        field(19; JXVZSicoreConditionCode; Code[2])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'SICORE Condition code', Comment = 'ESP=Codigo condicion SICORE';
        }
        field(20; JXVZWitholdingAmount; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Witholding amount', Comment = 'ESP=Importe retencion';
        }
        field(21; "JXVZExemption%"; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'exemption %', Comment = 'ESP=% exención';
        }
        field(22; JXVZBoletinDate; Date)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Bulletin date', Comment = 'ESP=Fecha boletin';
            Description = 'SICORE';
        }
        /*field(23; "Affected Document Type"; Code[2])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Affected document type';
            Description = 'SICORE - 01 - RIF, 02 - CUIL, 03 - CDI';
        }
        field(24; "Affected Document No."; Text[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Affected document no.';
            Description = 'SICORE';
        }*/
        field(25; JXVZWitholdingCertificateNo; Code[30])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Witholding certificate no.', Comment = 'ESP=No. certificado retencion';
        }
        field(26; JXVZProvinceCode; Code[10])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Province code', Comment = 'ESP=Codigo provincia';
        }
        field(27; JXVZWitholdingSeriesNo; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Witholding series no.', Comment = 'ESP=No. Serie retencion';
        }
        field(28; JXVZBase; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Base', Comment = 'ESP=Base';
        }
        field(29; JXVZWitholdingType; Option)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Witholding type', Comment = 'ESP=Tipo retencion';
            OptionMembers = Realizada,Sufrida;
        }
        field(30; JXVZDiscriminatePerDocument; Boolean)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Discriminate per document', Comment = 'ESP=Discriminado por documento';
            Description = 'Si debe discriminarse por documento';
        }

        field(32; JXVZWitholdingMode; Option)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Witholding mode', Comment = 'ESP=Modo retencion';
            Description = 'Si la retención se debe calcular en forma proporcional al pago o en forma total al incio de los pago';
            OptionMembers = "Proporcional al pago","Total al Inicio";
        }
        field(40; "JXVZWitholding%"; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Witholding %', Comment = 'ESP=% Retencion';
        }
        field(41; JXVZWitholdingCertDate; Date)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Witholding Cert. date', Comment = 'ESP=Fecha cert. retencion';
        }
        field(42; JXVZWithholdStatus; Enum JXVZWithholdStatus)
        {
            DataClassification = CustomerContent;
            Caption = 'Withholding Status';
        }
    }

    keys
    {
        key(Key1; JXVZNo)
        {
        }
        key(Key2; JXVZTaxCode, JXVZVendorCode, JXVZRegime, JXVZWitholdingDate)
        {
            SumIndexFields = JXVZVoucherAmount, JXVZWitholdingAmount, JXVZBase;
        }
        key(Key3; JXVZVoucherNo, JXVZWitholdingNo)
        {
        }
        key(Key4; JXVZVoucherDate, JXVZVoucherNo)
        {
        }
    }

    fieldgroups
    {
    }
}