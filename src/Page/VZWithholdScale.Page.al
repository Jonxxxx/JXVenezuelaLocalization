page 84123 JXVZWithholdScale
{
    Caption = 'Witholding scale', Comment = 'ESP=Escala retencion';
    PageType = List;
    SourceTable = JXVZWithholdScale;
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                ShowCaption = false;

                field(JXVZScaleCode; Rec.JXVZScaleCode)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the scale code.';
                }
                field(JXVZTaxCode; Rec.JXVZTaxCode)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the withholding tax code.';
                }
                field(JXVZWitholdingCondition; Rec.JXVZWitholdingCondition)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the withholding condition.';
                }
                field(JXVZRegime; Rec.JXVZRegime)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the withholding regime.';
                }
                field(JXVZCalculationFormula; Rec.JXVZCalculationFormula)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the calculation formula used for this scale.';
                }
                field(JXVZFrom; Rec.JXVZFrom)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the amount from which this scale applies.';
                }
                field(JXVZTo; Rec.JXVZTo)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the amount up to which this scale applies.';
                }
                field(JXVZFixedAmount; Rec.JXVZFixedAmount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the fixed amount for the scale.';
                }
                field(JXVZBaseAmount; Rec.JXVZBaseAmount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the base amount used in the scale calculation.';
                }
                field(JXVZSurplus; Rec.JXVZSurplus)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the percentage applied to the surplus amount.';
                }
                field(JXVZTaxableBasePct; Rec.JXVZTaxableBasePct)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the taxable base percentage to apply before calculating the withholding.';
                }
                field(JXVZDeductionAmount; Rec.JXVZDeductionAmount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the deduction amount or sustraendo.';
                }
                field(JXVZMinimumPaymentAmount; Rec.JXVZMinimumPaymentAmount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the minimum payment amount required for the scale to apply.';
                }
                field(JXVZUseTaxUnit; Rec.JXVZUseTaxUnit)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the scale uses Tax Unit values.';
                }

                field(JXVZValidFrom; Rec.JXVZValidFrom)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the starting date from which this scale is valid.';
                }
                field(JXVZValidTo; Rec.JXVZValidTo)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the ending date until which this scale is valid.';
                }
                field(JXVZMunicipalityCode; Rec.JXVZMunicipalityCode)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the municipality code for municipal withholdings.';
                }
                field(JXVZEconomicActivityCode; Rec.JXVZEconomicActivityCode)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the economic activity code.';
                }
                field(JXVZEconomicActivityDescription; Rec.JXVZEconomicActivityDescription)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the economic activity description.';
                }
                field(JXVZMonotributoIVA; Rec.JXVZMonotributoIVA)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether Monotributo IVA applies.';
                }
            }
        }
    }

    actions
    {
    }
}