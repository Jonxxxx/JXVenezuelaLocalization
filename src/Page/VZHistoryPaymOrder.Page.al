page 84131 JXVZHistoryPaymOrder
{
    Caption = 'Registered payment order', Comment = 'ESP=Orden de pago registrada';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Document;
    SourceTable = JXVZHistoryPaymOrder;
    //UsageCategory = None;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General', Comment = 'ESP=General';
                Editable = false;
                field(JXVZNo; Rec.JXVZNo)
                {
                    Tooltip = 'No.', Comment = 'ESP=No.';
                    ApplicationArea = All;
                }
                field(JXVZVendorNo; Rec.JXVZVendorNo)
                {
                    Tooltip = 'Vendor No.', Comment = 'ESP=Codigo proveedor';
                    ApplicationArea = All;
                }
                field(JXVZName; Rec.JXVZName)
                {
                    Tooltip = 'Name', Comment = 'ESP=Nombre';
                    ApplicationArea = All;
                }
                field(JXVZAddress; Rec.JXVZAddress)
                {
                    Tooltip = 'Address', Comment = 'ESP=Direccion';
                    ApplicationArea = All;
                }
                field(JXVZConcept; Rec.JXVZConcept)
                {
                    Tooltip = 'Concept', Comment = 'ESP=Concepto';
                    ApplicationArea = All;
                }
                field(JXVZPostingDate; Rec.JXVZPostingDate)
                {
                    Tooltip = 'Posting date', Comment = 'ESP=Fecha registro';
                    ApplicationArea = All;
                }
                field(JXVZDocumentDate; Rec.JXVZDocumentDate)
                {
                    Tooltip = 'Document date', Comment = 'ESP=Fecha documento';
                    ApplicationArea = All;
                }
                field(JXVZStatus; Rec.JXVZStatus)
                {
                    Tooltip = 'Status', Comment = 'ESP=Estado';
                    ApplicationArea = All;
                }
                field(JXVZAmountLCY; Rec.JXVZAmountLCY)
                {
                    Tooltip = 'Amount', Comment = 'ESP=Importe';
                    ApplicationArea = All;
                    Editable = false;
                }
            }
            part(JXVZPostedPOVouchers; JXVZPostedPOVouchers)
            {
                ApplicationArea = All;
                Editable = false;
                SubPageLink = JXVZPaymentOrderNo = FIELD(JXVZNo);
            }
            part(JXVZPostedPOValues; JXVZPostedPOValues)
            {
                ApplicationArea = All;
                Editable = false;
                SubPageLink = JXVZNo = FIELD(JXVZNo);
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Imprimir)
            {
                ApplicationArea = All;
                Caption = 'Payment order', Comment = 'ESP=Orden de pago';
                ToolTip = 'Payment order', Comment = 'ESP=Orden de pago';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    PostedPaymentOrder: Record JXVZHistoryPaymOrder;
                begin
                    JXVZPaymentSetup.Reset();
                    JXVZPaymentSetup.Get();

                    PostedPaymentOrder.Reset();
                    PostedPaymentOrder.SetRange(JXVZNo, Rec.JXVZNo);
                    if PostedPaymentOrder.FindFirst() then begin
                        PostedPaymentOrder.SetRecFilter();
                        REPORT.RunModal(JXVZPaymentSetup.JXVZHisPaymentReport, true, false, PostedPaymentOrder);
                    end;
                end;
            }

            action(ImprimirWithholding)
            {
                ApplicationArea = All;
                Caption = 'Withholdings', Comment = 'ESP=Retenciones';
                ToolTip = 'Withholdings', Comment = 'ESP=Retenciones';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    JXVZWithholdLedgerEntryLocal: Record JXVZWithholdLedgerEntry;
                    JXVZWithholdDetailEntryLocal: Record JXVZWithholdDetailEntry;
                    JXVZPostedValuesLine: Record JXVZHistPaymValueLine;
                begin

                    JXVZPostedValuesLine.Reset();
                    JXVZPostedValuesLine.SetRange(JXVZPostedValuesLine.JXVZNo, Rec.JXVZNo);
                    JXVZPostedValuesLine.SetFilter(JXVZPostedValuesLine.JXVZWitholdingNo, '<>%1', 0);
                    if JXVZPostedValuesLine.FindSet() then
                        repeat
                            JXVZWithholdLedgerEntryLocal.Reset();
                            JXVZWithholdLedgerEntryLocal.SetRange(JXVZWithholdLedgerEntryLocal.JXVZVoucherNo, JXVZPostedValuesLine.JXVZNo);
                            JXVZWithholdLedgerEntryLocal.SetRange(JXVZWitholdingNo, JXVZPostedValuesLine.JXVZWitholdingNo);
                            if JXVZWithholdLedgerEntryLocal.FindSet() then
                                repeat
                                    JXVZWithholdDetailEntryLocal.Reset();
                                    JXVZWithholdDetailEntryLocal.SetRange(JXVZWithholdDetailEntryLocal.JXVZWitholdingNo, JXVZWithholdLedgerEntryLocal.JXVZWitholdingNo);
                                    if JXVZWithholdDetailEntryLocal.FindFirst() then
                                        REPORT.RunModal(JXVZWithholdDetailEntryLocal.JXVZReportID, true, false, JXVZWithholdLedgerEntryLocal);

                                until JXVZWithholdLedgerEntryLocal.Next() = 0;

                        until JXVZPostedValuesLine.Next() = 0;
                end;
            }

            action("&Navegar")
            {
                ApplicationArea = All;
                Caption = 'Navigate', Comment = 'ESP=Navegar';
                ToolTip = 'Navigate', Comment = 'ESP=Navegar';
                Image = Navigate;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Navegar.SetDoc(Rec.JXVZPostingDate, Rec.JXVZNo);
                    Navegar.Run();
                end;
            }

            action(CancelStatus)
            {
                Caption = 'Change to Cancel Status';
                ToolTip = 'Change to Cancel Status';
                ApplicationArea = All;
                Image = CancelIndent;
                Visible = superUser;
                Enabled = superUser;

                trigger OnAction()
                begin
                    Rec.JXVZStatus := rec.JXVZStatus::Cancelled;
                    CurrPage.Update();
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        superUser := false;
        CompanyInfo.Reset();
        if CompanyInfo.FindFirst() then begin
            User.Reset();
            User.SetRange(user."User Security ID", CompanyInfo.JXVZLocAdminUser);
            if User.FindFirst() then
                if UserId() = user."User Name" then
                    superUser := true;
        end;
    end;

    var
        JXVZPaymentSetup: Record JXVZPaymentSetup;
        CompanyInfo: Record "Company Information";
        User: Record User;
        superUser: Boolean;
        Navegar: Page Navigate;
}

