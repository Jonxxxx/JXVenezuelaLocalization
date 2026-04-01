table 84116 JXVZWithholdingTax
{
    Caption = 'Withholding taxes', Comment = 'ESP=Impuesto retenciones';
    DrillDownPageID = JXVZWithholdingTax;
    LookupPageID = JXVZWithholdingTax;

    fields
    {
        field(1; JXVZTaxCode; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Tax code', Comment = 'ESP=Codigo impuesto';
            NotBlank = true;
        }
        field(2; JXVZTax; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Tax', Comment = 'ESP=Impuesto';
            NotBlank = true;
        }
        field(3; JXVZProvince; Code[10])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Province', Comment = 'ESP=Provincia';
            TableRelation = JXVZProvince;
        }
        field(4; JXVZRetains; Boolean)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Retains', Comment = 'ESP=Retiene';
        }
        field(5; JXVZSicoreCode; Code[3])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'SICORE Code', Comment = 'ESP=Codigo SICORE';
        }
        field(6; JXVZDescription; Text[40])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Description', Comment = 'ESP=Descripcion';
        }
        field(7; JXVZTaxType; Option)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Tax type', Comment = 'ESP=Tipo de impuesto';
            OptionMembers = "","Ganancias","SUSS","IVA","IB-ARBA","IB-CABA","Otros","IB-MIS";
        }
    }

    keys
    {
        key(Key1; JXVZTaxCode)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if JXVZWithholdingTax.FindSet(false, false) then
            repeat
                if (JXVZWithholdingTax.JXVZTax = JXVZTax) and (JXVZWithholdingTax.JXVZProvince = JXVZProvince) then
                    Error(TextJXL0017Lbl, JXVZTax, JXVZProvince);
            until JXVZWithholdingTax.Next() = 0;
    end;

    var
        JXVZWithholdingTax: Record JXVZWithholdingTax;
        TextJXL0017Lbl: Label 'The Tax %1, Province %2 already exists.';
}