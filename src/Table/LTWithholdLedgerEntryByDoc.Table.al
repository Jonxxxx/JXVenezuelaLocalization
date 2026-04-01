table 84143 JXVZWithholdLedgerEntryByDoc
{
    DataClassification = OrganizationIdentifiableInformation;

    fields
    {
        field(1; "No."; Integer)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'No.';
        }

        field(2; "Invoice No."; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Document No.';
        }

        field(3; JXVZTaxCode; Code[10])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Tax code', Comment = 'ESP=Codigo impuesto';
            TableRelation = JXVZWithholdingTax.JXVZTaxCode;
        }
        field(4; JXVZVendorCode; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Vendor code', Comment = 'ESP=Codigo proveedor';
        }

        field(5; JXVZWitholdingNo; Integer)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Witholding no.', Comment = 'ESP=No. retnecion';
        }
        field(6; JXVZConditionCode; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Condition code', Comment = 'ESP=Codigo condicion';
        }
        field(7; JXVZVoucherCode; Code[2])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Voucher code', Comment = 'ESP=Codigo comprobante';
        }
        field(8; JXVZVoucherDate; Date)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Voucher date', Comment = 'ESP=Fecha comprobante';
        }
        field(9; JXVZVoucherNo; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Voucher no.', Comment = 'ESP=No. Comprobante';
        }
        field(10; JXVZVoucherAmount; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Voucher amount', Comment = 'ESP=Importe comprobante';
        }

        field(11; JXVZCalculationBase; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Calculation base', Comment = 'ESP=Calculo base';
        }
        field(12; JXVZWitholdingDate; Date)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Witholding date', Comment = 'ESP=Fecha retencion';
        }

        field(13; JXVZWitholdingAmount; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Witholding amount', Comment = 'ESP=Importe retencion';
        }

        field(14; JXVZWitholdingAmountLCY; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Witholding amount', Comment = 'ESP=Importe retencion';
        }

        field(15; JXVZInvoiceCurrency; Code[10])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Invoice currency';
            TableRelation = Currency.Code;

        }

        field(16; JXVZExchRate; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Exchange rate';
        }
        field(17; JXVZBase; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Base', Comment = 'ESP=Base';
        }
        field(18; "JXVZWitholding%"; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Witholding %', Comment = 'ESP=% Retencion';
        }

        field(19; JXVZPaymentJournal; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Payment Journal';
        }

        field(20; JXVZPostedPaymentJournal; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Posted Payment Journal';
        }

        field(21; JXVZPosted; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Posted';
        }

        field(22; InvoiceLineNo; Integer)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Invoice Line No';
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    procedure GetLastNo(): Integer
    var
        AuxRec: Record JXVZWithholdLedgerEntryByDoc;
    begin
        AuxRec.Reset();
        if AuxRec.FindLast() then
            exit(AuxRec."No.");

        exit(0);
    end;
}