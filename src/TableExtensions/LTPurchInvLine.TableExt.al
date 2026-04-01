tableextension 84119 JXVZPurchInvLine extends "Purch. Inv. Line"
{
    fields
    {
        field(84107; JXVZWithholdingCode; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Withholding Code', Comment = 'ESP=Codigo retencion';
            TableRelation = JXVZWithholdArea.JXVZWithholdingCode;
        }
    }
}