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
                field(JXVZRIF; Rec.JXVZRIF)
                {
                    ApplicationArea = All;
                    Tooltip = 'NIF', Comment = 'ESP=RIF';
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