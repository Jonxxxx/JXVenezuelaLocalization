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
            ;
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
    }

    keys
    {
        key(Key1; JXVZScaleCode, JXVZWitholdingCondition, JXVZTaxCode, JXVZFrom)
        {
        }
    }

    fieldgroups
    {
    }
}