table 84128 JXVZVendorExemption
{
    Caption = 'Vendor withold exention', Comment = 'ESP=Exencion retenciones proveedores';
    LookupPageID = JXVZVendorExemption;

    fields
    {
        field(1; "JXVZVendorCode"; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Vendor code', Comment = 'ESP=Codigo proveedor';
            TableRelation = Vendor."No.";
        }
        field(2; "JXVZTaxCode"; Code[10])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Tax code', Comment = 'ESP=Codigo impuesto';
            TableRelation = JXVZWithholdingTax;
        }
        field(4; JXVZRegime; Code[10])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Regime', Comment = 'ESP=Regimen';
            TableRelation = JXVZWithholdDetailEntry.JXVZRegime WHERE(JXVZTaxCode = FIELD(JXVZTaxCode));
        }
        field(5; JXVZExemptionPercent; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = '% exemption', Comment = 'ESP=% exencion';
        }
        field(6; "JXVZFromDate"; Date)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'From date', Comment = 'ESP=Fecha desde';
        }
        field(7; "JXVZToDate"; Date)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'To date', Comment = 'ESP=Fecha hasta';
        }
        field(8; "JXVZCertificateDate"; Date)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Certificate date', Comment = 'ESP=Fecha certificado';
        }
        field(9; JXVZComment; Text[100])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Comment', Comment = 'ESP=Comentario';
        }
    }

    keys
    {
        key(Key1; "JXVZVendorCode", "JXVZTaxCode", JXVZRegime)
        {
        }
    }
}