table 84118 JXVZWithholdDetailEntry
{
    Caption = 'Witholding detail setup', Comment = 'ESP=Conf. detalle retencion';
    DrillDownPageID = JXVZWithholdDetailEntry;
    LookupPageID = JXVZWithholdDetailEntry;

    fields
    {
        field(1; JXVZWitholdingNo; Integer)
        {
            DataClassification = OrganizationIdentifiableInformation;
            AutoIncrement = true;
            Caption = 'Witholding no.', Comment = 'ESP=No. Retencion';
        }
        field(2; JXVZTaxCode; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Tax code', Comment = 'ESP=Codigo impuesto';
            ;
            TableRelation = JXVZWithholdingTax;
            ValidateTableRelation = true;
        }
        field(4; JXVZRegime; Code[10])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Regime', Comment = 'ESP=Regimen';
            NotBlank = true;
        }
        field(5; JXVZDescription; Text[100])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Description', Comment = 'ESP=Descripcion';
        }
        field(7; JXVZWitholdingBaseType; Option)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Witholding base type', Comment = 'ESP=Tipo retencion base';
            OptionMembers = "Sin Impuestos","Importe Impuestos","Importe Total","Total menos IVA-IVA Perc-IIBB","Total menos IVA","Total menos IVA menos IVA Percep","Solo IVA";
        }
        field(8; JXVZAccumulativeCalculation; Boolean)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Accumulative calculation', Comment = 'ESP=Calculo acumulativo';
            Description = 'Si toma en cuenta pagos anteriores del mes y recalcula';
        }
        field(9; JXVZMinimumWitholding; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Minimum witholding', Comment = 'ESP=Retencion minima';
            Description = 'Si el monto calculado a retener es menor a éste, no se retiene nada';
        }
        field(10; JXVZScaleCode; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Scale code', Comment = 'ESP=Codigo escala';
            Description = 'A los efectos de asociar con la escala';
            Editable = true;
            TableRelation = JXVZWithholdScale.JXVZScaleCode WHERE(JXVZTaxCode = FIELD(JXVZTaxCode));
        }
        field(11; JXVZDiscriminatesPerDocument; Boolean)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Discriminates per document', Comment = 'ESP=Discriminado por documento';
            Description = 'La retención debe discriminarse por documento';
        }
        field(12; JXVZMonthInvoiceDeter; Boolean)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Monthly invoice determination', Comment = 'ESP=Facturacion mensual determinada';
            Description = 'La aplicación de la retención es dado por un minimo de facturación mensual';

            trigger OnValidate()
            begin
                if JXVZMonthInvoiceDeter then
                    Validate(JXVZAccumulativeCalculation, false);
            end;
        }
        field(13; JXVZMonthInvoiceMinimunAmt; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Monthly invoice minimum amount', Comment = 'ESP=Facturacion mensual minima determinada';
            Description = 'Monto mínimo de Facturac.mensual para aplicar retención';
        }
        field(14; JXVZWitholdingMode; Option)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Witholding mode', Comment = 'ESP=Modo retencion';
            Description = 'Si la retención se debe calcular en forma proporcional al pago o en forma total al incio de los pago';
            OptionMembers = "Proporcional al pago","Total al Inicio";
        }
        field(15; JXVZExceedsByServices; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Exceeds by services', Comment = 'ESP=Excede por servicios';
        }
        field(16; JXVZExceedsByProductos; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Exceeds by products', Comment = 'ESP=Excede por productos';
        }
        field(17; JXVZUnitPrice; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Unit price', Comment = 'ESP=Precio unitario';
        }
        field(18; JXVZAccumulationPeriod; Option)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Accumulation period', Comment = 'ESP=Periodo acumulado';
            Description = 'Período en que se acumula los pagos';
            OptionMembers = " ","Mes Calendario","Año Calendario","Año Corrido";
        }
        field(19; JXVZAccumulativePayments; Boolean)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Accumulative payments', Comment = 'ESP=Pagos unitario';
        }
        field(20; JXVZRetainsAllInFirstPayment; Boolean)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Retains ALL in first payment', Comment = 'ESP=Retiene todo en el primer pago';
        }
        field(21; JXVZTitle; Text[250])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Title', Comment = 'ESP=Titulo';
        }
        field(22; JXVZWitholdingAgent; Text[30])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Witholding agent', Comment = 'ESP=Agente de retencion';
        }
        field(23; JXVZMonotributo; Boolean)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Monotributo', Comment = 'ESP=Monotributo';
        }
        field(24; JXVZAccountNo; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Account No.', Comment = 'ESP=No. Cuenta';
            TableRelation = "G/L Account";
            ValidateTableRelation = true;
        }
        field(25; JXVZPaymentMethodCode; Code[10])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Payment method code', Comment = 'ESP=Metodo de pago';
            TableRelation = "Payment Method";
            ValidateTableRelation = true;
        }
        field(26; JXVZSeriesCode; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Series code', Comment = 'ESP=Codigo de serie';
            TableRelation = "No. Series";
            ValidateTableRelation = true;
        }
        field(27; JXVZReportID; Integer)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Report ID', Comment = 'ESP=ID reporte';
        }
        field(28; JXVZConditionCode; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Condition code', Comment = 'ESP=Codigo condicion';
            Description = 'JX';
            NotBlank = true;
            TableRelation = JXVZWithholdTaxCondition.JXVZConditionCode WHERE(JXVZTaxCode = FIELD(JXVZTaxCode));
        }

        field(29; JXVZReportDescription; Text[50])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Report description', Comment = 'ESP=Descripcion reporte';
        }

        field(30; JXVZLineDescription; Text[120])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Journal Description', Comment = 'Descripcion diario';
        }
        field(31; JXVZPostingSeriesCode; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Posting Series code', Comment = 'ESP=Codigo de serie registro';
            TableRelation = "No. Series";
            ValidateTableRelation = true;
        }
    }

    keys
    {
        key(Key1; JXVZWitholdingNo, JXVZTaxCode, JXVZRegime)
        {
        }
        key(Key3; JXVZTaxCode, JXVZRegime)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if JXVZWitholdingNo = 0 then
            JXVZWitholdingNo := "#LastRetainedNo"() + 1;
    end;

    procedure "#LastRetainedNo"(): Integer
    var
        JXVZWithholdDetailEntry: Record JXVZWithholdDetailEntry;
    begin
        JXVZWithholdDetailEntry.Reset();
        JXVZWithholdDetailEntry.SetCurrentKey(JXVZWitholdingNo);
        if not JXVZWithholdDetailEntry.FindLast() then
            Clear(JXVZWithholdDetailEntry);

        exit(JXVZWithholdDetailEntry.JXVZWitholdingNo);
    end;
}