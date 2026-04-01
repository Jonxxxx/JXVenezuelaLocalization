page 84122 JXVZWithholdDetailEntry
{
    Caption = 'Witholding detail', Comment = 'ESP=Detalle retencion';
    PageType = List;
    SourceTable = JXVZWithholdDetailEntry;
    SourceTableView = SORTING(JXVZWitholdingNo, JXVZTaxCode, JXVZRegime)
                      ORDER(Ascending);
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field(JXVZWitholdingNo; Rec.JXVZWitholdingNo)
                {
                    ApplicationArea = All;
                    Tooltip = 'Witholding no.', Comment = 'ESP=No. Retencion';
                }
                field(JXVZTaxCode; Rec.JXVZTaxCode)
                {
                    ApplicationArea = All;
                    Tooltip = 'Tax code', Comment = 'ESP=Codigo impuesto';
                }
                field(JXVZRegime; Rec.JXVZRegime)
                {
                    ApplicationArea = All;
                    Tooltip = 'Regime', Comment = 'ESP=Regimen';
                }
                field(JXVZDescription; Rec.JXVZDescription)
                {
                    ApplicationArea = All;
                    Tooltip = 'Description', Comment = 'ESP=Descripcion';
                }
                field(JXVZAccountNo; Rec.JXVZAccountNo)
                {
                    ApplicationArea = All;
                    Tooltip = 'Account No.', Comment = 'ESP=No. Cuenta';
                }
                field(JXVZWitholdingBaseType; Rec.JXVZWitholdingBaseType)
                {
                    ApplicationArea = All;
                    Tooltip = 'Witholding Base Type', Comment = 'ESP=Tipo Retencion base';
                }
                field(JXVZAccumulativeCalculation; Rec.JXVZAccumulativeCalculation)
                {
                    ApplicationArea = All;
                    Tooltip = 'Accumulative Calculation', Comment = 'ESP=Calculo acumulativo';
                }
                field(JXVZMinimumWitholding; Rec.JXVZMinimumWitholding)
                {
                    ApplicationArea = All;
                    Tooltip = 'Minimum Witholding', Comment = 'ESP=Retencion minima';
                }
                field(JXVZScaleCode; Rec.JXVZScaleCode)
                {
                    ApplicationArea = All;
                    Tooltip = 'Scale Code', Comment = 'ESP=Codigo escala';
                }
                field(JXVZAccumulationPeriod; Rec.JXVZAccumulationPeriod)
                {
                    ApplicationArea = All;
                    Tooltip = 'Accumulation period', Comment = 'ESP=Periodo acumulacion';
                }
                field(JXVZPaymentMethodCode; Rec.JXVZPaymentMethodCode)
                {
                    ApplicationArea = All;
                    Tooltip = 'Payment method code', Comment = 'ESP=Metodo de pago';
                }
                field(JXVZSeriesCode; Rec.JXVZSeriesCode)
                {
                    ApplicationArea = All;
                    Tooltip = 'Series code', Comment = 'ESP=Codigo de serie';
                }
                field(JXVZPostingSeriesCode; Rec.JXVZPostingSeriesCode)
                {
                    ApplicationArea = All;
                    Tooltip = 'Posting Series code', Comment = 'ESP=Codigo de serie registro';
                }

                field(JXVZLineDescription; Rec.JXVZLineDescription)
                {
                    ApplicationArea = All;
                    Tooltip = 'Journal Description', Comment = 'Descripcion diario';
                }
                field(JXVZReportID; Rec.JXVZReportID)
                {
                    ApplicationArea = All;
                    Tooltip = 'Report ID', Comment = 'ESP=ID reporte';
                }

                field(JXVZReportDescription; Rec.JXVZReportDescription)
                {
                    ApplicationArea = All;
                    Tooltip = 'Report description', Comment = 'ESP=Descripcion reporte';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
        }
    }
}

