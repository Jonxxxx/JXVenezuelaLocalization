tableextension 84120 JXVZPurchCrMemoHdr extends "Purch. Cr. Memo Hdr."
{
    fields
    {
        field(84100; JXVZFiscalType; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Fiscal type', Comment = 'ESP = "Tipo fiscal"';
            TableRelation = JXVZFiscalType."No.";
        }

        field(84101; JXVZWithholdingCode; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Withholding Code', Comment = 'ESP=Codigo retencion';
            TableRelation = JXVZWithholdArea.JXVZWithholdingCode;
        }

        field(84103; JXVZProvince; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Province', Comment = 'ESP=Provincia';
            TableRelation = JXVZProvince;
        }

        field(84104; JXVZInvoiceType; Option)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Invoice type',
                        Comment = 'ESP = Tipo factura';
            OptionMembers = ,Invoice,DebitMemo;
        }
        field(84105; JXVZCtrlDocumentNo; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Control Document No';
        }
    }
}