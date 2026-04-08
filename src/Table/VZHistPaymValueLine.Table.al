table 84131 JXVZHistPaymValueLine
{
    fields
    {
        field(1; JXVZNo; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'No.', Comment = 'ESP=No.';
        }
        field(3; JXVZDescription; Text[50])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Description', Comment = 'ESP=Descripcion';
        }
        field(4; JXVZValueNo; Code[30])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Value no.', Comment = 'ESP=No. valor';
        }
        field(5; JXVZAmount; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Amount', Comment = 'ESP=Importe';
        }
        field(7; JXVZLineNo; Integer)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Line no.', Comment = 'ESP=No. linea';
        }
        field(8; JXVZSeriesCode; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Series code', Comment = 'ESP=Codigo serie';
        }
        field(9; JXVZEntity; Text[100])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Entity', Comment = 'ESP=Entidad';
        }
        field(10; JXVZToDate; Date)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'To Date', Comment = 'ESP=A fecha';
        }
        field(11; JXVZClearing; Integer)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Clearing', Comment = 'ESP=Clearing';
        }
        field(12; JXVZComment; Text[100])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Comment', Comment = 'ESP=Comentario';
        }
        field(13; JXVZAccountNo; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Account no.', Comment = 'ESP=No. Cuenta';
        }
        field(15; JXVZTotalAmount; Decimal)
        {
            Caption = 'Total amount', Comment = 'ESP=Importe total';
            FieldClass = FlowField;
        }
        field(16; JXVZAmountLCY; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Amount (LCY)', Comment = 'ESP=Importe (LCY)';
        }
        field(17; JXVZCurrencyCode; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Currency code', Comment = 'ESP=Codigo divisa';
        }
        field(18; JXVZCurrencyFactor; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Currency factor', Comment = 'ESP=Tipo de cambio';
        }
        field(31; JXVZDocumentDate; Date)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Document date', Comment = 'ESP=Fecha documento';
        }
        field(32; JXVZAcreditationDate; Date)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Acreditation date', Comment = 'ESP=Fecha acreditacion';
        }
        field(33; JXVZWitholdingNo; Integer)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Witholding no.', Comment = 'ESP=No. Retencion';
        }
    }

    keys
    {
        key(Key1; JXVZNo, JXVZLineNo)
        {
            SumIndexFields = JXVZAmount;
        }
    }
}