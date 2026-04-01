page 84112 JXVZPostedReceipt
{
    Caption = 'Registered receipt', Comment = 'ESP=Recibos registrados';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Document;
    SourceTable = JXVZHistoryReceiptHeader;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General', Comment = 'ESP=General';
                Editable = false;
                field(JXVZReceiptNo; Rec.JXVZReceiptNo)
                {
                    ApplicationArea = All;
                    Tooltip = 'No.', Comment = 'ESP=No.';
                }
                field(JXVZCustomerNo; Rec.JXVZCustomerNo)
                {
                    ApplicationArea = All;
                    Tooltip = 'Customer no.', Comment = 'ESP=No. Cliente';
                    Editable = false;
                }
                field(JXVZName; Rec.JXVZName)
                {
                    ApplicationArea = All;
                    Tooltip = 'Name', Comment = 'ESP=Nombre';
                }
                field(JXVZCuit; Rec.JXVZCuit)
                {
                    ApplicationArea = All;
                    Tooltip = 'NIF', Comment = 'ESP=CUIT';
                    Visible = IsVenezuela;
                }

                field(JXVZAddress; Rec.JXVZAddress)
                {
                    ApplicationArea = All;
                    Tooltip = 'Address', Comment = 'ESP=Direccion';
                }
                field(JXVZPostingDate; Rec.JXVZPostingDate)
                {
                    ApplicationArea = All;
                    Tooltip = 'Posting date', Comment = 'ESP=Fecha registro';
                }
                field(JXVZDocumentDate; Rec.JXVZDocumentDate)
                {
                    ApplicationArea = All;
                    Tooltip = 'Document date', Comment = 'ESP=Fecha documento';
                }
                field(JXVZStatus; Rec.JXVZStatus)
                {
                    ApplicationArea = All;
                    ToolTip = 'Status receipt', Comment = 'ESP=Estado recibo';
                }
                field(JXVZAmount; Rec.JXVZAmount)
                {
                    ApplicationArea = All;
                    Tooltip = 'Amount', Comment = 'ESP=Importe';
                }
                field(JXVZCurrencyCode; rec.JXVZCurrencyCode)
                {
                    ApplicationArea = All;
                    ToolTip = 'Currency Code', Comment = 'ESP=Cod. Divisa';
                }
                field(JXVZCurrencyFactor; rec.JXVZCurrencyFactor)
                {
                    ApplicationArea = All;
                    ToolTip = 'Currency Factor', Comment = 'ESP=Tipo de cambio';
                }
            }
            part(LinComprobantes; JXVZPostedReceiptVouchers)
            {
                ApplicationArea = All;
                Editable = false;
                SubPageLink = JXVZReceiptNo = FIELD(JXVZReceiptNo);
            }
            part(SubFormValor; JXVZPostedReceiptValues)
            {
                ApplicationArea = All;
                Editable = false;
                SubPageLink = JXVZReceiptNo = FIELD(JXVZReceiptNo);
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("&Imprimir")
            {
                ApplicationArea = All;
                ToolTip = 'Print', Comment = 'ESP=Imprimir';
                Caption = 'Print', Comment = 'ESP=Imprimir';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    //JXVZ (01)
                    JXVZPaymentSetup.Get();
                    CurrPage.SetSelectionFilter(JXVZHistoryReceiptHeader);
                    REPORT.RunModal(JXVZPaymentSetup.JXVZHistReceiptReport, true, false, JXVZHistoryReceiptHeader);
                    //REPORT.RunModal(84103, true, false, JXVZHistoryReceiptHeader);
                    //JXVZ (01) END
                end;
            }
            action("&Navegar")
            {
                ApplicationArea = All;
                ToolTip = 'Navigate', Comment = 'ESP=Navegar';
                Caption = 'Navigate', Comment = 'ESP=Navegar';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    gNavigate.SetDoc(Rec.JXVZDocumentDate, Rec.JXVZReceiptNo);
                    gNavigate.Run();
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
                    SendRCMail(Rec);
                end;
            }

            action(First)
            {
                ApplicationArea = All;
                ToolTip = 'First', Comment = 'ESP=Primero';
                Caption = 'First', Comment = 'ESP=Primero';
                Image = PreviousSet;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    rec.Reset();
                    if rec.FindFirst() then
                        rec.SetRange(JXVZReceiptNo, rec.JXVZReceiptNo);
                end;
            }

            action(Previous)
            {
                ApplicationArea = All;
                ToolTip = 'Previous', Comment = 'ESP=Anterior';
                Caption = 'Previous', Comment = 'ESP=Anterior';
                Image = PreviousRecord;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    rec.Reset();
                    rec.SetFilter(JXVZReceiptNo, '<%1', rec.JXVZReceiptNo);
                    if not rec.findlast() then begin
                        rec.SetRange(JXVZReceiptNo, xRec.JXVZReceiptNo);
                        if rec.FindFirst() then;
                    end;
                end;
            }

            action(Next)
            {
                ApplicationArea = All;
                ToolTip = 'Next', Comment = 'ESP=Proximo';
                Caption = 'Next', Comment = 'ESP=Proximo';
                Image = NextRecord;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    rec.Reset();
                    rec.SetFilter(JXVZReceiptNo, '>%1', rec.JXVZReceiptNo);
                    if not rec.findlast() then begin
                        rec.SetRange(JXVZReceiptNo, xRec.JXVZReceiptNo);
                        if rec.FindFirst() then;
                    end;
                end;
            }

            action(Last)
            {
                ApplicationArea = All;
                ToolTip = 'Last', Comment = 'ESP=Ultimo';
                Caption = 'Last', Comment = 'ESP=Ultimo';
                Image = NextSet;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    rec.Reset();
                    if rec.FindLast() then
                        rec.SetRange(JXVZReceiptNo, rec.JXVZReceiptNo);
                end;
            }
        }
    }

    procedure SendRCMail(_JXVZHistoryReceiptHeader: Record JXVZHistoryReceiptHeader): Boolean
    var
        CompanyInformation: Record "Company Information";
        Customer: Record Customer;
        JXVZPaymentSetup: Record JXVZPaymentSetup;
        JXVZHistoryReceiptHeaderLocal: Record JXVZHistoryReceiptHeader;
        ReportRC: Report JXVZReceipt;
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

        JXVZPaymentSetup.TestField(JXVZBodyRCMail);

        ReportToSend := JXVZPaymentSetup.JXVZHistReceiptReport;//Receipt report

        CompanyInformation.Get();

        Customer.Reset();
        Customer.SetRange("No.", _JXVZHistoryReceiptHeader.JXVZCustomerNo);
        if Customer.FindFirst() then
            Customer.TestField("E-Mail")
        else
            Customer.TestField("No.");

        ToAddr.Add(Customer."E-Mail");

        Subject := 'Recibo ' + _JXVZHistoryReceiptHeader.JXVZReceiptNo;
        Body := StrSubstNo(JXVZPaymentSetup.JXVZBodyRCMail, Customer.Name, _JXVZHistoryReceiptHeader.JXVZPostingDate, _JXVZHistoryReceiptHeader.JXVZReceiptNo, CompanyInformation.Name);
        AttachmentName := 'RC' + _JXVZHistoryReceiptHeader.JXVZReceiptNo + '.pdf';

        Clear(ReportRC);
        ReportRC.SetTableView(_JXVZHistoryReceiptHeader);
        TempBlob.CreateInStream(inStreamReport, TEXTENCODING::UTF8);
        TempBlob.CreateOutStream(outStreamReport, TEXTENCODING::UTF8);

        clear(RecRef);
        JXVZHistoryReceiptHeaderLocal.Reset();
        JXVZHistoryReceiptHeaderLocal.SetRange(JXVZReceiptNo, _JXVZHistoryReceiptHeader.JXVZReceiptNo);
        RecRef.GetTable(JXVZHistoryReceiptHeaderLocal);

        Report.SaveAs(ReportToSend, '', ReportFormat::Pdf, outStreamReport, RecRef);

        //Create Email
        Clear(Email);
        Clear(EmailMessage);
        EmailMessage.Create(Customer."E-Mail", Subject, Body);
        EmailMessage.AddAttachment(AttachmentName, 'PDF', inStreamReport);

        //Send mail
        exit(Email.Send(EmailMessage, Enum::"Email Scenario"::JXVZReceipt));
    end;

    trigger OnOpenPage()
    begin
        IsVenezuela := CompanyInformation.JXIsVenezuela();


    end;

    var
        JXVZHistoryReceiptHeader: Record JXVZHistoryReceiptHeader;
        JXVZPaymentSetup: Record JXVZPaymentSetup;
        gNavigate: Page Navigate;
        CompanyInformation: Record "Company Information";
        IsVenezuela: Boolean;


}