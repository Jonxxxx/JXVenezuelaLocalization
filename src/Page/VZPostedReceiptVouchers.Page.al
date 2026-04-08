page 84117 JXVZPostedReceiptVouchers
{
    Caption = 'Registered receipt voucher', Comment = 'ESP=Comprobante de recibo registrado';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    //UsageCategory = None;
    PageType = ListPart;
    SourceTable = JXVZHistReceiptVoucherLine;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                Editable = false;
                ShowCaption = false;
                field(JXVZDocumentType; Rec.JXVZDocumentType)
                {
                    ApplicationArea = All;
                    ToolTip = 'Document type', Comment = 'ESP=Tipo documento';
                }
                field(JXVZVoucherNo; Rec.JXVZVoucherNo)
                {
                    ApplicationArea = All;
                    ToolTip = 'Voucher no.', Comment = 'ESP=No. voucher';

                    trigger OnDrillDown()
                    begin
                        if (Rec.JXVZVoucherNo <> 'PAGO A CUENTA') and ((Rec.JXVZDocumentType = Rec.JXVZDocumentType::Factura) or
                                                                (Rec.JXVZDocumentType = Rec.JXVZDocumentType::Vencimiento)) then begin
                            PurchInvHeader.SetRange("No.", Rec.JXVZVoucherNo);
                            PAGE.RunModal(PAGE::"Posted Sales Invoice", PurchInvHeader);
                        end;
                        if (Rec.JXVZVoucherNo <> 'PAGO A CUENTA') and (Rec.JXVZDocumentType <> Rec.JXVZDocumentType::Factura)
                                                                and (Rec.JXVZDocumentType <> Rec.JXVZDocumentType::Vencimiento)
                       then begin
                            JXVZHistoryReceiptHeader.Reset();
                            JXVZHistoryReceiptHeader.SetRange(JXVZHistoryReceiptHeader.JXVZReceiptNo, Rec.JXVZVoucherNo);
                            PAGE.RunModal(PAGE::JXVZPostedReceipt, JXVZHistoryReceiptHeader);
                        end;
                    end;
                }
                field(JXVZAmount; Rec.JXVZAmount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Amount', Comment = 'ESP=Importe';
                }
                field(JXVZCurrencyCode; Rec.JXVZCurrencyCode)
                {
                    ApplicationArea = All;
                    ToolTip = 'Currency code', Comment = 'ESP=Codigo divisa';
                }
            }
        }
    }

    var
        PurchInvHeader: Record "Sales Invoice Header";
        JXVZHistoryReceiptHeader: Record JXVZHistoryReceiptHeader;
}

