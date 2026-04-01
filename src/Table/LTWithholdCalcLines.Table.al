table 84122 JXVZWithholdCalcLines
{
    fields
    {
        field(1; JXVZTaxCode; Code[10])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Tax code', Comment = 'ESP=Codigo impuesto';
            TableRelation = JXVZWithholdingTax.JXVZTaxCode;
        }
        field(3; JXVZRegime; Code[10])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Regime', Comment = 'ESP=Regimen';
        }
        field(4; JXVZDescription; Text[100])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Description', Comment = 'ESP=Descripcion';
        }
        field(6; JXVZBaseWitholdingType; Option)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Base witholding type', Comment = 'ESP=Tipo retencion base';
            OptionMembers = "Sin Impuestos","Importe Impuestos","Importe Total","Total menos IVA-IVA Perc-IIBB","Total menos IVA","Total menos IVA menos IVA Percep","Solo IVA";
        }
        field(7; JXVZAccumulativeCalculation; Boolean)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Accumulative calculation', Comment = 'ESP=Calculo acumulado';
        }
        field(8; JXVZMinimumWitholding; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Minimum witholding', Comment = 'ESP=Retencion minima';
        }
        field(9; JXVZScaleCode; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Scale code', Comment = 'ESP=Codigo escala';
            TableRelation = JXVZWithholdScale.JXVZScaleCode;
        }
        field(10; JXVZWitholdingNo; Integer)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Witholding no.', Comment = 'ESP=No. retencion';
        }
        field(11; JXVZAccumulative; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Accumulative', Comment = 'ESP=Acumulativo';
        }
        field(12; JXVZCalculatedWitholding; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Calculated witholding', Comment = 'ESP=Calculo retenciones';
        }
        field(13; JXVZWitholdingCondition; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Witholding condition', Comment = 'ESP=Condicion retenciones';
        }
        field(14; JXVZPaymentOrderNo; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Payment order no.', Comment = 'ESP=Orden de pago';
        }
        field(15; "JXVZExemption%"; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Exemption %', Comment = 'ESP=% exencion';
        }
        field(16; JXVZCertificateDate; Date)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Certificate date', Comment = 'ESP=Fecha certificado';
        }
        /*field(17; "Monthly Accum. Payment"; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Monthly Accum. Payment';
            InitValue = 0;
        }*/
        field(18; JXVZMothlyWitholding; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Mothly witholding', Comment = 'ESP=Retencion mensual';
        }
        field(19; JXVZCash; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Cash', Comment = 'ESP=Efectivo';
        }
        field(20; JXVZGeneralWitholdingDescription; Text[100])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'General witholding description', Comment = 'ESP=Descripcion general de retenciones';
        }
        field(21; JXVZDocumentDate; Date)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Document date', Comment = 'ESP=Fecha documento';
        }
        field(22; JXVZBase; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Base', Comment = 'ESP=Base';
        }
        field(23; JXVZAccumulationPeriod; Option)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Accumulation period', Comment = 'ESP=Periodo acumulado';
            Description = 'Período en que se acumula los pagos';
            OptionMembers = " ","Mes Calendario","Año Calendario","Año Corrido";
        }
        field(24; JXVZDistinctPerDocument; Boolean)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Distinct per document', Comment = 'ESP=Distinto por documento';
            Description = 'Si debe discriminarse por documento';
        }
        field(25; JXVZDiscriminatedCalcWitholding; Decimal)
        {
            CalcFormula = Sum(JXVZWithholdCalcDocument.JXVZWitholdingAmount WHERE(JXVZPaymentOrderNo = FIELD(JXVZPaymentOrderNo)));
            Caption = 'Discriminated calc. witholding', Comment = 'ESP=Retención calculada discriminada';
            Description = 'RG-3164 -Sumatoria de la Retencion segun discriminacion';
            FieldClass = FlowField;
        }
        field(26; JXVZDeterminationPerMonthlyInv; Boolean)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Determination per monthly inv.', Comment = 'ESP=Determinación por factura mensual';
            Description = 'RG-3164 -La aplicación de la retención es dado por un minimo de facturación mensual';
        }
        field(27; JXVZMinimumAmountInvPerMonth; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Minimum amount inv. per month', Comment = 'ESP=Importe mínimo de factura por mes';
            Description = 'RG-3164 -Monto mínimo de Facturac.mensual para aplicar retención';
        }
        field(28; JXVZWitholdingMode; Option)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Witholding mode', Comment = 'ESP=Modo retencion';
            Description = 'RG-3164 -Si la retención se debe calcular en forma proporcional al pago o en forma total al incio de los pago';
            OptionMembers = "Proporcional al pago","Total al Inicio";
        }
        field(29; JXVZDiscriminationCalcBase; Decimal)
        {
            CalcFormula = Sum(JXVZWithholdCalcDocument.JXVZWitholdingAmount WHERE(JXVZPaymentOrderNo = FIELD(JXVZPaymentOrderNo),
                                                                                         JXVZWitholdingNo = FIELD(JXVZWitholdingNo)));
            Caption = 'Discrimination calc. base', Comment = 'ESP=Calculo base discriminado';
            FieldClass = FlowField;
        }
        field(30; JXVZAccumulativePayments; Boolean)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Accumulative payments', Comment = 'ESP=Pagos acumulados';
            Description = 'A00429';
        }
        field(31; JXVZRetainAllInFirstPayment; Boolean)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Retain all in first payment', Comment = 'ESP=Retiene todo en el primer pago';
            Description = 'A00429';
        }
        field(32; JXVZPreviousPayments; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Previous payments', Comment = 'ESP=Pago previos';
            Description = 'A00429';
        }
        field(33; JXVZPreviousWitholdings; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Previous witholdings', Comment = 'ESP=Retenciones previas';
            Description = 'A00429';
        }
        field(34; JXVZMonotributo; Boolean)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Monotributo', Comment = 'ESP=Monotributo';
        }
        field(35; JXVZApplyCreditMemo; Boolean)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Apply credit memo', Comment = 'ESP=Nota de creito aplicada';
        }
        field(36; JXVZAccountNo; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Account no.', Comment = 'ESP=No. Cuenta';
        }
        field(37; JXVZPaymentMethodCode; Code[10])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Payment method code', Comment = 'ESP=Codigo metodo de pago';
        }
        field(38; JXVZWithholdingNumber; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Withholding number', Comment = 'ESP=Numero retencion';
        }
        field(40; "JXVZWitholding%"; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Witholding %', Comment = 'ESP=% Retencion';
            Description = 'A00429';
        }
    }

    keys
    {
        key(Key1; JXVZPaymentOrderNo, JXVZWitholdingNo)
        {
            SumIndexFields = JXVZCalculatedWitholding;
        }
        key(Key2; JXVZTaxCode, JXVZRegime, JXVZPaymentOrderNo, JXVZWitholdingNo)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        JXVZWithholdCalcDocument.Reset();
        JXVZWithholdCalcDocument.SetRange(JXVZPaymentOrderNo, JXVZPaymentOrderNo);
        JXVZWithholdCalcDocument.SetRange(JXVZWitholdingNo, JXVZWitholdingNo);
        if JXVZWithholdCalcDocument.Find('-') then
            JXVZWithholdCalcDocument.DeleteAll(true);

        JXVZWithholdAccumCalc.Reset();
        JXVZWithholdAccumCalc.SetRange(JXVZPaymentOrderNo, JXVZPaymentOrderNo);
        JXVZWithholdAccumCalc.SetRange(JXVZWitholdingNo, JXVZWitholdingNo);
        JXVZWithholdAccumCalc.SetRange(JXVZPosted, false);
        if JXVZWithholdAccumCalc.Find('-') then
            JXVZWithholdAccumCalc.DeleteAll(true);
    end;

    var
        JXVZWithholdCalcDocument: Record JXVZWithholdCalcDocument;
        JXVZWithholdAccumCalc: Record JXVZWithholdAccumCalc;
}