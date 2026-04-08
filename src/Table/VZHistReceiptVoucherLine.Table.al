table 84108 JXVZHistReceiptVoucherLine
{
    //Caption = 'Registered receipt voucher', Comment = 'ESP=Recibo voucher registrado';
    DataPerCompany = true;

    fields
    {
        field(1; "JXVZReceiptNo"; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Receipt no.', Comment = 'ESP=No. Recibo';
        }
        field(2; "JXVZVoucherNo"; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Voucher no.', Comment = 'ESP=No. voucher';
        }
        field(3; JXVZDate; Date)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Date', Comment = 'ESP=Fecha';
        }
        field(4; JXVZAmount; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Amount', Comment = 'ESP=Importe';
        }
        field(5; JXVZRemainingAmount; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Remaining amount', Comment = 'ESP=Importe pendiente';
        }
        field(6; JXVZCustomer; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Customer', Comment = 'ESP=Cliente';
        }
        field(7; JXVZDocumentType; Option)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Document type', Comment = 'ESP=Tipo documento';
            OptionCaption = ' ,Payment,Invoice,Credit Note,Finance Charge Memo,Reminder,Refund,Vencimiento,Conversion,Bill,Debit Note';
            OptionMembers = " ",Pago,Factura,"Nota d/c","Docs.interés",Recordatorio,Reembolso,Vencimiento,Conversion,Efecto,"Nota Débito";
        }
        field(8; JXVZCancelled; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Cancelled', Comment = 'ESP=Cancelado';
        }
        field(11; JXVZEntryNo; Integer)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Entry no.', Comment = 'ESP=No. entrada';
        }
        field(13; JXVZCurrencyCode; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Currency code', Comment = 'ESP=Codigo divisa';
        }
        field(14; JXVZCurrencyFactor; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Currency factor', Comment = 'ESP=Factor divisa';
            DecimalPlaces = 0 : 15;
            Editable = true;
            MinValue = 0;
        }
    }

    keys
    {
        key(Key1; JXVZReceiptNo, JXVZVoucherNo, JXVZEntryNo)
        {
            SumIndexFields = JXVZRemainingAmount, JXVZCancelled;
        }
    }

    procedure GetLastEntryNo(): Integer
    var
        AuxRec: Record JXVZHistReceiptVoucherLine;
        NextEntryNo: Integer;
    begin
        AuxRec.Reset();
        if AuxRec.FindLast() then
            NextEntryNo := AuxRec.JXVZEntryNo + 1
        else
            NextEntryNo := 1;

        exit(NextEntryNo);
    end;
}