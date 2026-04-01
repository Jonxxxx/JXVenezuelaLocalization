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

            action(SendByMail)
            {
                ApplicationArea = All;
                Caption = 'Send by Email';
                ToolTip = 'Send by Email';
                Image = Email;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    SendOPMail(Rec);
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

    procedure SendOPMail(_JXVZHistoryPaymOrder: Record JXVZHistoryPaymOrder): Boolean
    var
        //SMTPMailSetup: Record "SMTP Mail Setup";
        CompanyInformation: Record "Company Information";
        Vendor: Record Vendor;
        JXVZHistoryPaymOrderLocal: Record JXVZHistoryPaymOrder;
        JXVZWithholdLedgerEntryLocal: Record JXVZWithholdLedgerEntry;
        JXVZWithholdDetailEntryLocal: Record JXVZWithholdDetailEntry;
        JXVZPostedValuesLine: Record JXVZHistPaymValueLine;
        JXVZPaymentSetup: Record JXVZPaymentSetup;
        ReportOP: Report JXVZPaymentOrder;
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        TempBlob: Codeunit "Temp Blob";
        RecRef: RecordRef;
        ReportToSend: Integer;
        Subject: Text[120];
        Body: Text[250];
        AttachmentName: Text[100];
        ToAddr: List of [Text];
        OutStreamReport: OutStream;
        InStreamReport: InStream;
        Out: OutStream;
        FileStream: InStream;
    begin
        JXVZPaymentSetup.Reset();
        if JXVZPaymentSetup.FindFirst() then;

        JXVZPaymentSetup.TestField(JXVZBodyOPMail);

        ReportToSend := JXVZPaymentSetup.JXVZHisPaymentReport;//84104; //Payment order report

        //SMTPMailSetup.GET();
        CompanyInformation.Get();

        Vendor.Reset();
        Vendor.SetRange("No.", _JXVZHistoryPaymOrder.JXVZVendorNo);
        if Vendor.FindFirst() then
            Vendor.TestField("E-Mail")
        else
            Vendor.TestField("No.");

        ToAddr.Add(Vendor."E-Mail");

        Subject := 'Orden de pago ' + _JXVZHistoryPaymOrder.JXVZNo;
        Body := StrSubstNo(JXVZPaymentSetup.JXVZBodyOPMail, Vendor.Name, _JXVZHistoryPaymOrder.JXVZPostingDate, _JXVZHistoryPaymOrder.JXVZNo, CompanyInformation.Name);
        AttachmentName := 'OP' + _JXVZHistoryPaymOrder.JXVZNo + '.pdf';

        Clear(ReportOP);
        ReportOP.SetTableView(_JXVZHistoryPaymOrder);
        TempBlob.CreateInStream(inStreamReport, TEXTENCODING::UTF8);
        TempBlob.CreateOutStream(outStreamReport, TEXTENCODING::UTF8);

        clear(RecRef);
        JXVZHistoryPaymOrderLocal.Reset();
        JXVZHistoryPaymOrderLocal.SetRange(JXVZNo, _JXVZHistoryPaymOrder.JXVZNo);
        RecRef.GetTable(JXVZHistoryPaymOrderLocal);

        Report.SaveAs(ReportToSend, '', ReportFormat::Pdf, outStreamReport, RecRef);

        //Create Email
        Clear(Email);
        Clear(EmailMessage);
        EmailMessage.Create(Vendor."E-Mail", Subject, Body);
        EmailMessage.AddAttachment(AttachmentName, 'PDF', inStreamReport);

        //withholdings certs
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
                        if JXVZWithholdDetailEntryLocal.FindFirst() then begin
                            Clear(Out);
                            clear(RecRef);
                            clear(TempBlob);
                            clear(FileStream);

                            AttachmentName := 'CertRet_' + _JXVZHistoryPaymOrder.JXVZNo + '_' + JXVZWithholdDetailEntryLocal.JXVZReportDescription + '.pdf';

                            RecRef.GetTable(JXVZWithholdLedgerEntryLocal);
                            TempBlob.CreateInStream(FileStream, TEXTENCODING::UTF8);
                            TempBlob.CreateOutStream(Out, TEXTENCODING::UTF8);

                            REPORT.SAVEAS(JXVZWithholdDetailEntryLocal.JXVZReportID, '', REPORTFORMAT::Pdf, Out, RecRef);

                            EmailMessage.AddAttachment(AttachmentName, 'PDF', FileStream);
                        end;
                    until JXVZWithholdLedgerEntryLocal.Next() = 0;

            until JXVZPostedValuesLine.Next() = 0;

        //Send mail
        exit(Email.Send(EmailMessage, Enum::"Email Scenario"::JXVZPaymentOrder));

        //SMTPMail.CreateMessage(CompanyInformation.Name, SMTPMailSetup."User ID", ToAddr, Subject, Body);
        //SMTPMail.AddAttachmentStream(inStreamReport, AttachmentName);
        //Send mail
        //exit(SMTPMail.Send());
    end;

    trigger OnOpenPage()
    begin
        superUser := false;
        CompanyInfo.Reset();
        if CompanyInfo.FindFirst() then begin
            User.Reset();
            User.SetRange(user."User Security ID", CompanyInfo.JXLocAdminUser);
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

