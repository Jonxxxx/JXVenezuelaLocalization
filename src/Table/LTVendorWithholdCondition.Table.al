table 84123 JXVZVendorWithholdCondition
{
    Caption = 'Vendor withhold condition', comment = 'ESP=Condicion retencion proveedor';
    LookupPageID = JXVZVendorWithholdCondition;

    fields
    {
        field(1; JXVZVendorCode; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Vendor Code', comment = 'ESP=Codigo proveedor';
            TableRelation = Vendor;
        }
        field(2; JXVZTaxCode; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Tax Code', comment = 'ESP=Codigo impuesto';
            TableRelation = JXVZWithholdingTax.JXVZTaxCode;
        }
        field(3; JXVZTaxConditionCode; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Tax Condition Code', comment = 'ESP=Codigo condicion fiscal';
            FieldClass = Normal;
            TableRelation = JXVZWithholdTaxCondition.JXVZConditionCode WHERE(JXVZTaxCode = FIELD(JXVZTaxCode));
        }
        field(4; JXVZFromDate; Date)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'From date', comment = 'ESP=Fecha desde';
        }
        field(5; JXVZToDate; Date)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'To date', comment = 'ESP=Fecha hasta';
        }
    }

    keys
    {
        key(Key1; JXVZVendorCode, JXVZTaxCode)
        {
        }
    }
}