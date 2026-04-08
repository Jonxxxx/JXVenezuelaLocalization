page 84133 JXVZPostedPOVouchers
{
    Caption = 'Posted payment order vouchers', Comment = 'ESP=Comprobantes de orden de pago registrada';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    //UsageCategory = None;
    PageType = ListPart;
    SourceTable = JXVZHistPaymVoucherLine;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                Editable = false;
                ShowCaption = false;
                field(JXVZVoucherNo; Rec.JXVZVoucherNo)
                {
                    ApplicationArea = All;
                    Tooltip = 'Voucher no.', Comment = 'ESP=No. Comprobante';

                    trigger OnDrillDown()
                    begin
                        if (Rec.JXVZDocumentType = Rec.JXVZDocumentType::Factura) then begin
                            PurchInvHeader.Reset();
                            PurchInvHeader.SetRange("No.", Rec.JXVZVoucherNo);
                            PAGE.RunModal(PAGE::"Posted Purchase Invoice", PurchInvHeader);
                        end;
                    end;
                }
                field(JXVZDocumentType; Rec.JXVZDocumentType)
                {
                    ApplicationArea = All;
                    Tooltip = 'Document type', Comment = 'ESP=Tipo documento';
                }
                field(JXVZDate; Rec.JXVZDate)
                {
                    ApplicationArea = All;
                    Tooltip = 'Date', Comment = 'ESP=Fecha';
                }
                field(JXVZAmount; Rec.JXVZAmount)
                {
                    ApplicationArea = All;
                    Tooltip = 'Amount', Comment = 'ESP=Importe';
                }
                field(JXVZCurrencyCode; Rec.JXVZCurrencyCode)
                {
                    ApplicationArea = All;
                    Tooltip = 'Currency code', Comment = 'ESP=Codigo divisa';
                }
                field(JXVZCancelledAmount; Rec.JXVZCancelledAmount)
                {
                    ApplicationArea = All;
                    Tooltip = 'Cancelled amount', Comment = 'ESP=Importe cancelado';
                }
            }
        }
    }

    var
        PurchInvHeader: Record "Purch. Inv. Header";
}