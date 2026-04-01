table 84125 JXVZWithholdAccumCalc
{
    fields
    {
        field(1; JXVZPaymentOrderNo; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Payment order no.', Comment = 'ESP=No. Orden de pago';
            TableRelation = "JXVZWithholdCalcLines".JXVZPaymentOrderNo;
        }
        field(2; JXVZWitholdingNo; Integer)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Witholding no.', Comment = 'ESP=No. retencion';
            TableRelation = JXVZWithholdCalcLines.JXVZWitholdingNo WHERE(JXVZPaymentOrderNo = FIELD(JXVZPaymentOrderNo));
        }
        field(3; JXVZDocumentType; Option)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Document type', Comment = 'ESP=Tipo documento';
            OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund,,,,,,,,,,Debit Memo,Orden Pago,Recibo,Transferencia,Ingreso/Egreso,Bill';
            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund,,,,,,,,,,"Debit Memo","Orden Pago",Recibo,Transferencia,"Ingreso/Egreso",Bill;
        }
        field(4; JXVZDocumentNo; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Document no.', Comment = 'ESP=No. Documento';
        }
        field(5; JXVZCalculationBase; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Calculation base', Comment = 'ESP=Calculo base';
        }
        field(6; JXVZAccumulatedWitholdings; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Accumulated witholdings', Comment = 'ESP=Retenciones acumuladas';
        }
        field(7; JXVZWitholdingTotalAmount; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Witholding total amount', Comment = 'ESP=Importe total retenciones';
        }
        field(8; JXVZWitholdingAmount; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Witholding amount', Comment = 'ESP=Importe retenciones';
        }
        field(9; JXVZDocumentDate; Date)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Document date', Comment = 'ESP=Fecha documento';
        }
        field(10; JXVZMonthlyInvoicing; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Monthly invoicing', Comment = 'ESP=Facturacion mesual';
        }
        field(11; JXVZVendorDocumentNo; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Vendor document no.', Comment = 'ESP=No. Documento proveedor';
        }
        field(12; JXVZAccumulativePayments; Boolean)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Accumulative payments', Comment = 'ESP=Pagos acumulados';
        }
        field(13; JXVZPosted; Boolean)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Posted', Comment = 'ESP=Registrado';
        }
        field(14; JXVZLineNo; Integer)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Line no.', Comment = 'ESP=No. linea';
        }
    }

    keys
    {
        key(Key1; JXVZPaymentOrderNo, JXVZWitholdingNo, JXVZDocumentType, JXVZDocumentNo, JXVZAccumulativePayments, JXVZLineNo)
        {
            SumIndexFields = JXVZWitholdingAmount, JXVZCalculationBase;
        }
    }

    fieldgroups
    {
    }
}