table 84130 JXVZHistPaymVoucherLine
{
    DataPerCompany = true;

    fields
    {
        field(1; JXVZPaymentOrderNo; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'No.', Comment = 'ESP=No.';
        }
        field(2; JXVZVoucherNo; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Voucher no.', Comment = 'ESP=No. Comprobante';
        }
        field(3; JXVZDate; Date)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Date', Comment = 'ESP=Fecha';
        }
        field(4; JXVZAmountLCY; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Amount (LCY)', Comment = 'ESP=Importe (DL)';
        }
        field(5; JXVZRemainingAmount; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Remaining amount', Comment = 'ESP=Importe pendiente';
        }
        field(6; JXVZVendor; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Vendor', Comment = 'ESP=Proveedor';
        }
        field(7; JXVZDocumentType; Option)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Document type', Comment = 'ESP=Tipo documento';
            OptionMembers = " ",Pago,Factura,"Nota d/c","Docs.interés",Recordatorio,Efecto,"Nota Débito",Recibo;
        }
        field(8; JXVZCancelledAmount; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Cancelled amount', Comment = 'ESP=Importe cancelado';
        }
        field(9; JXVZTotalRemainingAmount; Decimal)
        {
            CalcFormula = Sum(JXVZHistPaymVoucherLine.JXVZRemainingAmount WHERE(JXVZVoucherNo = FIELD(JXVZVoucherNo)));
            Caption = 'Pending amount', Comment = 'ESP=Importe pendiente';
            FieldClass = FlowField;
        }
        field(10; JXVZTotalCancelledAmount; Decimal)
        {
            CalcFormula = Sum(JXVZHistPaymVoucherLine.JXVZCancelledAmount WHERE(JXVZVoucherNo = FIELD(JXVZVoucherNo)));
            Caption = 'Total cancelled', Comment = 'ESP=Total cancelado';
            FieldClass = FlowField;
        }
        field(11; JXVZEntryNo; Integer)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Entry no.', Comment = 'ESP=No. Movimiento';
        }
        field(17; JXVZCurrencyCode; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Currency code', Comment = 'ESP=Codigo divisa';
        }
        field(18; JXVZCurrencyFactor; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Currency factor', Comment = 'ESP=Factor divisa';
        }
        field(19; JXVZAmount; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Amount', Comment = 'ESP=Importe';
        }
        field(20; JXVZApplyingCreditMemoExists; Boolean)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Applying credit memo existing', Comment = 'ESP=Aplicado a nota de credito existente';
        }
    }

    keys
    {
        key(Key1; JXVZPaymentOrderNo, JXVZVoucherNo, JXVZEntryNo)
        {
            SumIndexFields = JXVZRemainingAmount, JXVZCancelledAmount;
        }
    }
}