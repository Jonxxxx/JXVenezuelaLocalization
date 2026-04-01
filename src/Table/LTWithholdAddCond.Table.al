table 84127 JXVZWithholdAddCond
{
    Caption = 'Withholding additional condition', Comment = 'ESP=Condicion retencion adicional';
    LookupPageID = JXVZWithholdAddCond;

    fields
    {
        field(1; JXVZWithholdingNo; Integer)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Withholding No.', comment = 'ESP=No. Retencion';
            TableRelation = JXVZWithholdDetailEntry.JXVZWitholdingNo;
        }
        field(2; JXVZType; Option)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Type', Comment = 'ESP=Tipo';
            OptionMembers = "Outperform by service","Exceeds by Product","Unit Price";
        }
        field(3; JXVZWithholdingCode; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Withholding code', Comment = 'ESP=Codigo retencion';
            NotBlank = false;
            TableRelation = JXVZWithholdArea;
        }
    }

    keys
    {
        key(Key1; JXVZWithholdingNo, JXVZType, JXVZWithholdingCode)
        {
        }
    }
}