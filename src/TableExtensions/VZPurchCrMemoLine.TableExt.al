tableextension 84121 JXVZPurchCrMemoLine extends "Purch. Cr. Memo Line"
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