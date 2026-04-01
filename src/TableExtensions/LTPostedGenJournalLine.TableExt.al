tableextension 84150 JXVZPostedGenJournalLine extends "Posted Gen. Journal Line"
{
    fields
    {
        //receipts
        field(84120; JXVZEntityValue; Text[100])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Entity value', Comment = 'ESP=Entidad valor';
            TableRelation = JXVZEntity.JXVZEntity;
        }
        field(84121; JXVZToDateValue; Date)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'To date value', Comment = 'ESP=A fecha (valor)';

            trigger OnValidate()
            begin
                "JXVZAcreditationDateValue" := "JXVZToDateValue";
            end;
        }
        field(84122; JXVZDocumentDateValue; Date)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Document date value', Comment = 'ESP=Fecha documento (valor)';
        }
        field(84123; JXVZAcreditationDateValue; Date)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Acreditation date value', Comment = 'ESP=Fecha acreditacion (valor)';
        }
        field(84124; JXVZValueNoValue; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Value no.', Comment = 'ESP=No. Valor';
        }
        field(84126; JXVZAccountPayment; Boolean)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Pago a cuenta - Diff cambio', Comment = 'Pago a cuenta - Diff cambio';
        }
    }
}