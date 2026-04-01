tableextension 84112 JXVZGenJournalLine extends "Gen. Journal Line"
{
    fields
    {
        field(84104; JXVZProvince; Code[10])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Provincia', Comment = 'ESP=Provincia';
            Description = 'JXVZ (01) - Used for tax calculation';
            TableRelation = JXVZProvince;
        }
        field(84105; JXVZFiscalType; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Fiscal type', Comment = 'ESP = "Tipo fiscal"';
            TableRelation = JXVZFiscalType."No.";

        }
        field(84106; JXVZPointOfSale; Code[10])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Point of sale', Comment = 'ESP=Punto de venta';
            Description = 'JXVZ (01) - FE4.0 - JXFE';
            TableRelation = JXVZPointOfSale;
        }
        field(84107; JXVZLetter; Text[30])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Letter', Comment = 'ESP=Letra';
            Description = 'JXVZ (01) - FE4.0 - JXFE';
        }
        field(84108; JXVZBase; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Base', Comment = 'ESP=Base';
        }
        field(84109; JXVZIsWitholding; Boolean)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'is withholding', Comment = 'ESP=Es retencion';
        }
        field(84110; JXVZWitholdingNo; Integer)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Withholding no.', Comment = 'ESP=No. Retencion';
        }

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
        //receipts END            
    }
}