table 84119 JXVZWithholdScale
{
    Caption = 'Witholding scale', Comment = 'ESP=Escala retencion';
    LookupPageID = JXVZWithholdScale;

    fields
    {
        field(1; JXVZScaleCode; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Scale code', Comment = 'ESP=Codigo escala';
            NotBlank = true;
        }
        field(2; JXVZWitholdingCondition; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Witholding condition', Comment = 'ESP=Condicion de retencion';
            NotBlank = true;
            TableRelation = JXVZWithholdTaxCondition.JXVZConditionCode WHERE(JXVZTaxCode = FIELD(JXVZTaxCode));
        }
        field(3; JXVZTaxCode; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Tax code', Comment = 'ESP=Codigo impuesto';
            NotBlank = true;
            TableRelation = JXVZWithholdingTax;
        }
        field(4; JXVZFrom; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'From', Comment = 'ESP=Desde';
        }
        field(5; JXVZTo; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'To', Comment = 'ESP=Hasta';
        }
        field(6; JXVZFixedAmount; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Fixed amount', Comment = 'ESP=Importe fijo';
        }
        field(7; JXVZBaseAmount; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Base amount', Comment = 'ESP=Importe base';
        }
        field(8; JXVZSurplus; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = '% Surplus', Comment = 'ESP=% excendente';
            DecimalPlaces = 1 : 4;
        }
        field(9; JXVZMonotributoIVA; Boolean)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Monotributo IVA', Comment = 'ESP=Monotributo IVA';
        }
        field(10; JXVZRegime; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Regime', Comment = 'ESP=Regimen';
        }
        field(11; JXVZCalculationFormula; Enum JXVZWithholdScaleFormula)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Calculation formula', Comment = 'ESP=Formula de calculo';
        }
        field(12; JXVZTaxableBasePct; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = '% Taxable base', Comment = 'ESP=% base imponible';
            DecimalPlaces = 1 : 4;
            InitValue = 100;
        }
        field(13; JXVZDeductionAmount; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Deduction amount', Comment = 'ESP=Importe sustraendo';
        }
        field(14; JXVZMinimumPaymentAmount; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Minimum payment amount', Comment = 'ESP=Importe minimo de pago';
        }
        field(15; JXVZUseTaxUnit; Boolean)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Use Tax Unit', Comment = 'ESP=Usa Unidad Tributaria';
        }
        field(16; JXVZValidFrom; Date)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Valid from', Comment = 'ESP=Vigencia desde';

            trigger OnValidate()
            begin
                ValidateValidityDates();
            end;
        }
        field(17; JXVZValidTo; Date)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Valid to', Comment = 'ESP=Vigencia hasta';

            trigger OnValidate()
            begin
                ValidateValidityDates();
            end;
        }
        field(18; JXVZMunicipalityCode; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Municipality code', Comment = 'ESP=Codigo municipio';
        }
        field(19; JXVZEconomicActivityCode; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Economic activity code', Comment = 'ESP=Codigo actividad economica';
        }
        field(20; JXVZEconomicActivityDescription; Text[100])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Economic activity description', Comment = 'ESP=Descripcion actividad economica';
        }
    }

    keys
    {
        key(Key1; JXVZScaleCode, JXVZWitholdingCondition, JXVZTaxCode, JXVZRegime, JXVZMunicipalityCode, JXVZEconomicActivityCode, JXVZValidFrom, JXVZFrom)
        {
        }
        key(Key2; JXVZTaxCode, JXVZRegime, JXVZWitholdingCondition, JXVZMunicipalityCode, JXVZEconomicActivityCode, JXVZValidFrom, JXVZFrom)
        {
        }
    }

    fieldgroups
    {
    }

    local procedure ValidateValidityDates()
    begin
        if (JXVZValidFrom <> 0D) and (JXVZValidTo <> 0D) and (JXVZValidTo < JXVZValidFrom) then
            Error('The validity end date cannot be earlier than the validity start date.');
    end;
}