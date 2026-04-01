table 84124 JXVZWithholdCalcDocument
{
    fields
    {
        field(1; JXVZPaymentOrderNo; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Payment order no.', Comment = 'ESP=Orden de pago';
            TableRelation = "JXVZWithholdCalcLines".JXVZPaymentOrderNo;
        }
        field(2; JXVZWitholdingNo; Integer)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Witholding no.', Comment = 'ESP=No. Retencion';
            TableRelation = "JXVZWithholdCalcLines".JXVZWitholdingNo WHERE(JXVZPaymentOrderNo = FIELD(JXVZPaymentOrderNo));
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
            Caption = 'Document no.', Comment = 'ESP=No. documento';
        }
        field(5; JXVZCalculationBase; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Calculation base', Comment = 'ESP=Caluculo base';
        }
        field(6; JXVZAccumulatedWitholdings; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Accumulated witholdings', Comment = 'ESP=Retenciones acumuladas';
            Description = 'Lo ya retenido con aterioridad para el Documento';
        }
        field(7; JXVZWitholdingTotalAmount; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Witholding total amount', Comment = 'ESP=Importe total retenciones';
            Description = 'Monto de Retencion Total del Documento';
        }
        field(8; JXVZWitholdingAmount; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Witholding amount', Comment = 'ESP=Importe retencion';
            Description = 'Monto a Retener (deducida las Ret anteriores)';
        }
        field(9; JXVZDocumentDate; Date)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Document date', Comment = 'ESP=Fecha documento';
        }
        field(10; JXVZMonthlyInvoicing; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Monthly invoicing', Comment = 'ESP=Facturacion mensual';
            Description = 'Total de lo facturado por el Proveedor en el mes calendario de Fecha Registro documento';
        }
        field(11; JXVZVendorDocumentNo; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Vendor document no.', Comment = 'ESP=No. documento proveedor';
        }
        field(12; JXVZPosted; Boolean)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Posted', Comment = 'ESP=Registrado';
        }
    }

    keys
    {
        key(Key1; JXVZPaymentOrderNo, JXVZWitholdingNo, JXVZDocumentType, JXVZDocumentNo)
        {
            SumIndexFields = JXVZWitholdingAmount, JXVZCalculationBase;
        }
    }

    fieldgroups
    {
    }
}