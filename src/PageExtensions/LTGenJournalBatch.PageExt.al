pageextension 84114 JXVZGenJournalBatch extends "General Journal Batches"
{
    layout
    {
        addlast(Control1)
        {
            field(JXVZReceipt; Rec.JXVZReceipt)
            {
                Visible = IsVenezuela;
                ToolTip = 'Receipt', Comment = 'ESP=Recibo';
                ApplicationArea = all;
            }

            field(JXVZPaymOrder; Rec.JXVZPaymOrder)
            {
                Visible = IsVenezuela;
                ToolTip = 'Payment order', Comment = 'ESP=Orden de pago';
                ApplicationArea = all;
            }
        }
    }

    trigger OnOpenPage()
    begin
        IsVenezuela := CompanyInformation.JXIsVenezuela();
    end;

    var
        CompanyInformation: Record "Company Information";


        IsVenezuela: Boolean;

}