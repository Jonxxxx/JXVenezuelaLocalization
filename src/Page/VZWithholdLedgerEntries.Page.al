page 84157 JXVZWithholdLedgerEntries
{
    Caption = 'Withholding Ledger Entries Venezuela', Comment = 'ESP=Movimientos de retenciones Venezuela';
    PageType = List;
    SourceTable = JXVZWithholdLedgerEntry;
    SourceTableView = sorting(JXVZVoucherDate, JXVZVoucherNo) order(descending);
    ApplicationArea = All;
    UsageCategory = History;
    Editable = false;
    CardPageId = JXVZWithholdLedgerEntries;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                ShowCaption = false;

                field(JXVZNo; Rec.JXVZNo)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the entry number.';
                }
                field(JXVZTaxCode; Rec.JXVZTaxCode)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the withholding tax code.';
                }
                field(JXVZVendorCode; Rec.JXVZVendorCode)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the vendor code.';
                }
                field(JXVZRegime; Rec.JXVZRegime)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the withholding regime.';
                }
                field(JXVZConditionCode; Rec.JXVZConditionCode)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the withholding condition code.';
                }
                field(JXVZVoucherCode; Rec.JXVZVoucherCode)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the voucher code.';
                }
                field(JXVZVoucherNo; Rec.JXVZVoucherNo)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the voucher number.';
                }
                field(JXVZVoucherDate; Rec.JXVZVoucherDate)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the voucher date.';
                }
                field(JXVZWitholdingDate; Rec.JXVZWitholdingDate)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the withholding date.';
                }
                field(JXVZVoucherAmount; Rec.JXVZVoucherAmount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the voucher amount.';
                }
                field(JXVZCalculationBase; Rec.JXVZCalculationBase)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the calculation base.';
                }
                field(JXVZBase; Rec.JXVZBase)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the withholding base.';
                }
                field("JXVZWitholding%"; Rec."JXVZWitholding%")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the withholding percentage.';
                }
                field(JXVZWitholdingAmount; Rec.JXVZWitholdingAmount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the withholding amount.';
                }
                field("JXVZExemption%"; Rec."JXVZExemption%")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the exemption percentage.';
                }
                field(JXVZWitholdingCertificateNo; Rec.JXVZWitholdingCertificateNo)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the withholding certificate number.';
                }
                field(JXVZWitholdingCertDate; Rec.JXVZWitholdingCertDate)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the withholding certificate date.';
                }
                field(JXVZProvinceCode; Rec.JXVZProvinceCode)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the province/state code.';
                }
                field(JXVZScaleCode; Rec.JXVZScaleCode)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the scale code.';
                }
                field(JXVZWitholdingNo; Rec.JXVZWitholdingNo)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the withholding setup number.';
                }
                field(JXVZWitholdingBaseType; Rec.JXVZWitholdingBaseType)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the withholding base type.';
                }
                field(JXVZWitholdingType; Rec.JXVZWitholdingType)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the withholding is made or suffered.';
                }
                field(JXVZDiscriminatePerDocument; Rec.JXVZDiscriminatePerDocument)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the withholding is discriminated per document.';
                }
                field(JXVZWitholdingMode; Rec.JXVZWitholdingMode)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the withholding mode.';
                }
                field(JXVZOperationCode; Rec.JXVZOperationCode)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the operation code.';
                }
                field(JXVZSicoreCode; Rec.JXVZSicoreCode)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the SICORE code.';
                }
                field(JXVZSicoreConditionCode; Rec.JXVZSicoreConditionCode)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the SICORE condition code.';
                }
                field(JXVZBoletinDate; Rec.JXVZBoletinDate)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the bulletin date.';
                }
                field(JXVZWithholdStatus; Rec.JXVZWithholdStatus)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the withholding status.';
                }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(ViewVendor)
            {
                ApplicationArea = All;
                Caption = 'Vendor', Comment = 'ESP=Proveedor';
                Image = Vendor;
                ToolTip = 'Open the related vendor card.';

                trigger OnAction()
                var
                    Vendor: Record Vendor;
                begin
                    if Vendor.Get(Rec.JXVZVendorCode) then
                        Page.Run(Page::"Vendor Card", Vendor);
                end;
            }
        }
    }
}