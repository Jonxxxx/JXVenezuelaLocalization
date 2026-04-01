page 84114 JXVZTreasuryValueEntries
{
    PageType = List;
    SourceTable = JXVZPaymentValueEntry;
    //UsageCategory = None;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(JXVZEntryNo; Rec.JXVZEntryNo)
                {
                    ApplicationArea = All;
                    ToolTip = 'JXVZEntryNo';
                }
                field(JXVZDocumentDate; Rec.JXVZDocumentDate)
                {
                    ApplicationArea = All;
                    ToolTip = 'JXVZDocumentDate';
                }
                field(JXVZDocumentType; Rec.JXVZDocumentType)
                {
                    ApplicationArea = All;
                    ToolTip = 'JXVZDocumentType';
                }
                field(JXVZDocumentNo; Rec.JXVZDocumentNo)
                {
                    ApplicationArea = All;
                    ToolTip = 'JXVZDocumentNo';
                }
                field(JXVZDescription; Rec.JXVZDescription)
                {
                    ApplicationArea = All;
                    ToolTip = 'JXVZDescription';
                }
                field(JXVZAmount; Rec.JXVZAmount)
                {
                    ApplicationArea = All;
                    ToolTip = 'JXVZAmount';
                }
                field(JXVZSeriesCode; Rec.JXVZSeriesCode)
                {
                    ApplicationArea = All;
                    ToolTip = 'JXVZSeriesCode';
                }
                field(JXVZEntity; Rec.JXVZEntity)
                {
                    ApplicationArea = All;
                    ToolTip = 'JXVZEntity';
                }
                field(JXVZToDate; Rec.JXVZToDate)
                {
                    ApplicationArea = All;
                    ToolTip = 'JXVZToDate';
                }
                field(JXVZUserId; Rec.JXVZUserId)
                {
                    ApplicationArea = All;
                    ToolTip = 'JXVZUserId';
                }
                field(JXVZPostingDate; Rec.JXVZPostingDate)
                {
                    ApplicationArea = All;
                    ToolTip = 'JXVZPostingDate';
                }
                field(JXVZCurrencyCode; Rec.JXVZCurrencyCode)
                {
                    ApplicationArea = All;
                    ToolTip = 'JXVZCurrencyCode';
                }
                field(JXVZValueNo; Rec.JXVZValueNo)
                {
                    ApplicationArea = All;
                    ToolTip = 'JXVZValueNo';
                }
                field(JXVZClearing; Rec.JXVZClearing)
                {
                    ApplicationArea = All;
                    ToolTip = 'JXVZClearing';
                }
                field(JXVZComment; Rec.JXVZComment)
                {
                    ApplicationArea = All;
                    ToolTip = 'JXVZComment';
                }
                field(JXVZGLAccount; Rec.JXVZGLAccount)
                {
                    ApplicationArea = All;
                    ToolTip = 'JXVZGLAccount';
                }
                field(JXVZUseGlAccount; Rec.JXVZUseGlAccount)
                {
                    ApplicationArea = All;
                    ToolTip = 'JXVZUseGlAccount';
                }
                field(JXVZOpen; Rec.JXVZOpen)
                {
                    ApplicationArea = All;
                    ToolTip = 'JXVZOpen';
                }
                field(JXVZAppliedByEntryNo; Rec.JXVZAppliedByEntryNo)
                {
                    ApplicationArea = All;
                    ToolTip = 'JXVZAppliedByEntryNo';
                }
                field(JXVZCurrencyFactor; Rec.JXVZCurrencyFactor)
                {
                    ApplicationArea = All;
                    ToolTip = 'JXVZCurrencyFactor';
                }
                field(JXVZRemainingAmount; Rec.JXVZRemainingAmount)
                {
                    ApplicationArea = All;
                    ToolTip = 'JXVZRemainingAmount';
                }
                field(JXVZAmountLCY; Rec.JXVZAmountLCY)
                {
                    ApplicationArea = All;
                    ToolTip = 'JXVZAmountLCY';
                }
                field(JXVZRemainingAmountLCY; Rec.JXVZRemainingAmountLCY)
                {
                    ApplicationArea = All;
                    ToolTip = 'JXVZRemainingAmountLCY';
                }
                field(JXVZAppliedAtDate; Rec.JXVZAppliedAtDate)
                {
                    ApplicationArea = All;
                    ToolTip = 'JXVZAppliedAtDate';
                }
                field(JXVZInitialAmountLCY; Rec.JXVZInitialAmountLCY)
                {
                    ApplicationArea = All;
                    ToolTip = 'JXVZInitialAmountLCY';
                }
                field(JXVZClosedByAmount; Rec.JXVZClosedByAmount)
                {
                    ApplicationArea = All;
                    ToolTip = 'JXVZClosedByAmount';
                }
                field(JXVZClosedByAmountLCY; Rec.JXVZClosedByAmountLCY)
                {
                    ApplicationArea = All;
                    ToolTip = 'JXVZClosedByAmountLCY';
                }
                field(JXVZValueDate; Rec.JXVZValueDate)
                {
                    ApplicationArea = All;
                    ToolTip = 'JXVZValueDate';
                }
                field(JXVZAcreditationDate; Rec.JXVZAcreditationDate)
                {
                    ApplicationArea = All;
                    ToolTip = 'JXVZAcreditationDate';
                }
                field(JXVZEntrySourceType; Rec.JXVZEntrySourceType)
                {
                    ApplicationArea = All;
                    ToolTip = 'JXVZEntrySourceType';
                }
                field(JXVZEntrySourceCode; Rec.JXVZEntrySourceCode)
                {
                    ApplicationArea = All;
                    ToolTip = 'JXVZEntrySourceCode';
                }
                field(JXVZConciliationUserId; Rec.JXVZConciliationUserId)
                {
                    ApplicationArea = All;
                    ToolTip = 'JXVZConciliationUserId';
                }
                field(JXVZConciliationDate; Rec.JXVZConciliationDate)
                {
                    ApplicationArea = All;
                    ToolTip = 'JXVZConciliationDate';
                }
                field(JXVZExtractNo; Rec.JXVZExtractNo)
                {
                    ApplicationArea = All;
                    ToolTip = 'JXVZExtractNo';
                }
                field(JXVZDateFromExtract; Rec.JXVZDateFromExtract)
                {
                    ApplicationArea = All;
                    ToolTip = 'JXVZDateFromExtract';
                }
                field(JXVZToDateExtract; Rec.JXVZToDateExtract)
                {
                    ApplicationArea = All;
                    ToolTip = 'JXVZToDateExtract';
                }
                field(JXVZExternalDocumentNo; Rec.JXVZExternalDocumentNo)
                {
                    ApplicationArea = All;
                    ToolTip = 'JXVZExternalDocumentNo';
                }
                field(JXVZExcludeCashFlow; Rec.JXVZExcludeCashFlow)
                {
                    ApplicationArea = All;
                    ToolTip = 'JXVZExcludeCashFlow';
                }
                field(JXVZInterfaceTrackingNo; Rec.JXVZInterfaceTrackingNo)
                {
                    ApplicationArea = All;
                    ToolTip = 'JXVZInterfaceTrackingNo';
                }
                field(JXVZAccountNo; Rec.JXVZAccountNo)
                {
                    ApplicationArea = All;
                    ToolTip = 'JXVZAccountNo';
                }
            }
        }
    }

    actions
    {
    }
}