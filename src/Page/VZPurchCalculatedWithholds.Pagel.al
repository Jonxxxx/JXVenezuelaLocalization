page 84129 JXVZPurchCalculatedWithholds
{
    Caption = 'Calculated Withholdings', Comment = 'ESP=Retenciones calculadas';
    PageType = List;
    SourceTable = JXVZWithholdCalcLines;
    ApplicationArea = All;
    UsageCategory = None;
    Editable = false;
    ModifyAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                ShowCaption = false;

                field(JXVZPaymentOrderNo; Rec.JXVZPaymentOrderNo)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the internal process/document number.';
                }
                field(JXVZWitholdingNo; Rec.JXVZWitholdingNo)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the withholding setup entry number.';
                }
                field(JXVZTaxCode; Rec.JXVZTaxCode)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the tax code.';
                }
                field(JXVZRegime; Rec.JXVZRegime)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the withholding regime.';
                }
                field(JXVZGeneralWitholdingDescription; Rec.JXVZGeneralWitholdingDescription)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the withholding description.';
                }
                field(JXVZWitholdingCondition; Rec.JXVZWitholdingCondition)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the withholding condition.';
                }
                field(JXVZScaleCode; Rec.JXVZScaleCode)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the scale code used.';
                }
                field(JXVZBase; Rec.JXVZBase)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the calculation base.';
                }
                field(JXVZCalculatedWitholding; Rec.JXVZCalculatedWitholding)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the calculated withholding amount.';
                }
                field("JXVZWitholding%"; Rec."JXVZWitholding%")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the withholding percentage applied.';
                }
                field("JXVZExemption%"; Rec."JXVZExemption%")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the exemption percentage applied.';
                }
                field(JXVZPreviousPayments; Rec.JXVZPreviousPayments)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the previous accumulated base.';
                }
                field(JXVZMothlyWitholding; Rec.JXVZMothlyWitholding)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the accumulated withholding amount from the period.';
                }
                field(JXVZPreviousWitholdings; Rec.JXVZPreviousWitholdings)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the previous withholdings deducted from the current calculation.';
                }
                field(JXVZDocumentDate; Rec.JXVZDocumentDate)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the document date used for the calculation.';
                }
                field(JXVZWithholdingNumber; Rec.JXVZWithholdingNumber)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the withholding certificate or internal number.';
                }
                field(JXVZDistinctPerDocument; Rec.JXVZDistinctPerDocument)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the withholding is discriminated per document.';
                }
                field(JXVZAccumulativeCalculation; Rec.JXVZAccumulativeCalculation)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the withholding uses accumulative calculation.';
                }
            }
        }
    }

    actions
    {
    }
}