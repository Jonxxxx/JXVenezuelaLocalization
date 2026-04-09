enum 84102 JXVZWithholdScaleFormula
{
    Extensible = true;
    Caption = 'Withholding scale formula', Comment = 'ESP=Formula de escala de retención';

    value(0; StandardExcess)
    {
        Caption = 'Standard excess', Comment = 'ESP=Excedente estándar';
    }
    value(1; PercentageOnFullBase)
    {
        Caption = 'Percentage on full base', Comment = 'ESP=Porcentaje sobre base completa';
    }
    value(2; PercentageMinusDeduction)
    {
        Caption = 'Percentage minus deduction', Comment = 'ESP=Porcentaje menos sustraendo';
    }
    value(3; Tarifa2Accumulated)
    {
        Caption = 'Tarifa 2 accumulated', Comment = 'ESP=Tarifa 2 acumulada';
    }
    value(4; FixedAmountOnly)
    {
        Caption = 'Fixed amount only', Comment = 'ESP=Solo importe fijo';
    }
    value(5; NoWithhold)
    {
        Caption = 'No withhold', Comment = 'ESP=No retener';
    }
}